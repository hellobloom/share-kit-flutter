import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr/qr.dart';
import 'package:share_kit/src/elements/utils.dart';
import 'package:share_kit/src/types.dart';

class RequestQRCode extends StatelessWidget {
  RequestData requestData;
  QROptions qrOptions;
  QrCode _qr;

  RequestQRCode({@required this.requestData, QROptions qrOptions})
      : this.qrOptions = qrOptions ?? QROptions() {
    _qr = QrCode.fromData(
        data: jsonEncode(requestData.toJson()),
        errorCorrectLevel: this.qrOptions.ecLevel);
    _qr.make();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: qrOptions.size,
          height: qrOptions.size,
          color: qrOptions.bgColor,
          child: Padding(
              padding: EdgeInsets.all(qrOptions.padding),
              child: FutureBuilder<ui.Image>(
                  future: getLogoImage(),
                  builder:
                      (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      var _qrPainter = _QrPainter(
                          qr: _qr,
                          qrOptions: qrOptions,
                          logoImage: snapshot.data,
                          onError: (dynamic error) {
                            throw error;
                          });
                      return CustomPaint(
                        painter: _qrPainter,
                      );
                    } else {
                      return Container();
                    }
                  })),
        );
      },
    );
  }

  Future<ui.Image> getLogoImage() async {
    var cellSize = qrOptions.size / _qr.moduleCount.toDouble();
    var numberOfCellsToCover = (_qr.moduleCount * 0.2).floor();
    var addExtra = numberOfCellsToCover % 2 == 0;
    var defaultWidth =
        numberOfCellsToCover * cellSize + (addExtra ? cellSize : 0);
    var dwidth = qrOptions.logoWidth ?? defaultWidth;
    var dheight = qrOptions.logoHeight ?? dwidth;
    var logoSvgDrawable = await svg.fromSvgString(
        getBloomWithLogo(
            bgColor:
                '#${(qrOptions.bgColor.value & 0xffffff).toRadixString(16)}',
            fgColor:
                '#${(qrOptions.fgColor.value & 0xffffff).toRadixString(16)}'),
        'bloomLogo');
    return await logoSvgDrawable
        .toPicture(size: Size(dwidth, dheight))
        .toImage(dwidth.round(), dheight.round());
  }
}

typedef QrError = void Function(dynamic error);

class _QrPainter extends CustomPainter {
  _QrPainter({
    @required this.qr,
    this.qrOptions,
    this.onError,
    this.logoImage,
  }) {
    _paint.color = qrOptions.fgColor;
  }

  final QrCode qr;
  final QROptions qrOptions;
  final QrError onError;
  final ui.Image logoImage;

  final Paint _paint = Paint()
    ..style = PaintingStyle.fill
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = 1;
  bool _hasError = false;

  int get version => qr.typeNumber;

  @override
  void paint(Canvas canvas, Size size) {
    if (_hasError) {
      return;
    }
    if (size.shortestSide == 0) {
      print(
          "[QR] WARN: width or height is zero. You should set a 'size' value or nest this painter in a Widget that defines a non-zero size");
    }

    if (qrOptions.bgColor != null) {
      canvas.drawColor(qrOptions.bgColor, BlendMode.color);
    }

    final double cellSize = size.shortestSide / qr.moduleCount.toDouble();
    bool topLeftEyeDrawn = false;
    bool topRightEyeDrawn = false;
    bool bottomLeftEyeDrawn = false;
    for (int x = 0; x < qr.moduleCount; x++) {
      for (int y = 0; y < qr.moduleCount; y++) {
        if (qr.isDark(y, x)) {
          var isTopLeftEye = x <= 7 && y <= 7;
          var isTopRightEye = x >= qr.moduleCount - 7 && y <= 7;
          var isBottomLeftEye = x <= 7 && y >= qr.moduleCount - 7;
          var isEye = isTopLeftEye || isTopRightEye || isBottomLeftEye;

          // Add an extra 1 to the top/left so the border isn't cut off by the edge of the canvas
          var cellInfo = _CellInfo(
            color: qrOptions.fgColor,
            left: x * cellSize + 1,
            top: y * cellSize + 1,
            size: cellSize,
          );

          // Round the edges of eye bits
          if (isEye) {
            if (isTopLeftEye && topLeftEyeDrawn) continue;
            if (isTopRightEye && topRightEyeDrawn) continue;
            if (isBottomLeftEye && bottomLeftEyeDrawn) continue;

            if (isTopLeftEye) topLeftEyeDrawn = true;
            if (isTopRightEye) topRightEyeDrawn = true;
            if (isBottomLeftEye) bottomLeftEyeDrawn = true;

            _makeEyeBit(canvas, cellInfo);
          } else {
            _makeDot(canvas, cellInfo);
          }
        }
      }
    }

    // make logo
    // Add 1 to accomodate for the 1 shift of the cells
    if (!qrOptions.hideLogo) {
      var dx = size.shortestSide / 2 - logoImage.width / 2;
      var dy = size.shortestSide / 2 - logoImage.height / 2;
      canvas.drawImage(logoImage, Offset(dx, dy), _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is _QrPainter) {
      return qrOptions.fgColor != oldDelegate.qrOptions.fgColor ||
          qrOptions.ecLevel != oldDelegate.qrOptions.ecLevel ||
          version != oldDelegate.version ||
          qr != oldDelegate.qr;
    }
    return false;
  }

  void _makeDot(Canvas canvas, _CellInfo info) {
    var centerX = info.left + info.size / 2;
    var centerY = info.top + info.size / 2;
    var radius = (info.size / 2) * 0.85;

    canvas.save();
    _paint.color = info.color;
    canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        0,
        2 * pi,
        true,
        _paint);
    canvas.restore();
  }

  void _makeEyeBit(Canvas canvas, _CellInfo info) {
    double right = info.left + 7 * info.size;
    double bottom = info.top + 7 * info.size;

    _paint.color = info.color;
    canvas.drawRRect(
        RRect.fromLTRBR(info.left, info.top, right, bottom, Radius.circular(5)),
        _paint);

    _paint.color = Color(0xffffffff);
    canvas.drawRRect(
        RRect.fromLTRBR(
            info.left + 1 * info.size,
            info.top + 1 * info.size,
            info.left + 6 * info.size,
            info.top + 6 * info.size,
            Radius.circular(3)),
        _paint);

    _paint.color = info.color;
    canvas.drawRRect(
        RRect.fromLTRBR(
            info.left + 1.8 * info.size,
            info.top + 1.8 * info.size,
            info.left + 5.2 * info.size,
            info.top + 5.2 * info.size,
            Radius.circular(3)),
        _paint);
  }
}

class _CellInfo {
  double top;
  double left;
  double size;
  Color color;

  _CellInfo({this.top, this.left, this.size, this.color});
}

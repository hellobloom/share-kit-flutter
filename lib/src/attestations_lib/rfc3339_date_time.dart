/// Copyright (c) 2017, Dirk-Jan Rutten
/// All rights reserved.
///
/// This source code is licensed under the MIT license found in the
/// LICENSE file in the root directory of this source tree:
/// https://github.com/excitement-engineer/graphql-iso-date

// Check whether a certain year is a leap year.
//
// Every year that is exactly divisible by four
// is a leap year, except for years that are exactly
// divisible by 100, but these centurial years are
// leap years if they are exactly divisible by 400.
// For example, the years 1700, 1800, and 1900 are not leap years,
// but the years 1600 and 2000 are.
//
bool leapYear(num year) {
  return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
}

// Function that checks whether a time-string is RFC 3339 compliant.
//
// It checks whether the time-string is structured in one of the
// following formats:
//
// - hh:mm:ssZ
// - hh:mm:ss±hh:mm
// - hh:mm:ss.*sZ
// - hh:mm:ss.*s±hh:mm
//
// Where *s is a fraction of seconds with at least 1 digit.
//
// Note, this validator assumes that all minutes have
// 59 seconds. This assumption does not follow RFC 3339
// which includes leap seconds (in which case it is possible that
// there are 60 seconds in a minute).
//
// Leap seconds are ignored because it adds complexity in
// the following areas:
// - The native Javascript Date ignores them; i.e. Date.parse('1972-12-31T23:59:60Z')
//   equals NaN.
// - Leap seconds cannot be known in advance.
//
bool validateTime(String time) {
  final RegExp TIME_REGEX = RegExp(
      '^([01][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])(\\.\\d{1,})?(([Z])|([+|-]([01][0-9]|2[0-3]):[0-5][0-9]))\$');
  return TIME_REGEX.hasMatch(time);
}

// Function that checks whether a date-string is RFC 3339 compliant.
//
// It checks whether the date-string is a valid date in the YYYY-MM-DD.
//
// Note, the number of days in each date are determined according to the
// following lookup table:
//
// Month Number  Month/Year           Maximum value of date-mday
// ------------  ----------           --------------------------
// 01            January              31
// 02            February, normal     28
// 02            February, leap year  29
// 03            March                31
// 04            April                30
// 05            May                  31
// 06            June                 30
// 07            July                 31
// 08            August               31
// 09            September            30
// 10            October              31
// 11            November             30
// 12            December             31
//
bool validateDate(String datestring) {
  final RegExp RFC_3339_REGEX =
      RegExp('^(\\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01]))\$');

  if (!RFC_3339_REGEX.hasMatch(datestring)) {
    return false;
  }

  // Verify the correct number of days for
  // the month contained in the date-string.
  final int year = int.parse(datestring.substring(0, 4));
  final int month = int.parse(datestring.substring(5, 5 + 2));
  final int day = int.parse(datestring.substring(8, 8 + 2));

  switch (month) {
    case 2: // February
      if (leapYear(year) && day > 29) {
        return false;
      } else if (!leapYear(year) && day > 28) {
        return false;
      }
      return true;
    case 4: // April
    case 6: // June
    case 9: // September
    case 11: // November
      if (day > 30) {
        return false;
      }
      break;
    default:
      break;
  }

  return true;
}

// Function that checks whether a date-time-string is RFC 3339 compliant.
//
// It checks whether the time-string is structured in one of the
//
// - YYYY-MM-DDThh:mm:ssZ
// - YYYY-MM-DDThh:mm:ss±hh:mm
// - YYYY-MM-DDThh:mm:ss.*sZ
// - YYYY-MM-DDThh:mm:ss.*s±hh:mm
//
// Where *s is a fraction of seconds with at least 1 digit.
//
bool validateDateTime(String dateTimeString) {
  final RegExp RFC_3339_REGEX = RegExp(
      '^(\\d{4}-(0[1-9]|1[012])-(0[1-9]|[12][0-9]|3[01])T([01][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9]|60))(\\.\\d{1,})?(([Z])|([+|-]([01][0-9]|2[0-3]):[0-5][0-9]))\$');

  // Validate the structure of the date-string
  if (!RFC_3339_REGEX.hasMatch(dateTimeString)) {
    return false;
  }

  // Check if it is a correct date using the javascript Date parse() method.
  DateTime time = DateTime.tryParse(dateTimeString);
  if (time == null) {
    return false;
  }
  // Split the date-time-string up into the string-date and time-string part.
  // and check whether these parts are RFC 3339 compliant.
  int index = dateTimeString.indexOf('T');
  String dateString = dateTimeString.substring(0, index);
  String timeString = dateTimeString.substring(index + 1);
  return (validateDate(dateString) && validateTime(timeString));
}

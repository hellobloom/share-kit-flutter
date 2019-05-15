![Share Kit Flutter](https://github.com/hellobloom/share-kit/raw/master/images/logo.png)

# Share Kit Flutter

Flutter implementation of [Share Kit](https://github.com/hellobloom/share-kit#readme)

- [Share Kit](#share-kit-flutter)
  - [Usage](#usage)
    - [RequestData](#requestdata)
      - [Appending to URL](#appending-to-url)
    - [Button Callback URl](#button-callback-url)
    - [Example](#example)
  - [Response](#response)
  - [Testing](#testing)

## Usage

Check [example](./example) for complete examples.

```dartlang
import 'package:share_kit/share_kit.dart';

final requestData = RequestData(...)
final buttonCallbackUrl = '...'

RequestButton(
  requestData: requestData,
  buttonCallbackUrl: buttonCallbackUrl,
)
```

### RequestData

| Name                   | Description                                                                                     | Type                                      |
| ---------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------------------- |
| action                 | Action type                                                                                     | `Action`                                  |
| token                  | Unique string to identify this data request                                                     | `string`                                  |
| url                    | The API endpoint to POST the `ResponseData` to.<br/> See [below](#appending-to-URL) for details | `string`                                  |
| org_logo_url           | A url of the logo to display to the user when requesting data                                   | `string`                                  |
| org_name               | The name of the organization requesting data                                                    | `string`                                  |
| types                  | The type of attestions required and the amount needed                                           | [`AttestationTypeID`](#AttestationTypeID) |
| org_usage_policy_url   | The url of the usage policy for the organization requesting data                                | `string`                                  |
| org_privacy_policy_url | The url of the privacy policy for the organization requesting data                              | `string`                                  |

#### AttestationTypeID

See [share-kit](https://github.com/hellobloom/share-kit#TAttestationTypeNames) for a complete list of supported attestation types.

#### Appending to URL

The user can share by tapping a button or scanning a QR code, sometimes you'll need to know the difference so the query param `share-kit-from` is appended to your url.

The param will either be `share-kit-from=qr` OR `share-kit-from=button`.

```
// Input
'https://receive-kit.bloom.co/api/receive'

// Output
'https://receive-kit.bloom.co/api/receive?share-kit-from=qr'
```

Works if your url already has a query param too!

```
// Input
'https://receive-kit.bloom.co/api/receive?my-param=',

// Output
'https://receive-kit.bloom.co/api/receive?my-param=&share-kit-from=qr',
```

### Button Callback URL

The `buttonCallbackUrl` parameter will be used to send the user back to your app after they share their data.

### Example

```dartlang
import 'package:share_kit/share_kit.dart';

final requestData = RequestData(
  action: Action.request_attestation_data,
  token: 'a08714b92346a1bba4262ed575d23de3ff3e6b5480ad0e1c82c011bab0411fdf',
  url: 'https://receive-kit.bloom.co/api/receive',
  org_logo_url: 'https://bloom.co/images/notif/bloom-logo.png',
  org_name: 'Bloom',
  org_usage_policy_url: 'https://bloom.co/legal/terms',
  org_privacy_policy_url: 'https://bloom.co/legal/privacy',
  types: [AttestationTypeID.phone, AttestationTypeID.email],
)

RequestButton(
  requestData: requestData,
  buttonCallbackUrl: 'https://mysite.com/bloom-callback',
)
```

![Sample Button](https://github.com/hellobloom/share-kit-flutter/raw/master/images/sampleButton.png)

## Response

For validating the reponse on your server see [share-kit](https://github.com/hellobloom/share-kit#response)

## Testing

Run

```bash
flutter test
```

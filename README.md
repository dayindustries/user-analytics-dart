# user-analytics-dart

By Roger Jungemann

## Setup

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  user_analytics:
    git: https://github.com/dayindustries/user-analytics-dart.git
```

## Usage

To run tests:

```sh
pub run test
```

To manually test from the command line:

```sh
export USER_ANALYTICS_ENDPOINT='https://SOME_ID.execute-api.SOME_REGION.amazonaws.com/SOME_ENDPOINT'
export USER_ANALYTICS_TOKEN='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'

dart useranalytics.dart --list
dart useranalytics.dart --describe UserAnalytics
dart useranalytics.dart --post UserAnalytics --data '{"foo":"bar"}'
```

From Dart:

```dart
import 'package:user_analytics/user_analytics.dart'

func main() async {
  String endpoint = 'https://SOME_ID.execute-api.SOME_REGION.amazonaws.com/SOME_ENDPOINT';
  String token = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
  String streamName = 'UserAnalytics';
  UserAnalytics userAnalytics = new UserAnalytics(endpoint, token);
  Map<String, dynamic> data = {
    'distinct_id': '1',
    'time': UserAnalytics.toAthenaTimestamp(DateTime.now()),
    'env': 'prod',
    'event': 'Signed Up',
    'subcategory': '',
    'event_id': '',
    'source': 'someservice',
    'client': 'ios',
    'os_version': '',
    'app_version': ''
  };

  Map<String, dynamic> listResult = await userAnalytics.list();
  print(listResult);
  Map<String, dynamic> describeResult = await userAnalytics.describe(streamName);
  print(describeResult);
  Map<String, dynamic> describeResult = await userAnalytics.post(streamName, data);
  print(describeResult);
}
```

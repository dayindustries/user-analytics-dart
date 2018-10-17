import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:user_analytics/user_analytics.dart';

void main(List<String> arguments) async {
  final Map<String, String> envVars = Platform.environment;
  final String endpoint = envVars['USER_ANALYTICS_ENDPOINT'];
  if (endpoint == null) {
    stderr.writeln('USER_ANALYTICS_ENDPOINT must be provided.');
    exit(1);
  }

  final String token = envVars['USER_ANALYTICS_TOKEN'];
  if (token == null) {
    stderr.writeln('USER_ANALYTICS_TOKEN must be provided.');
    exit(1);
  }

  final parser = new ArgParser()
      ..addFlag('list', abbr: 'l', negatable: false, help: 'Lists the endpoints')
      ..addOption('describe', abbr: 'i', help: 'Describes an endpoint')
      ..addOption('post', abbr: 'p', help: 'Posts to an endpoint')
      ..addOption('data', abbr: 'd', help: 'Data to post');
  final ArgResults argResults = parser.parse(arguments);
  final bool isList = argResults['list'];
  final String endpointToDescribe = argResults['describe'];
  final String endpointToPost = argResults['post'];
  final String data = argResults['data'];
  UserAnalytics userAnalytics = new UserAnalytics(endpoint, token);
  JsonEncoder encoder = JsonEncoder.withIndent('  ');

  if (isList) {
    stderr.writeln('Listing user analytics endpoints...');
    final Map<String, dynamic> result = await userAnalytics.list();
    stdout.writeln(encoder.convert(result));
    exit(0);
  }

  if (endpointToDescribe != null) {
    stderr.writeln('Describing user analytics endpoint "${endpointToDescribe}"...');
    final Map<String, dynamic> result = await userAnalytics.describe(endpointToDescribe);
    stdout.writeln(encoder.convert(result));
    exit(0);
  }

  if (endpointToPost != null) {
    if (data == null) {
      stderr.writeln('Data must be provided.');
      exit(1);
    }

    final Map<String, dynamic> jsonData = json.decode(data);
    stderr.writeln('Posting to user analytics endpoint...');
    final Map<String, dynamic> result = await userAnalytics.post(endpointToPost, jsonData);
    stdout.writeln(encoder.convert(result));
    exit(0);
  }

  stderr.writeln(parser.usage);
  exit(1);
}

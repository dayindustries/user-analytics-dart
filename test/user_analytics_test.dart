import 'dart:io';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:collection/collection.dart';
import 'package:user_analytics/user_analytics.dart';

void validateMethod(Request req, String method) {
  if (req.method != method) {
    throw new Exception('Invalid method!');
  }
}

void validateToken(Request req, String token) {
  if (req.headers['x-api-key'] != token) {
    throw new Exception('Invalid token!');
  }
}

void validateJsonContentType(Request req) {
  if (
      req.headers['Content-Type'] != 'application/json' &&
      req.headers['Content-Type'] != 'application/json; charset=utf-8'
  ) {
    throw new Exception('Invalid content type!');
  }
}

void validateUrlStartsWith(Request req, String s) {
  if (!req.url.toString().startsWith(s)) {
    throw new Exception('Invalid host!');
  }
}

void validatePath(Request req, String path) {
  if (req.url.path != path) {
    throw new Exception('Invalid path!');
  }
}

void validateBody(Request req, dynamic body) {
  Function deepEq = const DeepCollectionEquality().equals;
  if (!deepEq(json.decode(req.body), body)) {
    throw new Exception('Invalid body!');
  }
}

void main() {
  test('can convert a date to an Athena timestamp', () {
    var time = DateTime.parse('2012-02-27T13:27:12.123Z').toLocal();
    expect(UserAnalytics.toAthenaTimestamp(time), equals('2012-02-27 05:27:12.123'));
  });

  test('can list endpoints', () async {
    String token = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
    File fixtureFile = new File('test/fixtures/list.json');
    String responseData = await fixtureFile.readAsString();
    var client = new MockClient((Request req) async {
      validateMethod(req, 'GET');
      validateToken(req, token);
      validateJsonContentType(req);
      validateUrlStartsWith(req, 'https://example.host/');
      validatePath(req, '/test/streams');
      return new Response(responseData, 200);
    });

    UserAnalytics userAnalytics = new UserAnalytics('https://example.host/test', token);
    userAnalytics.client = client;
    Map<String, dynamic> result = await userAnalytics.list();
    expect(result['HasMoreStreams'], equals(false));
    List<dynamic> streamNames = result['StreamNames'];
    expect(streamNames.length, equals(1));
    expect(streamNames[0], equals('UserAnalytics'));
  });

  test('can describe endpoints', () async {
    String token = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
    File fixtureFile = new File('test/fixtures/describe.json');
    String responseData = await fixtureFile.readAsString();
    var client = new MockClient((Request req) async {
      validateMethod(req, 'GET');
      validateToken(req, token);
      validateJsonContentType(req);
      validateUrlStartsWith(req, 'https://example.host/');
      validatePath(req, '/test/streams/UserAnalytics');
      return new Response(responseData, 200);
    });

    UserAnalytics userAnalytics = new UserAnalytics('https://example.host/test', token);
    userAnalytics.client = client;
    Map<String, dynamic> result = await userAnalytics.describe('UserAnalytics');
    Map<String, dynamic> description = result['StreamDescription'];
    expect(description['StreamName'], equals('UserAnalytics'));
  });

  test('can describe endpoints', () async {
    String token = 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
    File fixtureFile = new File('test/fixtures/post.json');
    Map<String, dynamic> body = {
      'foo': 'bar'
    };

    String responseData = await fixtureFile.readAsString();
    var client = new MockClient((Request req) async {
      validateMethod(req, 'POST');
      validateToken(req, token);
      validateJsonContentType(req);
      validateUrlStartsWith(req, 'https://example.host/');
      validatePath(req, '/test/streams/UserAnalytics');
      validateBody(req, body);
      return new Response(responseData, 200);
    });

    UserAnalytics userAnalytics = new UserAnalytics('https://example.host/test', token);
    userAnalytics.client = client;
    Map<String, dynamic> result = await userAnalytics.post('UserAnalytics', body);
    expect(result['SequenceNumber'] is String, equals(true));
    expect(result['ShardId'] is String, equals(true));
  });
}

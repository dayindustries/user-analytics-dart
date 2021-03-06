import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class UserAnalytics {
  String listEndpoint = '/streams';
  String describeEndpoint = '/streams';
  String postEndpoint = '/streams';
  String endpoint;
  String token;
  http.BaseClient client;

  static String toAthenaTimestamp(DateTime date) {
    var utcDate = date.toUtc();
    var ms = utcDate.millisecond.toString().padLeft(3,'0');
    var formatter = new DateFormat('yyyy-MM-dd HH:mm:ss.$ms');
    return formatter.format(date);
  }

  UserAnalytics(String endpoint, String token) {
    this.endpoint = endpoint;
    this.token = token;
    this.client = new http.Client();
  }

  Future<Map<String, dynamic>> list() async {
    final http.Response response = await this.client.get(
      '${this.endpoint}${this.listEndpoint}',
      headers: this._headers,
    );

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> describe(String streamName) async {
    final http.Response response = await this.client.get(
      '${this.endpoint}${this.describeEndpoint}/${streamName}',
      headers: this._headers,
    );

    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> post(String streamName, Map<String, dynamic> data) async {
    final http.Response response = await this.client.post(
      '${this.endpoint}${this.postEndpoint}/${streamName}',
      headers: this._headers,
      body: json.encode(data),
    );

    return json.decode(response.body);
  }

  Map<String, String> get _headers {
    return {
      'x-api-key': this.token,
      'Content-Type': 'application/json'
    };
  }
}

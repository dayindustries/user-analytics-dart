import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class UserAnalytics {
  const String listEndpoint = '/streams';
  const String describeEndpoint = '/streams';
  const String postEndpoint = '/streams';

  String endpoint;
  String token;
  http.BaseClient client;

  UserAnalytics(String endpoint, String token) {
    this.endpoint = endpoint;
    this.token = token;
    this.client = new http.Client();
  }

  Map<String, dynamic> list() async {
    final http.Response response = await this.client.get(
      '${this.endpoint}${this.listEndpoint}',
      headers: this._headers,
    );

    return json.decode(response.body);
  }

  Map<String, dynamic> describe(String streamName) async {
    final http.Response response = await this.client.get(
      '${this.endpoint}${this.describeEndpoint}/${streamName}',
      headers: this._headers,
    );

    return json.decode(response.body);
  }

  Map<String, dynamic> post(String streamName, Map<String, dynamic> data) async {
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

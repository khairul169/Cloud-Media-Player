import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cmp/models/ApiResult.dart';

const API_URL = 'https://192.168.43.48/';

enum RequestMethod { Get, Post }

class ApiHelper {
  static Future<ApiResult> get(String url) {
    return request(RequestMethod.Get, API_URL + url);
  }

  static Future<ApiResult> post(String url, dynamic data) {
    return request(RequestMethod.Post, API_URL + url, body: data);
  }

  static Future<ApiResult> request(
    RequestMethod method,
    String url, {
    dynamic body,
  }) async {
    var result = ApiResult(isError: true);

    try {
      // Response handler
      http.Response response;

      if (method == RequestMethod.Post) {
        response = await http.post(url, body: jsonEncode(body));
      } else {
        response = await http.get(url);
      }

      // Parse result
      result = ApiResult.parse(response.body);

      if (result.isError) {
        throw new Exception('API Error! ' + result.message);
      }
    } catch (ex) {
      print(ex);
    }
    return result;
  }
}

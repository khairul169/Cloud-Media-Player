import 'dart:convert';
import 'dart:io';
import 'package:cmp/models/api_result.dart';
import 'package:cmp/public/config.dart';
import 'package:cmp/services/file_uploader.dart';
import 'package:http/http.dart' as http;
import 'package:universal_html/html.dart' as html;

enum RequestMethod { Get, Post }

class APIHelper {
  static Future<APIResult> get(String url) {
    return request(RequestMethod.Get, Config.API_URL + url);
  }

  static Future<APIResult> post(String url, dynamic data) {
    return request(RequestMethod.Post, Config.API_URL + url, body: data);
  }

  static Future<APIResult> request(
    RequestMethod method,
    String url, {
    dynamic body,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      // Response handler
      http.Response response;

      if (method == RequestMethod.Post) {
        response = await http.post(
          url,
          body: body != null ? jsonEncode(body) : null,
          headers: headers,
        );
      } else {
        response = await http.get(url, headers: headers);
      }

      // Parse result
      var result = APIResult.parse(jsonDecode(response.body));
      return result;
    } catch (ex) {
      return APIResult(
        isError: true,
        message: 'Error unexpected',
      );
    }
  }

  static Future<http.Response> uploadFile(
    String url,
    dynamic file, {
    Map<String, String> body,
    Function(int, int) onProgress,
  }) async {
    if (file == null) return null;

    final uri = Uri.parse(Config.API_URL + url);
    final request = new FileUploader(uri, onProgress: onProgress);

    if (body != null) {
      request.fields.addAll(body);
    }

    if (file is File) {
      await request.addFile('media', file);
    }
    if (file is html.File) {
      await request.addFileHtml('media', file);
    }

    // Send response
    final response = await request.send();
    final data = await http.Response.fromStream(response);
    return data;
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:zap_architecture/zap_architecture.dart';
import 'package:dio/dio.dart';
import 'package:zap_architecture_flutter/src/globals.dart';
import 'package:zap_architecture_flutter/zap_architecture_flutter.dart';

/// Created by Musa Usman on 16.01.2021
/// Copyright © 2021 Musa Usman. All rights reserved.
///
/// Email: hello@musausman.com
/// Website: musausman.com
/// WhatsApp: +92 324 9066001

enum RequestType { get, post, update, delete }

class HTTPMixin {
  final String serverURL;

  HTTPMixin(this.serverURL);

  Dio _dio;

  Future<Res<T>> request<T>(String url,
      {Map<String, dynamic> headers,
      Map body,
      RequestType requestType = RequestType.get}) async {
    assert(
      requestType == RequestType.post ||
          requestType == RequestType.update ||
          body == null,
      "GET request can not have a body.",
    );

    try {
      if (_dio == null)
        _dio = Dio(
          BaseOptions(
            baseUrl: serverURL,
          ),
        );

      Response dioResponse;

      if (headers == null) headers = Map<String, String>();

      if (packageInfo == null) throw PackageInfoNullException();

      if (headers.containsKey("version") == false) {
        headers['version'] = packageInfo.version;
      }

      if (headers.containsKey("appName") == false) {
        headers['appName'] = packageInfo.appName;
      }

      if (headers.containsKey("buildNum") == false) {
        headers['buildNum'] = packageInfo.buildNumber;
      }

      if (requestType == RequestType.get) {
        dioResponse = await _dio.get(
          url,
          options: Options(headers: headers),
        );
      } else if (requestType == RequestType.post) {
        if (headers.containsKey("Content-Type") == false)
          headers["Content-Type"] = "application/json";

        String _body = json.encode(body);

        dioResponse = await _dio.post(
          url,
          data: _body,
          options: Options(headers: headers),
        );
      } else if (requestType == RequestType.update) {
        if (headers.containsKey("Content-Type") == false)
          headers["Content-Type"] = "application/json";

        String _body = json.encode(body);

        dioResponse = await _dio.put(
          url,
          data: _body,
          options: Options(headers: headers),
        );
      } else {
        dioResponse = await _dio.delete(
          url,
          options: Options(headers: headers),
        );
      }

      if (dioResponse.data is String &&
          dioResponse.data.contains("<!DOCTYPE html>")) {
        throw NonJSONContentException(url, dioResponse.data);
      } else {
        dynamic data = dioResponse.data;

        if (data['friendly_error_message'] != null &&
            data['friendly_error_message'] == "null")
          data['friendly_error_message'] = null;

        Res<T> response = Res<T>.fromJSON(data);

        if (response.success == false) throw APIError(response, data);

        return response;
      }
    } on PackageInfoNullException catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");
      return Res.error(errorMessage: "Incomplete data. Contact developer.");
    } on APIError catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");
      return e.response;
    } on TimeoutException catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");
      return Res.error(errorMessage: "Connection To Server Timeout");
    } on FormatException catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");
      return Res.error(errorMessage: "Connection To Server Timeout");
    } on NonJSONContentException catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");

      return Res.error(errorMessage: "Error fetching data.");
    } on SocketException catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");
      return Res.error(
        errorMessage: "Please check your internet connection and try again.",
      );
    } on DioError catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");

      String friendlyErrorMessage = e.error is SocketException &&
              (e.error as SocketException).osError.errorCode == 111
          ? "Could not connect to server."
          : e.type == DioErrorType.RECEIVE_TIMEOUT
              ? "Connection to server timed out."
              : e.message.contains('SocketException')
                  ? "Could not connect to server."
                  : "Something Went Wrong.";

      return Res.error(
        errorMessage: e.toString(),
        friendlyErrorMessage: friendlyErrorMessage,
      );
    } on PlatformException catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");

      if (e.code == "ERROR_NETWORK_REQUEST_FAILED") {
        return Res.error(
            errorMessage: e.toString(),
            friendlyErrorMessage:
                "Please check your internet connection and try again.");
      } else {
        return Res.error(errorMessage: e.toString());
      }
    } catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");
      return Res.error(errorMessage: e.toString());
    }
  }

  /// Logs all the error information with as much detail as possible.
  /// This has hude impact when the developer is debugging some network related
  /// problem.
  void _logError(
      dynamic e, StackTrace s, RequestType requestType, String requestURL) {
    print("ZAP: HTTPMixin: Request: $e");
    print(" - URL: $requestURL");
    print(" - REQUEST TYPE: $requestType");

    if (e is DioError) {
      print(" - RESPONSE: ${e.response?.data}");
      print(" - HEADERS: ${e.request?.headers}");
      print(" - BODY: ${e.request.data}");
    } else if (e is APIError) {
      print(" - DATA: ${e.data}");
    } else if (e is PackageInfoNullException) {
      print(
          " - REASON: You have not called `ZAP.init()`.\nStep 1: Import zap_architecture_flutter in your main.dart file as ZAP.\nExample: import 'package:zap_architecture_flutter/zap_architecture_flutter.dart' as ZAP;\n\n Step 2: Call `ZAP.init()` inside your main() function.");
    }

    print(" - STACK:\n$s");
  }
}

class APIError {
  final Res response;
  final dynamic data;

  APIError(this.response, this.data);
}

class NonJSONContentException implements Exception {
  final String url;
  final String content;

  NonJSONContentException(this.url, this.content);
}

class PackageInfoNullException {}

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:zap_architecture/zap_architecture.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:zap_architecture_flutter/src/globals.dart';

/// Created by Musa Usman on 07.11.2020
/// Copyright © 2020 Musa Usman. All rights reserved.
///
/// Email: hello@musausman.com
/// Website: musausman.com
/// WhatsApp: +92 324 9066001
///
enum RequestType { get, post, update }

class HTTPMixin {
  final String serverURL;

  HTTPMixin(this.serverURL);

  Dio.Dio _dio;

  Future<Response<T>> request<T>(String url,
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
        _dio = Dio.Dio(
          Dio.BaseOptions(
            baseUrl: serverURL,
          ),
        );

      Dio.Response dioResponse;

      if (headers == null) headers = Map<String, String>();

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
          options: Dio.Options(headers: headers),
        );
      } else if (requestType == RequestType.post) {
        if (headers.containsKey("Content-Type") == false)
          headers["Content-Type"] = "application/json";

        String _body = json.encode(body);

        dioResponse = await _dio.post(
          url,
          data: _body,
          options: Dio.Options(headers: headers),
        );
      } else if (requestType == RequestType.update) {
        if (headers.containsKey("Content-Type") == false)
          headers["Content-Type"] = "application/json";

        String _body = json.encode(body);

        dioResponse = await _dio.put(
          url,
          data: _body,
          options: Dio.Options(headers: headers),
        );
      } else {
        dioResponse = await _dio.delete(
          url,
          options: Dio.Options(headers: headers),
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

        Response<T> response = Response<T>.fromJSON(data);

        if (response.success == false) throw APIError(response, data);

        return response;
      }
    } on APIError catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");
      return e.response;
    } on TimeoutException catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");
      return Response.error(errorMessage: "Connection To Server Timeout");
    } on FormatException catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");
      return Response.error(errorMessage: "Connection To Server Timeout");
    } on NonJSONContentException catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");

      return Response.error(errorMessage: "Error fetching data.");
    } on SocketException catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");
      return Response.error(
        errorMessage: "Please check your internet connection and try again.",
      );
    } on Dio.DioError catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");

      String friendlyErrorMessage = e.error is SocketException &&
              (e.error as SocketException).osError.errorCode == 111
          ? "Could not connect to server."
          : e.type == Dio.DioErrorType.RECEIVE_TIMEOUT
              ? "Connection to server timed out."
              : e.message.contains('SocketException')
                  ? "Could not connect to server."
                  : "Something Went Wrong.";

      return Response.error(
        errorMessage: e.toString(),
        friendlyErrorMessage: friendlyErrorMessage,
      );
    } on PlatformException catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");

      if (e.code == "ERROR_NETWORK_REQUEST_FAILED") {
        return Response.error(
            errorMessage: e.toString(),
            friendlyErrorMessage:
                "Please check your internet connection and try again.");
      } else {
        return Response.error(errorMessage: e.toString());
      }
    } catch (e, s) {
      _logError(e, s, requestType, "$serverURL$url");
      return Response.error(errorMessage: e.toString());
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

    if (e is Dio.DioError) {
      print(" - RESPONSE: ${e.response?.data}");
      print(" - HEADERS: ${e.request?.headers}");
      print(" - BODY: ${e.request.data}");
    }

    print(" - STACK:\n$s");
  }
}

class APIError {
  final Response response;
  final String data;

  APIError(this.response, this.data);
}

class NonJSONContentException implements Exception {
  final String url;
  final String content;

  NonJSONContentException(this.url, this.content);
}

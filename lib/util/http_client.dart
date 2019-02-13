import 'dart:io';

import 'package:pts_lib/util/token_store.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

final _isDebug = !bool.fromEnvironment('dart.vm.product');

class HttpClient {
  final http.Client _innerClient = http.Client();
  final String _baseUrl;
  final TokenStore _tokenStore;

  HttpClient(this._baseUrl, this._tokenStore);

  Observable<http.Response> get(String path,
      {Map<String, String> queryParameters}) {
    final baseUri = Uri.parse(_baseUrl);
    final uri = Uri(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.port,
        path: baseUri.path + path,
        queryParameters: queryParameters);

    return _tokenStore.getToken().flatMap((token) {
      final headers = Map<String, String>();
      if (token != null) {
        headers[HttpHeaders.authorizationHeader] = token;
      }
      return Observable.fromFuture(_innerClient.get(uri, headers: headers));
    }).map((resp) => _handleResponse(resp));
  }

  Observable<http.Response> _sendFile(String method, String path, File file,
      {Map<String, String> queryParameters}) {
    final baseUri = Uri.parse(_baseUrl);
    final uri = Uri(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.port,
        path: baseUri.path + path,
        queryParameters: queryParameters);

    final request = http.StreamedRequest(method, uri);
    file.openRead().listen(request.sink.add).onDone(() => request.sink.close());

    return _tokenStore.getToken().flatMap((token) {
      if (token != null) {
        request.headers[HttpHeaders.authorizationHeader] = token;
      }
      request.headers[HttpHeaders.contentTypeHeader] =
          'application/octet-stream';
      return Observable.fromFuture(_innerClient
          .send(request)
          .then((resp) => http.Response.fromStream(resp)));
    }).map((resp) => _handleResponse(resp));
  }

  Observable<http.Response> putFile(String path, File file,
      {Map<String, String> queryParameters}) {
    return _sendFile('PUT', path, file, queryParameters: queryParameters);
  }

  Observable<http.Response> put(String path, String body,
      {String contentType}) {
    final baseUri = Uri.parse(_baseUrl);
    final uri = Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.port,
      path: baseUri.path + path,
    );

    return _tokenStore.getToken().flatMap((token) {
      final headers = {
        HttpHeaders.contentTypeHeader: contentType ?? 'application/json'
      };
      if (token != null) {
        headers[HttpHeaders.authorizationHeader] = token;
      }

      return Observable.fromFuture(
          _innerClient.put(uri, headers: headers, body: body));
    }).map((resp) => _handleResponse(resp, requestBody: body));
  }

  Observable<http.Response> patch(String path, String body,
      {String contentType}) {
    final baseUri = Uri.parse(_baseUrl);
    final uri = Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.port,
      path: baseUri.path + path,
    );

    return _tokenStore.getToken().flatMap((token) {
      final headers = {
        HttpHeaders.contentTypeHeader: contentType ?? 'application/json'
      };
      if (token != null) {
        headers[HttpHeaders.authorizationHeader] = token;
      }

      return Observable.fromFuture(
          _innerClient.patch(uri, headers: headers, body: body));
    }).map((resp) => _handleResponse(resp, requestBody: body));
  }

  Observable<http.Response> post(String path, String body,
      {String contentType}) {
    final baseUri = Uri.parse(_baseUrl);
    final uri = Uri(
      scheme: baseUri.scheme,
      host: baseUri.host,
      port: baseUri.port,
      path: baseUri.path + path,
    );

    return _tokenStore.getToken().flatMap((token) {
      final headers = {
        HttpHeaders.contentTypeHeader: contentType ?? 'application/json'
      };
      if (token != null) {
        headers[HttpHeaders.authorizationHeader] = token;
      }

      return Observable.fromFuture(
          _innerClient.post(uri, headers: headers, body: body));
    }).map((resp) => _handleResponse(resp, requestBody: body));
  }
}

http.Response _handleResponse(http.Response resp, {String requestBody}) {
  if (_isDebug) {
    debugPrint(_buildLog(resp, requestBody: requestBody));
  }
  if (resp.statusCode != 200) {
    throw HttpException(resp, requestBody: requestBody);
  }

  return resp;
}

String _buildLog(http.Response resp, {String requestBody}) {
  String builder = '${resp.request.method} => ${resp.request.url}\n'
      '${resp.request.headers.map((key, value) => MapEntry(key, "$key: $value")).values.toList().map((h) => '$h\n').join()}';
  if (requestBody != null) {
    builder += '$requestBody\n';
  }
  builder += '${resp.statusCode} => ${resp.body}';

  return builder;
}

class HttpException {
  final http.Response response;
  final String requestBody;

  HttpException(this.response, {this.requestBody});

  @override
  String toString() {
    return '[HttpException]\n' + _buildLog(response, requestBody: requestBody);
  }
}

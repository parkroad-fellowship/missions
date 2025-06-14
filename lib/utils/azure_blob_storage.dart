// Modified from: https://github.com/kkazuo/dart-azblob/blob/main/lib/src/azblob_base.dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;

/// Blob type
enum BlobType {
  blockBlob('BlockBlob'),
  appendBlob('AppendBlob');

  const BlobType(this.displayName);

  final String displayName;
}

/// Azure Storage Exception
class AzureStorageException implements Exception {
  AzureStorageException(this.message, this.statusCode, this.headers);
  final String message;
  final int statusCode;
  final Map<String, String> headers;
}

/// Azure Storage Client
class AzureStorage {
  /// Initialize with connection string.
  AzureStorage.parse(String connectionString) {
    try {
      final m = <String, String>{};
      final items = connectionString.split(';');
      for (final item in items) {
        final i = item.indexOf('=');
        final key = item.substring(0, i);
        final val = item.substring(i + 1);
        m[key] = val;
      }
      config = m;
      encodedAccountKey = base64Decode(config[accountKey]!);
    } catch (e) {
      throw Exception('Parse error.');
    }
  }
  late Map<String, String> config;
  late Uint8List encodedAccountKey;

  static const String defaultEndpointsProtocol = 'DefaultEndpointsProtocol';
  static const String endpointSuffix = 'EndpointSuffix';
  static const String accountName = 'AccountName';

  static const String accountKey = 'AccountKey';

  @override
  String toString() {
    return config.toString();
  }

  Uri uri({String path = '/', Map<String, String>? queryParameters}) {
    final blobEndpoint = config['BlobEndpoint'];
    if (blobEndpoint != null) {
      // Parse from explicit endpoint (like Azurite's BlobEndpoint)
      final base = Uri.parse(blobEndpoint);
      return base.replace(
        path: '${base.path}$path',
        queryParameters: queryParameters,
      );
    }

    final scheme = config[defaultEndpointsProtocol] ?? 'https';
    final suffix = config[endpointSuffix] ?? 'core.windows.net';
    final name = config[accountName];
    return Uri(
      scheme: scheme,
      host: '$name.blob.$suffix',
      path: path,
      queryParameters: queryParameters,
    );
  }

  String _canonicalHeaders(Map<String, String> headers) {
    final keys =
        headers.keys
            .where((i) => i.startsWith('x-ms-'))
            .map((i) => '$i:${headers[i]}\n')
            .toList()
          ..sort();
    return keys.join();
  }

  String _canonicalResources(Map<String, String> items) {
    if (items.isEmpty) {
      return '';
    }
    final keys = items.keys.toList()..sort();
    return keys.map((i) => '\n$i:${items[i]}').join();
  }

  void sign(http.Request request) {
    request.headers['x-ms-date'] = http_parser.formatHttpDate(DateTime.now());
    request.headers['x-ms-version'] = '2019-12-12';
    final ce = request.headers['Content-Encoding'] ?? '';
    final cl = request.headers['Content-Language'] ?? '';
    final cz = request.contentLength == 0 ? '' : '${request.contentLength}';
    final cm = request.headers['Content-MD5'] ?? '';
    final ct = request.headers['Content-Type'] ?? '';
    final dt = request.headers['Date'] ?? '';
    final ims = request.headers['If-Modified-Since'] ?? '';
    final imt = request.headers['If-Match'] ?? '';
    final inm = request.headers['If-None-Match'] ?? '';
    final ius = request.headers['If-Unmodified-Since'] ?? '';
    final ran = request.headers['Range'] ?? '';
    final chs = _canonicalHeaders(request.headers);
    final crs = _canonicalResources(request.url.queryParameters);
    final name = config[accountName];
    final path = request.url.path;
    final sig =
        '${request.method}\n$ce\n$cl\n$cz\n$cm\n$ct\n$dt\n$ims\n$imt\n$inm\n$ius\n$ran\n$chs/$name$path$crs';
    final mac = crypto.Hmac(crypto.sha256, encodedAccountKey);
    final digest = base64Encode(mac.convert(utf8.encode(sig)).bytes);
    final auth = 'SharedKey $name:$digest';
    request.headers['Authorization'] = auth;
  }

  String _signedExpiry(DateTime? expiry) {
    final str =
        (expiry ?? DateTime.now().add(const Duration(hours: 1)))
            .toUtc()
            .toIso8601String();
    return '${str.substring(0, str.indexOf('.'))}Z';
  }

  /// Get Blob Link.
  Future<Uri> getBlobLink(String path, {DateTime? expiry}) async {
    const signedPermissions = 'r';
    const signedStart = '';
    final signedExpiry = _signedExpiry(expiry);
    const signedIdentifier = '';
    const signedVersion = '2012-02-12';
    final name = config[accountName];
    final canonicalizedResource = '/$name$path';
    final str =
        '$signedPermissions\n'
        '$signedStart\n'
        '$signedExpiry\n'
        '$canonicalizedResource\n'
        '$signedIdentifier\n'
        '$signedVersion';
    final mac = crypto.Hmac(crypto.sha256, encodedAccountKey);
    final sig = base64Encode(mac.convert(utf8.encode(str)).bytes);
    return uri(
      path: path,
      queryParameters: {
        'sr': 'b',
        'sp': signedPermissions,
        'se': signedExpiry,
        'sv': signedVersion,
        'spr': 'https',
        'sig': sig,
      },
    );
  }

  /// Put Blob.
  ///
  /// `body` and `bodyBytes` are exclusive and mandatory.
  Future<void> putBlob(
    String path, {
    String? body,
    Uint8List? bodyBytes,
    String? contentType,
    BlobType type = BlobType.blockBlob,
    Map<String, String>? headers,
  }) async {
    final request = http.Request('PUT', uri(path: path));
    request.headers['x-ms-blob-type'] = type.displayName;
    if (headers != null) {
      headers.forEach((key, value) {
        request.headers['x-ms-meta-$key'] = value;
      });
    }
    if (contentType != null) request.headers['content-type'] = contentType;
    if (type == BlobType.blockBlob) {
      if (bodyBytes != null) {
        request.bodyBytes = bodyBytes;
      } else if (body != null) {
        request.body = body;
      }
    } else {
      request.body = '';
    }
    sign(request);
    final res = await request.send();
    if (res.statusCode == 201) {
      await res.stream.drain<dynamic>();
      if (type == BlobType.appendBlob && (body != null || bodyBytes != null)) {
        await _appendBlock(path, body: body, bodyBytes: bodyBytes);
      }
      return;
    }

    final message = await res.stream.bytesToString();
    throw AzureStorageException(message, res.statusCode, res.headers);
  }

  /// Append block to blob.
  Future<void> _appendBlock(
    String path, {
    String? body,
    Uint8List? bodyBytes,
  }) async {
    final request = http.Request(
      'PUT',
      uri(path: path, queryParameters: {'comp': 'appendblock'}),
    );
    if (bodyBytes != null) {
      request.bodyBytes = bodyBytes;
    } else if (body != null) {
      request.body = body;
    }
    sign(request);
    final res = await request.send();
    if (res.statusCode == 201) {
      await res.stream.drain<dynamic>();
      return;
    }

    final message = await res.stream.bytesToString();
    throw AzureStorageException(message, res.statusCode, res.headers);
  }
}

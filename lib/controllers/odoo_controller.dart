import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../common/config.dart';
import '../common/utils.dart';
import '../common/sessions.dart';
import '../models/ir_attachment_model.dart';

class OdooHelper {
  static Future<Uri> buildUrl(
      {String? domain, required String endPoint}) async {
    if (domain == null) {
      String protocol = await Sessions.getProtocol() ?? '';
      String host = await Sessions.getHost() ?? '';

      return Uri.parse('$protocol://$host/$endPoint');
    }

    return Uri.parse('$domain/$endPoint');
  }

  static String payLoad(Map params) {
    return convert.jsonEncode({
      'id': const Uuid().v1(),
      'jsonrpc': '2.0',
      'method': 'call',
      'params': params,
    });
  }

  static bool isOk(Response res) {
    final body = convert.jsonDecode(res.body);
    try {
      if (body['error'] != null) {
        return false;
      }

      if (body['result'] is Map && !(body['result']['status'] ?? true)) {
        return false;
      }

      if (body['result'] is Map && body['result']['message'] != null) {
        return false;
      }
    } catch (_) {}

    return true;
  }

  static String? errorMessage(Response res) {
    if (!isOk(res)) {
      final body = convert.jsonDecode(res.body);
      try {
        if (body['result'] != null && body['result']['message'] != null) {
          return body['result']['message'];
        }
        if (body['error']['data'] != null &&
            body['error']['data']['message'] != null) {
          return body['error']['data']['message'];
        }
        if (body['error']['message'] != null) {
          return body['error']['message'];
        }
      } catch (_) {}

      return 'Unknow error';
    }

    return null;
  }

  static int? statusCode(Response res) {
    return res.statusCode;
  }

  static dynamic result(Response res) {
    return convert.jsonDecode(res.body)['result'];
    // if (result is Map && result['records'] != null) {
    //   return result['records'];
    // }
    // return result;
  }
}

class OdooController {
  Client clientRequest = Client();

  Future<List<String>> getDatabases(String protocol, String host) async {
    try {
      final startTime = DateTime.now();
      final domain = '$protocol://$host';
      final res = await clientRequest.post(
          await OdooHelper.buildUrl(
              domain: domain, endPoint: 'web/database/list'),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Cookie': await Sessions.getSession() ?? ''
          },
          body: OdooHelper.payLoad({
            'context': {'lang': AppConfig.defaultLang, 'tz': 'Asia/Ho_Chi_Minh'}
          }));

      if (OdooHelper.isOk(res)) {
        printLog('🔼 POST: web/database/list', startTime);
        return List<String>.from(OdooHelper.result(res));
      } else {
        throw Exception(OdooHelper.errorMessage(res));
      }
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> authenticate(
      String username, String password, String database) async {
    try {
      final startTime = DateTime.now();
      final res = await clientRequest.post(
          await OdooHelper.buildUrl(endPoint: 'web/session/authenticate'),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Cookie': await Sessions.getSession() ?? ''
          },
          body: OdooHelper.payLoad({
            'db': database,
            'login': username,
            'password': password,
            'context': {'lang': AppConfig.defaultLang, 'tz': 'Asia/Ho_Chi_Minh'}
          }));

      if (OdooHelper.isOk(res)) {
        await Sessions.setSession(res.headers['set-cookie']!);
        printLog('🔼 POST: web/session/authenticate', startTime);
        return OdooHelper.result(res);
      } else {
        throw Exception(OdooHelper.errorMessage(res));
      }
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<bool> register(Map data) async {
    try {
      final startTime = DateTime.now();
      final res = await clientRequest.post(
          await OdooHelper.buildUrl(endPoint: 'mobile/res_user/create'),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Cookie': await Sessions.getSession() ?? ''
          },
          body: OdooHelper.payLoad(data));

      if (OdooHelper.isOk(res)) {
        printLog('🔼 POST: mobile/res_user/create', startTime);
        return true;
      } else {
        throw Exception(OdooHelper.errorMessage(res));
      }
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<bool> deleteAccount() async {
    try {
      final startTime = DateTime.now();
      final res = await clientRequest.post(
          await OdooHelper.buildUrl(endPoint: 'mobile/user/delete'),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Cookie': await Sessions.getSession() ?? ''
          },
          body: OdooHelper.payLoad(
              {'context': (await Sessions.getUserContext())?.toJson()}));

      if (OdooHelper.isOk(res)) {
        printLog('🔼 POST: mobile/user/delete', startTime);
        return true;
      } else {
        throw Exception(OdooHelper.errorMessage(res));
      }
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<bool> changePassword(Map data) async {
    try {
      final startTime = DateTime.now();
      final res = await clientRequest.post(
          await OdooHelper.buildUrl(endPoint: 'mobile/update_password'),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Cookie': await Sessions.getSession() ?? ''
          },
          body: OdooHelper.payLoad({
            'context': (await Sessions.getUserContext())?.toJson()
          }..addAll(data)));

      if (OdooHelper.isOk(res)) {
        printLog('🔼 POST: mobile/update_password', startTime);
        return true;
      } else {
        throw Exception(OdooHelper.errorMessage(res));
      }
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future logout() async {
    try {
      final startTime = DateTime.now();
      await clientRequest.get(
          await OdooHelper.buildUrl(endPoint: 'web/session/logout'),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Cookie': await Sessions.getSession() ?? ''
          });
      printLog('🔼 GET: web/session/logout', startTime);
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> searchRead(
      String model, List domain, List<String> fields,
      {Map? context, int offset = 0, int limit = 0, String order = ''}) async {
    try {
      final startTime = DateTime.now();
      final res = await clientRequest.post(
          await OdooHelper.buildUrl(endPoint: 'web/dataset/search_read'),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Cookie': await Sessions.getSession() ?? ''
          },
          body: OdooHelper.payLoad({
            'context': (await Sessions.getUserContext())?.toJson(),
            'domain': domain,
            'fields': fields,
            'limit': limit,
            'model': model,
            'offset': offset,
            'sort': order
          }));

      if (OdooHelper.isOk(res)) {
        printLog('🔼 POST: search_read -> $model', startTime);
        return OdooHelper.result(res);
      } else {
        throw Exception(OdooHelper.errorMessage(res));
      }
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> read(
      String model, List<int> ids, List<String> fields,
      {dynamic kwargs, Map? context}) async {
    try {
      final startTime = DateTime.now();
      final res = await callKW(model, 'read', [ids, fields],
          kwargs: kwargs, context: context);
      if (OdooHelper.isOk(res)) {
        printLog('🔼 POST: read -> $model', startTime);
        return List<Map<String, dynamic>>.from(OdooHelper.result(res));
      } else {
        throw Exception(OdooHelper.errorMessage(res));
      }
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<int> create(String model, Map values) async {
    try {
      final startTime = DateTime.now();
      final res = await callKW(model, 'create', [values]);
      if (OdooHelper.isOk(res)) {
        printLog('🔼 POST: create -> $model', startTime);
        return OdooHelper.result(res);
      } else {
        throw Exception(OdooHelper.errorMessage(res));
      }
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<bool> write(String model, List<int> ids, Map values) async {
    try {
      final startTime = DateTime.now();
      final res = await callKW(model, 'write', [ids, values]);
      if (OdooHelper.isOk(res)) {
        printLog('🔼 POST: write -> $model', startTime);
        return OdooHelper.result(res);
      } else {
        throw Exception(OdooHelper.errorMessage(res));
      }
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<bool> unlink(String model, List<int> ids) async {
    try {
      final startTime = DateTime.now();
      final res = await callKW(model, 'unlink', [ids]);
      if (OdooHelper.isOk(res)) {
        printLog('🔼 POST: unlink -> $model', startTime);
        return OdooHelper.result(res);
      } else {
        throw Exception(OdooHelper.errorMessage(res));
      }
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<Map<String, dynamic>> callMethod(
      String model, String method, List args) async {
    try {
      final startTime = DateTime.now();
      final res = await callKW(model, method, [args]);
      if (OdooHelper.isOk(res)) {
        printLog('🔼 POST: callMethod -> $model', startTime);
        return OdooHelper.result(res);
      } else {
        throw Exception(OdooHelper.errorMessage(res));
      }
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<Response> callKW(String model, String method, List args,
      {dynamic kwargs, Map? context}) async {
    kwargs = kwargs ?? {};
    context = context ?? (await Sessions.getUserContext())?.toJson();

    try {
      final res = await clientRequest.post(
          await OdooHelper.buildUrl(
              endPoint: 'web/dataset/call_kw/' + model + '/' + method),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Cookie': await Sessions.getSession() ?? ''
          },
          body: OdooHelper.payLoad({
            'model': model,
            'method': method,
            'args': args,
            'kwargs': kwargs,
            'context': context
          }));

      return res;
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<String?> downloadFile(String fileUrl, String fileName) async {
    try {
      final res = await clientRequest
          .post(await OdooHelper.buildUrl(endPoint: fileUrl), headers: {
        'Content-type': 'application/json; charset=UTF-8',
        'Cookie': await Sessions.getSession() ?? ''
      });

      if (res.contentLength == 0) {
        return null;
      }

      Directory tempDir = await getTemporaryDirectory();
      String filePath = tempDir.path + '/$fileName';
      File file = File(filePath);
      await file.writeAsBytes(res.bodyBytes);
      return filePath;
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<bool> attachFile(String model, String field, int id,
      List<IrAttachmentModel> attachs) async {
    try {
      final res = await clientRequest.post(
          await OdooHelper.buildUrl(endPoint: 'mobile/model/attach'),
          headers: {
            'Content-type': 'application/json; charset=UTF-8',
            'Cookie': await Sessions.getSession() ?? ''
          },
          body: OdooHelper.payLoad(
              {'model': model, 'field': field, 'id': id, 'attachs': attachs}));

      if (OdooHelper.isOk(res)) {
        return true;
      } else {
        throw Exception(OdooHelper.errorMessage(res));
      }
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }
}

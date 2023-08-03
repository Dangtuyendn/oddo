import '../common/utils.dart';

class UserContextModel {
  String? lang;
  String? tz;
  int? uId;

  UserContextModel();

  UserContextModel.fromJson(Map<String, dynamic> parsedJson) {
    try {
      lang = parsedJson['lang'];
      tz = parsedJson['tz'] is String ? parsedJson['tz'] : null;
      uId = parsedJson['uid'];
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {'lang': lang, 'tz': tz, 'uid': uId};
  }
}

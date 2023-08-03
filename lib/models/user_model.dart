import '../common/utils.dart';
import 'usercontext_model.dart';

class UserModel {
  int? uId;
  String? username;
  String? name;
  String? db;
  int? partnerId;
  int? companyId;
  String? baseUrl;
  String? image;
  UserContextModel? userContextModel;

  UserModel();

  UserModel.fromJson(Map<String, dynamic> parsedJson) {
    try {
      uId = parsedJson['uid'];
      username = parsedJson['username'];
      name = parsedJson['name'];
      db = parsedJson['db'];
      partnerId = parsedJson['partner_id'];
      companyId = parsedJson['company_id'];
      baseUrl = parsedJson['baseUrl'];
      image = baseUrl != null
          ? '$baseUrl/web/image/res.users/$uId/image?unique=${DateTime.now().millisecondsSinceEpoch}'
          : null;
      userContextModel = UserContextModel.fromJson(parsedJson['user_context']);
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uId,
      'username': username,
      'name': name,
      'db': db,
      'partner_id': partnerId,
      'companyId': companyId,
      'web.base.url': baseUrl,
      'image': image,
      'user_context': userContextModel!.toJson(),
    };
  }
}

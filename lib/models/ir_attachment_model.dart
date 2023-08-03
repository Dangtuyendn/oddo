import '../common/sessions.dart';
import '../common/utils.dart';
import '../controllers/odoo_controller.dart';
import 'userinfo_model.dart';

class IrAttachmentModel {
  int? id;
  String? name;
  String? datas;
  String? datasFname;
  String? type;

  IrAttachmentModel();

  IrAttachmentModel.fromJson(Map<String, dynamic> parsedJson) {
    try {
      id = parsedJson['id'] is int
          ? parsedJson['id']
          : throw Exception('Id is not null');
      name = parsedJson['name'];
      datas = parsedJson['datas'];
      datasFname = parsedJson['datas_fname'];
      type = parsedJson['type'];
    } catch (e, trace) {
      printLog(e.toString());
      printLog(trace.toString());
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'datas': datas,
      'datas_fname': datasFname,
      'type': type
    };
  }

  Future<Map<String, dynamic>> getDatas() async {
    try {
      UserInfoModel? userInfoModel = await Sessions.getUserInfo();
      int count = 0;
      List<IrAttachmentModel> list = [];
      final result = await OdooController()
          .searchRead('ir.attachment', [], ['id', 'name']);

      count = result['length'];
      for (var item in result['records']) {
        item['datas'] = '${userInfoModel!.baseUrl}/web/content/${item['id']}';
        item['datas_fname'] = item['name'];
        item['type'] = 'url';
        list.add(IrAttachmentModel.fromJson(item));
      }

      return {'count': count, 'list': list};
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<IrAttachmentModel> getDataById(int id) async {
    try {
      UserInfoModel? userInfoModel = await Sessions.getUserInfo();
      final result = await OdooController().read('ir.attachment', [
        id
      ], [
        'id',
        'name',
      ]);

      result[0]['datas'] =
          '${userInfoModel!.baseUrl}/web/content/${result[0]['id']}';
      result[0]['datas_fname'] = result[0]['name'];
      result[0]['type'] = 'url';

      return IrAttachmentModel.fromJson(result[0]);
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }

  Future<List<IrAttachmentModel>> getDataByIds(List<int> ids) async {
    try {
      UserInfoModel? userInfoModel = await Sessions.getUserInfo();
      List<IrAttachmentModel> list = [];
      final result = await OdooController().read('ir.attachment', ids, [
        'id',
        'name',
      ]);
      for (var item in result) {
        item['datas'] = '${userInfoModel!.baseUrl}/web/content/${item['id']}';
        item['datas_fname'] = item['name'];
        item['type'] = 'url';
        list.add(IrAttachmentModel.fromJson(item));
      }
      return list;
    } catch (e, trace) {
      printLog(trace.toString());
      printLog(e.toString());
      rethrow;
    }
  }
}

import '../common/utils.dart';

class UserInfoModel {
  int? id;
  String? name;
  String? function;
  String? mobile;
  String? phone;
  String? email;
  String? street;
  String? street2;
  String? city;
  String? zip;
  String? vat;
  String? tz;
  String? lang;
  String? image;
  String? baseUrl;

  UserInfoModel();

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'];
      function = json['function'] is bool ? '' : json['function'];
      mobile = json['mobile'] is bool ? '' : json['mobile'];
      phone = json['phone'] is bool ? '' : json['phone'];
      email = json['email'] is bool ? '' : json['email'];
      street = json['street'] is bool ? '' : json['street'];
      street2 = json['street2'] is bool ? '' : json['street2'];
      city = json['city'] is bool ? '' : json['city'];
      zip = json['zip'] is bool ? '' : json['zip'];
      vat = json['vat'] is bool ? '' : json['vat'];
      tz = json['tz'] is bool ? '' : json['tz'];
      lang = json['lang'] is bool ? '' : json['lang'];
      image = json['image'];
      baseUrl = json['baseUrl'];
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
      'function': function,
      'mobile': mobile,
      'phone': phone,
      'email': email,
      'street': street,
      'street2': street2,
      'city': city,
      'zip': zip,
      'vat': vat,
      'tz': tz,
      'lang': lang,
      'image': image,
      'baseUrl': baseUrl
    };
  }
}

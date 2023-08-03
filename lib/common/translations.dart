import 'package:flutter/services.dart';
import 'dart:convert' as convert;
import '../common/config.dart';
import '../common/sessions.dart';

class Translations {
  static Map<String, dynamic> langValue = {};
  static Future<void> setTranslations() async {
    String langCode = await Sessions.getLang() ?? AppConfig.defaultLang;
    final langValueStr =
        await rootBundle.loadString('assets/langs/$langCode.json');
    langValue = convert.jsonDecode(langValueStr);
  }

  static Future<void> updateTranslations() async {}

  static String getString(String module, String id) {
    List messages = langValue[module]?['messages'] ?? [];
    var value = messages.firstWhere((element) => element['id'] == id,
        orElse: () => null);
    return value == null ? id : value['string'];
  }
}

import 'package:flutter/services.dart';
import 'dart:convert' as convert;

class AppConfig {
  static String splashTitle = '';
  static String splashLogoImage = '';
  static int splashScreenDuration = 0;

  static String welcomeLogin = '';
  static List<String> listProtocol = [];
  static String defaultProtocol = '';
  static String defaultHost = '';
  static String userBot = '';
  static String passBot = '';

  static List<String> listLangs = [];
  static String defaultLang = '';

  static int requestTimeOut = 0;
  static int imageQuality = 0;
  static int maxSizeImage = 0;

  static String hostLine = '';

  static Future<void> setConfig() async {
    final configStr = await rootBundle.loadString('assets/config/config.json');
    final data = convert.jsonDecode(configStr);

    splashTitle = data['splashTitle'];
    splashLogoImage = data['splashLogoImage'];
    splashScreenDuration = data['splashScreenDuration'];

    welcomeLogin = data['loginWelcome'];
    listProtocol = List<String>.from(data['listProtocol']);
    defaultProtocol = data['defaultProtocol'];
    defaultHost = data['defaultHost'];
    userBot = data['userBot'];
    passBot = data['passBot'];

    listLangs = List<String>.from(data['listLangs']);
    defaultLang = data['defaultLang'];

    requestTimeOut = data['requestTimeOut'];

    imageQuality = data['imageQuality'];
    maxSizeImage = data['maxSizeImage'];

    hostLine = data['hostLine'];
  }
}

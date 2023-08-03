import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/userinfo_model.dart';
import '../models/usercontext_model.dart';

class Sessions {
  static const isTheFirstSession = 'isTheFirstSession';
  static const hostSession = 'hostSession';
  static const protocolSession = 'protocolSession';
  static const databaseSession = 'databaseSession';
  static const databasesSession = 'databasesSession';
  static const isChangeServerSession = 'isChangeServerSession';
  static const usernameSession = 'usernameSession';
  static const userSession = 'userSession';
  static const usercontextSession = 'usercontextSession';
  static const userinfoSession = 'userinfoSession';
  static const langSession = 'langSession';
  static const sessionSession = 'sessionSession';
  static const isTheFirstSyncSession = 'isTheFirstSyncSession';
  static const dashBoardSession = 'dashBoardSession';

  static final sharedPreferences = SharedPreferences.getInstance();

  //SET
  static Future<void> setTheFirst(bool isTheFirst) async {
    SharedPreferences preferences = await sharedPreferences;
    preferences.setBool(isTheFirstSession, isTheFirst);
  }

  static Future<void> setProtocol(String protocol) async {
    SharedPreferences preferences = await sharedPreferences;
    preferences.setString(protocolSession, protocol);
  }

  static Future<void> setHost(String host) async {
    SharedPreferences preferences = await sharedPreferences;
    preferences.setString(hostSession, host);
  }

  static Future<void> setDatabases(List<String> databases) async {
    SharedPreferences preferences = await sharedPreferences;
    preferences.setStringList(databasesSession, databases);
  }

  static Future<void> setDatabase(String database) async {
    SharedPreferences preferences = await sharedPreferences;
    preferences.setString(databaseSession, database);
  }

  static Future<void> setIsChangeServer(bool isChange) async {
    SharedPreferences preferences = await sharedPreferences;
    preferences.setBool(isChangeServerSession, isChange);
  }

  static Future<void> setUsername(String username) async {
    SharedPreferences preferences = await sharedPreferences;
    preferences.setString(usernameSession, username);
  }

  static Future<void> setUser(UserModel user) async {
    String userStr = convert.jsonEncode(user.toJson());
    SharedPreferences preferences = await sharedPreferences;
    preferences.setString(userSession, userStr);
  }

  static Future<void> setUserContext(UserContextModel usercontext) async {
    String usercontextStr = convert.jsonEncode(usercontext.toJson());
    SharedPreferences preferences = await sharedPreferences;
    preferences.setString(usercontextSession, usercontextStr);
  }

  static Future<void> setUserInfo(UserInfoModel userinfo) async {
    String userinfoStr = convert.jsonEncode(userinfo.toJson());
    SharedPreferences preferences = await sharedPreferences;
    preferences.setString(userinfoSession, userinfoStr);
  }

  static Future<void> setLang(String lang) async {
    SharedPreferences preferences = await sharedPreferences;
    preferences.setString(langSession, lang);
  }

  static Future<void> setSession(String session) async {
    SharedPreferences preferences = await sharedPreferences;
    preferences.setString(sessionSession, session);
  }

  static Future<void> setTheFirstSync(bool isTheFirstSync) async {
    SharedPreferences preferences = await sharedPreferences;
    preferences.setBool(isTheFirstSyncSession, isTheFirstSync);
  }

  static Future<void> setDashboard(Map<String, dynamic> dataDashboard) async {
    SharedPreferences preferences = await sharedPreferences;
    preferences.setString(dashBoardSession, convert.jsonEncode(dataDashboard));
  }

  //GET
  static Future<bool> getTheFirst() async {
    SharedPreferences preferences = await sharedPreferences;
    return preferences.getBool(isTheFirstSession) ?? true;
  }

  static Future<String?> getProtocol() async {
    SharedPreferences preferences = await sharedPreferences;
    return preferences.getString(protocolSession);
  }

  static Future<String?> getHost() async {
    SharedPreferences preferences = await sharedPreferences;
    return preferences.getString(hostSession);
  }

  static Future<List<String>?> getDatabases() async {
    SharedPreferences preferences = await sharedPreferences;
    return preferences.getStringList(databasesSession);
  }

  static Future<String?> getDatabase() async {
    SharedPreferences preferences = await sharedPreferences;
    return preferences.getString(databaseSession);
  }

  static Future<bool> getIsChangeServer() async {
    SharedPreferences preferences = await sharedPreferences;
    return preferences.getBool(isChangeServerSession) ?? true;
  }

  static Future<String?> getUsername() async {
    SharedPreferences preferences = await sharedPreferences;
    return preferences.getString(usernameSession);
  }

  static Future<UserModel?> getUser() async {
    SharedPreferences preferences = await sharedPreferences;
    String? userStr = preferences.getString(userSession);

    return userStr == null
        ? null
        : UserModel.fromJson(convert.jsonDecode(userStr));
  }

  static Future<UserContextModel?> getUserContext() async {
    SharedPreferences preferences = await sharedPreferences;
    String? usercontextStr = preferences.getString(usercontextSession);

    return usercontextStr == null
        ? null
        : UserContextModel.fromJson(convert.jsonDecode(usercontextStr));
  }

  static Future<UserInfoModel?> getUserInfo() async {
    SharedPreferences preferences = await sharedPreferences;
    String? userinfoStr = preferences.getString(userinfoSession);

    return userinfoStr == null
        ? null
        : UserInfoModel.fromJson(convert.jsonDecode(userinfoStr));
  }

  static Future<String?> getLang() async {
    SharedPreferences preferences = await sharedPreferences;
    return preferences.getString(langSession);
  }

  static Future<String?> getSession() async {
    SharedPreferences preferences = await sharedPreferences;
    return preferences.getString(sessionSession);
  }

  static Future<bool> getTheFirstSync() async {
    SharedPreferences preferences = await sharedPreferences;
    return preferences.getBool(isTheFirstSyncSession) ?? true;
  }

  static Future<Map<String, dynamic>?> getDashboard() async {
    SharedPreferences preferences = await sharedPreferences;
    String? dataDashboardStr = preferences.getString(dashBoardSession);
    if (dataDashboardStr == null) {
      return null;
    }
    return convert.jsonDecode(dataDashboardStr);
  }

  //CLEAR LOGOUT
  static Future<void> clearLogout() async {
    SharedPreferences preferences = await sharedPreferences;
    preferences
        .getKeys()
        .where((key) => (key == userSession ||
            key == userinfoSession ||
            key == sessionSession))
        .map((key) async => await preferences.remove(key))
        .toList();
  }

  //CLEAR CHANG SERVER
  static Future<void> clearChangeServer() async {
    SharedPreferences preferences = await sharedPreferences;
    preferences
        .getKeys()
        .where((key) => (key != isTheFirstSession))
        .map((key) async => await preferences.remove(key))
        .toList();
  }

  //CLEAR ALL
  static Future<void> clearAll() async {
    SharedPreferences preferences = await sharedPreferences;
    await preferences.clear();
  }
}

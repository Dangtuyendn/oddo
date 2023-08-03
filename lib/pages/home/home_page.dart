import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../common/translations.dart';
import '../../common/sessions.dart';
import '../../common/styles.dart';
import '../../models/userinfo_model.dart';
import '../../views/main_view.dart';

class HomePage extends StatefulWidget {
  final String namePage;
  const HomePage({Key? key, required this.namePage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserInfoModel? _userInfoModel;
  String? _odooSession;
  bool _isLoading = true;
  String? _versionApp;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _odooSession = await Sessions.getSession();
      _userInfoModel = await Sessions.getUserInfo();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _versionApp = packageInfo.version;

      hideLoading();
    });
  }

  void showLoading() {
    _isLoading = true;
    setState(() {});
  }

  void hideLoading() {
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
      namePage: widget.namePage,
      userInfoModel: _userInfoModel,
      odooSession: _odooSession,
      title: Translations.getString('mainApp', 'home'),
      paddingBody: EdgeInsets.zero,
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(gradient: Styles.gradient),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Home Page',
                  style: TextStyle(
                      color: Styles.backGroundColor,
                      fontWeight: Styles.lightFontWeight,
                      fontSize: Styles.f18)),
              Text('Version: $_versionApp',
                  style: TextStyle(
                      color: Styles.backGroundColor,
                      fontWeight: Styles.lightFontWeight,
                      fontSize: Styles.f18))
            ],
          )),
      onLoading: () {
        return _isLoading;
      },
    );
  }
}

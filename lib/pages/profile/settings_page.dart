import 'package:flutter/material.dart';
import '../../common/sessions.dart';
import '../../common/styles.dart';
import '../../common/translations.dart';
import '../../models/userinfo_model.dart';
import '../../views/main_view.dart';

class SettingsPage extends StatefulWidget {
  final String namePage;
  const SettingsPage({Key? key, required this.namePage}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserInfoModel? _userInfoModel;
  String? _odooSession;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 2));
      _odooSession = await Sessions.getSession();
      _userInfoModel = await Sessions.getUserInfo();

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
      title: Translations.getString('mainApp', 'titleSettings'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(vertical: Styles.medium),
            child: Text('SETTINGS COMMING SOON!'),
          )
        ],
      ),
      onLoading: () {
        return _isLoading;
      },
    );
  }
}

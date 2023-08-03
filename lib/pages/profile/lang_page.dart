import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/config.dart';
import '../../controllers/odoo_controller.dart';
import '../../models/usercontext_model.dart';
import '../../common/sessions.dart';
import '../../common/styles.dart';
import '../../common/tools.dart';
import '../../common/translations.dart';
import '../../common/utils.dart';
import '../../models/userinfo_model.dart';
import '../../views/main_view.dart';

class LangPage extends StatefulWidget {
  final String namePage;
  const LangPage({Key? key, required this.namePage}) : super(key: key);

  @override
  State<LangPage> createState() => _LangPageState();
}

class _LangPageState extends State<LangPage> {
  UserInfoModel? _userInfoModel;
  String? _odooSession;
  String? _langSession;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _odooSession = await Sessions.getSession();
      _userInfoModel = await Sessions.getUserInfo();
      _langSession = await Sessions.getLang();

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

  List<Widget> widgetLanguages() {
    return AppConfig.listLangs
        .map((lang) => ListTile(
            leading: Image.asset(
              'assets/images/country/$lang.png',
              width: 30,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(
              Translations.getString('mainApp', lang),
              style: TextStyle(
                  color: _langSession == lang
                      ? Styles.primaryColor
                      : Styles.darkTextColor,
                  fontSize: Styles.f14),
            ),
            trailing: _langSession == lang
                ? const Icon(Icons.check, color: Styles.primaryColor)
                : null,
            onTap: () async {
              HapticFeedback.heavyImpact();

              if (_isLoading) {
                Tools.showSnackBar(context, false,
                    Translations.getString('mainApp', 'pleaseWait'));
                return;
              }

              showLoading();
              try {
                _langSession = lang;
                final saveOK = await OdooController().write(
                    'res.partner', [_userInfoModel!.id!], {'lang': lang});
                if (saveOK) {
                  UserContextModel? _userContextModel =
                      await Sessions.getUserContext();
                  _userContextModel!.lang = lang;
                  await Sessions.setUserContext(_userContextModel);
                  await Sessions.setLang(lang);
                  await Translations.setTranslations();
                  Tools.showSnackBar(context, true,
                      Translations.getString('mainApp', 'updateSuccess'));
                } else {
                  Tools.showSnackBar(context, false,
                      Translations.getString('mainApp', 'updateFail'));
                }
              } catch (e, trace) {
                printLog(e.toString());
                printLog(trace.toString());
                Tools.showSnackBar(context, false, e.toString());
                Tools.checkSessionExpired(context, e.toString());
              }

              hideLoading();
            }))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
      namePage: widget.namePage,
      userInfoModel: _userInfoModel,
      odooSession: _odooSession,
      title: Translations.getString('mainApp', 'titleLang'),
      body: ListView(
        children: widgetLanguages(),
      ),
      onLoading: () {
        return _isLoading;
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import '../common/sessions.dart';
import '../common/tools.dart';
import '../common/translations.dart';
import '../common/utils.dart';
import '../controllers/odoo_controller.dart';
import '../common/styles.dart';
import '../models/userinfo_model.dart';
import '../routes/routes.dart';

class SideBarView extends StatelessWidget {
  final String namePage;
  final UserInfoModel? userInfoModel;
  final String? odooSession;
  const SideBarView(
      {Key? key, required this.namePage, this.userInfoModel, this.odooSession})
      : super(key: key);

  Widget widgetHome(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.home,
            color: namePage == 'homePage'
                ? Styles.primaryColor
                : Styles.darkTextColor),
        title: Text(
          Translations.getString('mainApp', 'home'),
          style: TextStyle(
              color: namePage == 'homePage'
                  ? Styles.primaryColor
                  : Styles.darkTextColor,
              fontSize: Styles.f14),
        ),
        onTap: () async {
          HapticFeedback.heavyImpact();
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Routes.homePage));
        });
  }

  //Menu core
  Widget widgetProfile(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.person,
            color: namePage == 'profilePage'
                ? Styles.primaryColor
                : Styles.darkTextColor),
        title: Text(
          Translations.getString('mainApp', 'myProfile'),
          style: TextStyle(
              color: namePage == 'profilePage'
                  ? Styles.primaryColor
                  : Styles.darkTextColor,
              fontSize: Styles.f14),
        ),
        onTap: () async {
          HapticFeedback.heavyImpact();
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Routes.profilePage));
        });
  }

  Widget widgetUpdatePassword(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.vpn_key,
            color: namePage == 'passwordPage'
                ? Styles.primaryColor
                : Styles.darkTextColor),
        title: Text(
          Translations.getString('mainApp', 'updatePassword'),
          style: TextStyle(
              color: namePage == 'passwordPage'
                  ? Styles.primaryColor
                  : Styles.darkTextColor,
              fontSize: Styles.f14),
        ),
        onTap: () async {
          HapticFeedback.heavyImpact();
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Routes.passwordPage));
        });
  }

  Widget widgetChangeLang(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.language,
            color: namePage == 'langPage'
                ? Styles.primaryColor
                : Styles.darkTextColor),
        title: Text(
          Translations.getString('mainApp', 'changeLang'),
          style: TextStyle(
              color: namePage == 'langPage'
                  ? Styles.primaryColor
                  : Styles.darkTextColor,
              fontSize: Styles.f14),
        ),
        onTap: () async {
          HapticFeedback.heavyImpact();
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Routes.langPage));
        });
  }

  Widget widgetSettings(BuildContext context) {
    return ListTile(
        leading: Icon(Icons.settings,
            color: namePage == 'settingsPage'
                ? Styles.primaryColor
                : Styles.darkTextColor),
        title: Text(
          Translations.getString('mainApp', 'settings'),
          style: TextStyle(
              color: namePage == 'settingsPage'
                  ? Styles.primaryColor
                  : Styles.darkTextColor,
              fontSize: Styles.f14),
        ),
        onTap: () async {
          HapticFeedback.heavyImpact();
          Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Routes.settingsPage));
        });
  }

  Widget widgetLogout(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Styles.darkTextColor),
      title: Text(
        Translations.getString('mainApp', 'logout'),
        style:
            const TextStyle(color: Styles.darkTextColor, fontSize: Styles.f14),
      ),
      onTap: () async {
        HapticFeedback.heavyImpact();
        bool confirm = await Tools.showMyDialog(
                context: context,
                icons: const Icon(Icons.warning, color: Styles.warningColor),
                title: Text(Translations.getString('mainApp', 'warning'),
                    style: const TextStyle(
                        color: Styles.warningColor,
                        fontSize: Styles.f16,
                        fontWeight: Styles.mediumFontWeight)),
                body: ListBody(
                  children: <Widget>[
                    Text(
                      Translations.getString('mainApp', 'areYouSure2Logout?'),
                      style: const TextStyle(
                          color: Styles.darkTextColor,
                          fontWeight: Styles.lightFontWeight,
                          fontSize: Styles.f16),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      child: Text(Translations.getString('mainApp', 'ok')),
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        Navigator.of(context).pop(true);
                      }),
                  TextButton(
                      child: Text(Translations.getString('mainApp', 'cancel')),
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        Navigator.of(context).pop(false);
                      }),
                ]) ??
            false;
        if (confirm) {
          await OdooController().logout();
          await Sessions.clearLogout();
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Routes.loginPage),
              (Route<dynamic> route) => false);
        }
      },
    );
  }

  Widget widgetDeleteAcount(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete, color: Styles.errorColor),
      title: Text(
        Translations.getString('mainApp', 'deleteAcount'),
        style: const TextStyle(color: Styles.errorColor, fontSize: Styles.f14),
      ),
      onTap: () async {
        HapticFeedback.heavyImpact();
        bool confirm = await Tools.showMyDialog(
                context: context,
                icons: const Icon(Icons.warning, color: Styles.warningColor),
                title: Text(Translations.getString('mainApp', 'warning'),
                    style: const TextStyle(
                        color: Styles.warningColor,
                        fontSize: Styles.f16,
                        fontWeight: Styles.mediumFontWeight)),
                body: ListBody(
                  children: <Widget>[
                    Text(
                      Translations.getString(
                          'mainApp', 'areYouSure2DeleteAccount?'),
                      style: const TextStyle(
                          color: Styles.darkTextColor,
                          fontWeight: Styles.lightFontWeight,
                          fontSize: Styles.f16),
                      textAlign: TextAlign.center,
                      softWrap: true,
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                      child: Text(Translations.getString('mainApp', 'ok')),
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        Navigator.of(context).pop(true);
                      }),
                  TextButton(
                      child: Text(Translations.getString('mainApp', 'cancel')),
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        Navigator.of(context).pop(false);
                      }),
                ]) ??
            false;
        if (confirm) {
          try {
            await OdooController().deleteAccount();
            await Sessions.clearChangeServer();
            Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        Routes.loginPage),
                (Route<dynamic> route) => false);
          } catch (e, trace) {
            printLog(e.toString());
            printLog(trace.toString());
            Tools.showSnackBar(context, false,
                Translations.getString('mainApp', 'cannotDeleteAccount'));
            Navigator.of(context).pop();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: const BoxDecoration(color: Styles.primaryColor),
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + Styles.medium,
                bottom: 10.0,
                left: 10.0,
                right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      showModalBottomSheet<Map>(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return PhotoView(
                                imageProvider: (userInfoModel == null
                                    ? const AssetImage(
                                        'assets/avatars/user_icon.png')
                                    : NetworkImage(userInfoModel!.image!,
                                        headers: {
                                            'Cookie': odooSession ?? ''
                                          })) as ImageProvider);
                          });
                    },
                    child: Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (userInfoModel == null
                                  ? const AssetImage(
                                      'assets/avatars/user_icon.png')
                                  : NetworkImage(userInfoModel!.image!,
                                      headers: {
                                          'Cookie': odooSession ?? ''
                                        })) as ImageProvider)),
                    )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Styles.large),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        userInfoModel?.name ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Styles.lightTextColor,
                            fontSize: Styles.f20,
                            fontWeight: Styles.mediumFontWeight),
                      ),
                      Text(
                        userInfoModel?.email ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Styles.lightTextColor,
                            fontSize: Styles.f14,
                            fontWeight: Styles.lightFontWeight),
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
          Expanded(
              child: ListView(
            padding: const EdgeInsets.all(0.0),
            children: <Widget>[
              widgetHome(context),
              const Divider(color: Styles.darkTextColor),
              widgetProfile(context),
              widgetUpdatePassword(context),
              widgetChangeLang(context),
              widgetSettings(context),
              widgetLogout(context),
              widgetDeleteAcount(context)
            ],
          ))
        ],
      ),
    );
  }
}

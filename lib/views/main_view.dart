import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import '../common/translations.dart';
import '../common/styles.dart';
import '../common/tools.dart';
import '../models/userinfo_model.dart';
import '../models/internet_model.dart';
import 'sidebar_view.dart';

class MainView extends StatelessWidget {
  final String namePage;
  final UserInfoModel? userInfoModel;
  final String? odooSession;
  final String title;
  final Widget body;
  final EdgeInsetsGeometry? paddingBody;
  final Function? onBack;
  final Widget? floatingActionButton;
  final Function? onLoading;
  final List<Widget>? actionBefore;
  final List<Widget>? actionAfter;
  final int? countNotification;
  final List? action;

  const MainView(
      {Key? key,
      required this.namePage,
      this.userInfoModel,
      this.odooSession,
      required this.title,
      this.paddingBody,
      required this.body,
      this.onBack,
      this.floatingActionButton,
      this.onLoading,
      this.action,
      this.actionBefore,
      this.actionAfter,
      this.countNotification})
      : super(key: key);

  Future<bool?> onWillPop(BuildContext context) async {
    return await Tools.showMyDialog(
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
                  Translations.getString('mainApp', 'areYouSure2Quit?'),
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
  }

  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final connected = connectivity != ConnectivityResult.none;
          InternetModel.setOff = !connected;

          return Stack(
            fit: StackFit.expand,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(bottom: Styles.xxlarge),
                child: child,
              ),
              Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: AnimatedContainer(
                    height: Styles.xxlarge,
                    duration: const Duration(milliseconds: 150),
                    color: connected ? Styles.primaryColor : Styles.errorColor,
                    child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            connected
                                ? const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Styles.small),
                                    child: Icon(
                                      Icons.wifi,
                                      size: 20,
                                      color: Styles.backGroundColor,
                                    ),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Styles.small),
                                    child: Icon(
                                      Icons.wifi_off,
                                      size: 20,
                                      color: Styles.backGroundColor,
                                    ),
                                  ),
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: Styles.medium),
                                    child: Text(
                                      connected
                                          ? Translations.getString(
                                              'mainApp', 'youAreOnl')
                                          : Translations.getString(
                                              'mainApp', 'youAreOff'),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Styles.backGroundColor,
                                          fontSize: Styles.f12,
                                          fontWeight: Styles.lightFontWeight),
                                    )))
                          ],
                        )),
                  )),
            ],
          );
        },
        child: WillPopScope(
          child: GestureDetector(
              onTap: () {
                Tools.hideKeyboard(context);
              },
              behavior: HitTestBehavior.opaque,
              child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(55.0),
                    child: AppBar(
                      title: Text(title,
                          style: const TextStyle(
                              color: Styles.lightTextColor,
                              fontWeight: Styles.mediumFontWeight,
                              fontSize: Styles.f16)),
                      backgroundColor: Styles.primaryColor,
                      elevation: 0.8,
                      actions: [],
                    ),
                  ),
                  drawer: SideBarView(
                      namePage: namePage,
                      userInfoModel: userInfoModel,
                      odooSession: odooSession),
                  onDrawerChanged: (value) {
                    if (value) {
                      Tools.hideKeyboard(context);
                    }
                  },
                  body: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration:
                          const BoxDecoration(color: Styles.backGroundColor),
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Padding(
                            padding: paddingBody ??
                                const EdgeInsets.symmetric(
                                    horizontal: Styles.medium,
                                    vertical: Styles.medium),
                            child: body,
                          ),
                          if (onLoading != null && onLoading!()) Tools.loading()
                        ],
                      )),
                  floatingActionButton: floatingActionButton)),
          onWillPop: () async {
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
              return Future.value(true);
            }
            return (await onWillPop(context)) ?? false;
          },
        ));
  }
}

class CounterNotification with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;

  int get getCountNotification => _count;

  void setCount(int value) {
    _count = value;
    notifyListeners();
  }
}

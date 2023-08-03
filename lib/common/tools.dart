import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../common/sessions.dart';
import '../routes/routes.dart';
import 'styles.dart';
import 'translations.dart';

class Tools {
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
      snackBarController;

  static imageAsset(String image, {double? width, double? height}) {
    return Image.asset(
      image,
      width: width,
      height: height,
    );
  }

  static svgAsset(String svg, {double? width, double? height}) {
    return SvgPicture.asset(svg, width: width, height: height);
  }

  static loading() {
    return Container(
        alignment: Alignment.center,
        decoration:
            const BoxDecoration(color: Color.fromARGB(90, 255, 255, 255)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SpinKitFadingCircle(color: Styles.darkTextColor),
            Text(Translations.getString('mainApp', 'loading'))
          ],
        ));
  }

  static showSnackBar(BuildContext context, bool stt, String msg,
      {int? duration}) {
    try {
      snackBarController!.close();
    } catch (_) {}

    snackBarController = ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: stt ? Styles.infoColor : Styles.errorColor,
      padding: const EdgeInsets.symmetric(
          horizontal: Styles.small, vertical: Styles.small),
      content: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Styles.medium, vertical: Styles.large),
        child: Text(msg,
            style: const TextStyle(
                color: Styles.lightTextColor,
                fontSize: Styles.f16,
                fontWeight: Styles.lightFontWeight)),
      ),
      duration: Duration(seconds: duration ?? 3),
    ));
  }

  static checkSessionExpired(BuildContext context, String msg) {
    if (msg == 'Exception: Session expired') {
      Sessions.clearLogout();
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  Routes.loginPage),
          (Route<dynamic> route) => false);
    }
  }

  static hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static Future<dynamic> showMyDialog(
      {required BuildContext context,
      required Widget icons,
      required Widget title,
      required Widget body,
      List<Widget>? actions}) async {
    return await showDialog<dynamic>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Styles.backGroundColor,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    icons,
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: Styles.medium),
                      child: title,
                    )
                  ],
                ),
                const Divider(
                  color: Colors.orangeAccent,
                )
              ],
            ),
            contentPadding: const EdgeInsets.all(8.0),
            content: SingleChildScrollView(
              child: body,
            ),
            actions: actions,
          );
        });
  }
}

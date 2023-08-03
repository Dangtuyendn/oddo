import 'dart:async';
import 'package:flutter/material.dart';
import '../../common/sessions.dart';
import '../../common/config.dart';
import '../../common/styles.dart';
import '../../routes/routes.dart';

class SplashPage extends StatefulWidget {
  final String namePage;
  const SplashPage({Key? key, required this.namePage}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: AppConfig.splashScreenDuration));
      final isTheFirst = await Sessions.getTheFirst();
      final userInfo = await Sessions.getUserInfo();

      if (isTheFirst) {
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    Routes.introPage),
            (Route<dynamic> route) => false);
      } else if (userInfo != null) {
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    Routes.homePage),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    Routes.loginPage),
            (Route<dynamic> route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(gradient: Styles.gradient),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CircularProgressIndicator(
                    backgroundColor: Styles.backGroundColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppConfig.splashTitle,
                    style: const TextStyle(
                        color: Styles.lightTextColor,
                        fontSize: Styles.f18,
                        fontWeight: Styles.mediumFontWeight),
                  )
                ],
              ),
            )
          ],
        )
      ],
    ));
  }
}

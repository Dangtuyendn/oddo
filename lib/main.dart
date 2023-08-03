import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import '../views/main_view.dart';
import 'package:provider/provider.dart';
import 'common/config.dart';
import 'common/styles.dart';
import 'common/translations.dart';
import 'routes/routes.dart';
import 'common/utils.dart';

final GlobalKey<NavigatorState> navigatorKeyMain = GlobalKey<NavigatorState>();

class PostHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.black,
  ));

  /// Lock portrait mode.
  unawaited(
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]));

  runZonedGuarded(() async {
    await Firebase.initializeApp();
    await AppConfig.setConfig();
    await Translations.setTranslations();

    HttpOverrides.global = new PostHttpOverrides();
    runApp(MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => CounterNotification()),
    ], child: Phoenix(child: const MyApp())));
  }, (e, stack) {
    printLog(e);
    printLog(stack);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WMS',
      theme: ThemeData(
          unselectedWidgetColor: Styles.primaryColor,
          dividerColor: Styles.transparentColor,
          fontFamily: 'TitilliumWeb'),
      home: Routes.splashPage,
      navigatorKey: navigatorKeyMain,
    );
  }
}

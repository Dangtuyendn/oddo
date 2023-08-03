import '../pages/login/register_page.dart';
import '../pages/profile/lang_page.dart';
import '../pages/profile/settings_page.dart';
import '../pages/intro/intro_page.dart';
import '../pages/login/login_page.dart';
import '../pages/profile/password_page.dart';
import '../pages/profile/profile_page.dart';
import '../pages/splash/splash_page.dart';
import '../pages/home/home_page.dart';

class Routes {
  static final splashPage = SplashPage(namePage: NamePage.splashPage);
  static final introPage = IntroPage(namePage: NamePage.introPage);
  static final loginPage = LoginPage(namePage: NamePage.loginPage);
  static final registerPage = RegisterPage(namePage: NamePage.registerPage);
  static final profilePage = ProfilePage(namePage: NamePage.profilePage);
  static final passwordPage = PasswordPage(namePage: NamePage.passwordPage);
  static final settingsPage = SettingsPage(namePage: NamePage.settingsPage);
  static final langPage = LangPage(namePage: NamePage.langPage);
  static final homePage = HomePage(namePage: NamePage.homePage);
}

class NamePage {
  static String splashPage = 'splashPage';
  static String introPage = 'introPage';
  static String loginPage = 'loginPage';
  static String registerPage = 'registerPage';
  static String profilePage = 'profilePage';
  static String passwordPage = 'passwordPage';
  static String settingsPage = 'settingsPage';
  static String langPage = 'langPage';
  static String homePage = 'homePage';
}

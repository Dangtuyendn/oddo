import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/translations.dart';
import '../../common/config.dart';
import '../../common/sessions.dart';
import '../../common/tools.dart';
import '../../common/utils.dart';
import '../../models/userinfo_model.dart';
import '../../common/styles.dart';
import '../../controllers/odoo_controller.dart';
import '../../models/user_model.dart';
import '../../routes/routes.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  final String namePage;
  const LoginPage({Key? key, required this.namePage}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _protocolNode = FocusNode();
  final _hostNode = FocusNode();
  final _dbsNode = FocusNode();
  final _usernameNode = FocusNode();
  final _passwordNode = FocusNode();

  final _hostControllers = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _protocol = AppConfig.defaultProtocol;
  List<String> _databases = <String>[];
  String _database = '';
  bool _isChangeServer = true;
  bool _isShowPass = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _isChangeServer = await Sessions.getIsChangeServer();
      _protocol = await Sessions.getProtocol() ?? AppConfig.defaultProtocol;
      _hostControllers.text = await Sessions.getHost() ?? AppConfig.defaultHost;
      _databases = await Sessions.getDatabases() ?? <String>[];
      _database = await Sessions.getDatabase() ?? '';
      _usernameController.text = await Sessions.getUsername() ?? '';

      try {
        if (_database.isEmpty) {
          _databases = await OdooController()
              .getDatabases(_protocol, _hostControllers.text);
          _database = _databases[0];
          await Sessions.setProtocol(_protocol);
          await Sessions.setHost(_hostControllers.text);
          await Sessions.setDatabase(_database);
          await Sessions.setDatabases(_databases);
        }
      } catch (_) {}

      hideLoading();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _protocolNode.dispose();
    _dbsNode.dispose();
    _hostNode.dispose();
    _usernameNode.dispose();
    _passwordNode.dispose();

    _usernameController.dispose();
    _passwordController.dispose();
  }

  void showLoading() {
    _isLoading = true;
    _isLoading = true;
    setState(() {});
  }

  void hideLoading() {
    _isLoading = false;
    setState(() {});
  }

  void hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Future loginAction() async {
    if (_isLoading) {
      Tools.showSnackBar(
          context, false, Translations.getString('mainApp', 'pleaseWait'));
      return;
    }

    hideKeyboard();

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showLoading();
      try {
        final loginOK = await OdooController().authenticate(
            _usernameController.text, _passwordController.text, _database);
        loginOK['baseUrl'] = '$_protocol://${_hostControllers.text}';
        final user = UserModel.fromJson(loginOK);

        final userInfoJson = await OdooController().read(
            'res.partner',
            [user.partnerId ?? 0],
            [
              'id',
              'name',
              'display_name',
              'function',
              'mobile',
              'phone',
              'email',
              'email_formatted',
              'street',
              'street2',
              'city',
              'zip',
              'vat',
              'tz',
              'lang',
            ],
            context: user.userContextModel!.toJson());
        if (userInfoJson.isEmpty) {
          Tools.showSnackBar(
              context, false, Translations.getString('mainApp', 'notUserInfo'));
        } else {
          userInfoJson[0]['image'] = user.image;
          userInfoJson[0]['baseUrl'] = user.baseUrl;
          final userInfo = UserInfoModel.fromJson(userInfoJson[0]);

          await Sessions.setIsChangeServer(false);
          await Sessions.setDatabase(_database);
          await Sessions.setUsername(_usernameController.text);
          await Sessions.setUser(user);
          await Sessions.setUserContext(user.userContextModel!);
          await Sessions.setUserInfo(userInfo);
          await Sessions.setLang(userInfo.lang ?? AppConfig.defaultLang);
          await Translations.setTranslations();

          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      Routes.homePage),
              (Route<dynamic> route) => false);

          Tools.showSnackBar(context, true, 'Welcome ${userInfo.name}!');
        }
      } catch (e, trace) {
        printLog(e.toString());
        printLog(trace.toString());
        Tools.showSnackBar(context, false, e.toString());
      }
      hideLoading();
    }
  }

  Widget widgetProtocol() {
    return SizedBox(
        width: 90,
        child: DropdownSearch<String>(
            mode: Mode.BOTTOM_SHEET,
            items: AppConfig.listProtocol,
            selectedItem: _protocol,
            focusNode: _protocolNode,
            dropdownButtonProps: const IconButtonProps(
                icon: Icon(Icons.arrow_drop_down,
                    color: Color.fromARGB(153, 255, 255, 255))),
            dropdownSearchDecoration: InputDecoration(
              label: Text(
                Translations.getString('mainApp', 'protocol'),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: Styles.f18,
                    color: Color.fromARGB(153, 255, 255, 255),
                    fontWeight: Styles.lightFontWeight),
              ),
              errorStyle: const TextStyle(color: Styles.errorColor),
              enabledBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(153, 255, 255, 255))),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Styles.lightTextColor),
              ),
            ),
            dropdownBuilder: (BuildContext context, String? item) {
              return Text(
                item ?? '',
                style: const TextStyle(
                    color: Styles.lightTextColor,
                    fontSize: Styles.f18,
                    fontWeight: Styles.lightFontWeight),
              );
            },
            popupItemBuilder:
                (BuildContext context, String item, bool isSelected) {
              isSelected = _protocol == item;
              return Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: Styles.small, vertical: Styles.small),
                decoration: BoxDecoration(
                    border: Border.all(color: Styles.primaryColor),
                    borderRadius: BorderRadius.circular(Styles.small),
                    color: isSelected
                        ? Styles.backGroundColor
                        : Styles.transparentColor),
                child: ListTile(
                  title: Text(item.toString(),
                      style: const TextStyle(
                          fontSize: Styles.f18,
                          color: Styles.primaryColor,
                          fontWeight: Styles.lightFontWeight)),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Styles.primaryColor,
                        )
                      : null,
                ),
              );
            },
            onChanged: (String? val) async {
              _protocol = val!;
              await Sessions.setProtocol(_protocol);
              setState(() {});
            }));
  }

  Widget widgetHost() {
    return Expanded(
        child: TextFormField(
            style: const TextStyle(
                color: Styles.lightTextColor,
                fontSize: Styles.f18,
                fontWeight: Styles.lightFontWeight),
            focusNode: _hostNode,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (String? val) async {
              if (val != null) {
                showLoading();
                try {
                  _databases =
                      await OdooController().getDatabases(_protocol, val);
                  _database = _databases[0];
                  await Sessions.setProtocol(_protocol);
                  await Sessions.setHost(_hostControllers.text);
                  await Sessions.setDatabases(_databases);

                  _hostNode.unfocus();
                  FocusScope.of(context).requestFocus(_usernameNode);
                } catch (e, trace) {
                  printLog(e.toString());
                  printLog(trace.toString());
                  Tools.showSnackBar(context, false, e.toString());
                }
                hideLoading();
              }
            },
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              label: Text(
                Translations.getString('mainApp', 'host'),
                style: const TextStyle(
                    fontSize: Styles.f18,
                    color: Color.fromARGB(153, 255, 255, 255),
                    fontWeight: Styles.lightFontWeight),
              ),
              errorStyle: const TextStyle(color: Styles.errorColor),
              enabledBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(153, 255, 255, 255))),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Styles.lightTextColor),
              ),
            ),
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return Translations.getString('mainApp', 'fieldRequired');
              }
              return null;
            },
            controller: _hostControllers));
  }

  Widget widgetProtocolHost() {
    return Padding(
        padding: const EdgeInsets.only(top: Styles.medium),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Protocol
            widgetProtocol(),
            const SizedBox(
              width: 5.0,
            ),
            //Host
            widgetHost()
          ],
        ));
  }

  Widget widgetDatabases() {
    return Padding(
        padding: const EdgeInsets.only(top: Styles.medium),
        child: DropdownSearch<String>(
            mode: Mode.BOTTOM_SHEET,
            items: _databases,
            selectedItem: _database,
            focusNode: _dbsNode,
            dropdownButtonProps: const IconButtonProps(
                icon: Icon(
              Icons.arrow_drop_down,
              color: Color.fromARGB(153, 255, 255, 255),
            )),
            dropdownSearchDecoration: InputDecoration(
              label: Text(
                Translations.getString('mainApp', 'databases'),
                style: const TextStyle(
                    fontSize: Styles.f18,
                    color: Color.fromARGB(153, 255, 255, 255),
                    fontWeight: Styles.lightFontWeight),
              ),
              errorStyle: const TextStyle(color: Styles.errorColor),
              enabledBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(153, 255, 255, 255))),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Styles.lightTextColor),
              ),
            ),
            dropdownBuilder: (BuildContext context, String? item) {
              return Text(
                item ?? '',
                style: const TextStyle(
                    color: Styles.lightTextColor,
                    fontSize: Styles.f18,
                    fontWeight: Styles.lightFontWeight),
              );
            },
            popupItemBuilder:
                (BuildContext context, String item, bool isSelected) {
              isSelected = _database == item;
              return Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: Styles.small, vertical: Styles.small),
                decoration: BoxDecoration(
                    border: Border.all(color: Styles.primaryColor),
                    borderRadius: BorderRadius.circular(Styles.small),
                    color: isSelected
                        ? Styles.backGroundColor
                        : Styles.transparentColor),
                child: ListTile(
                  title: Text(item.toString(),
                      style: const TextStyle(
                          fontSize: Styles.f18,
                          color: Styles.primaryColor,
                          fontWeight: Styles.lightFontWeight)),
                  trailing: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Styles.primaryColor,
                        )
                      : null,
                ),
              );
            },
            validator: (String? val) {
              if (val == null || val.isEmpty) {
                return Translations.getString('mainApp', 'fieldRequired');
              }
              return null;
            },
            onChanged: (String? val) {
              _database = val!;
              setState(() {});
            }));
  }

  Widget widgetUsername() {
    return Padding(
        padding: const EdgeInsets.only(top: Styles.xlarge),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.lightTextColor,
              fontSize: Styles.f18,
              fontWeight: Styles.lightFontWeight),
          focusNode: _usernameNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (val) {
            _usernameNode.unfocus();
            FocusScope.of(context).requestFocus(_passwordNode);
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            label: Text(
              Translations.getString('mainApp', 'usernameOrEmail'),
              style: const TextStyle(
                  fontSize: Styles.f18,
                  color: Color.fromARGB(153, 255, 255, 255),
                  fontWeight: Styles.lightFontWeight),
            ),
            errorStyle: const TextStyle(color: Styles.errorColor),
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Color.fromARGB(153, 255, 255, 255))),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Styles.lightTextColor),
            ),
          ),
          validator: (String? val) {
            if (val == null || val.isEmpty) {
              return Translations.getString('mainApp', 'fieldRequired');
            }
            return null;
          },
          controller: _usernameController,
        ));
  }

  Widget widgetPassword() {
    return Padding(
        padding: const EdgeInsets.only(top: Styles.xlarge),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.lightTextColor,
              fontSize: Styles.f18,
              fontWeight: Styles.lightFontWeight),
          focusNode: _passwordNode,
          textInputAction: TextInputAction.done,
          obscureText: !_isShowPass,
          decoration: InputDecoration(
              label: Text(
                Translations.getString('mainApp', 'password'),
                style: const TextStyle(
                    fontSize: Styles.f18,
                    color: Color.fromARGB(153, 255, 255, 255),
                    fontWeight: Styles.lightFontWeight),
              ),
              errorStyle: const TextStyle(color: Styles.errorColor),
              enabledBorder: const UnderlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(153, 255, 255, 255))),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Styles.lightTextColor),
              ),
              suffixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: IconButton(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        _isShowPass = !_isShowPass;
                        setState(() {});
                      },
                      icon: Icon(
                        _isShowPass
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color.fromARGB(153, 255, 255, 255),
                        size: 24,
                      )))),
          validator: (String? val) {
            if (val == null || val.isEmpty) {
              return Translations.getString('mainApp', 'fieldRequired');
            }
            return null;
          },
          controller: _passwordController,
          onFieldSubmitted: (String? val) {
            loginAction();
          },
        ));
  }

  Widget widgetBtnLogin() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.2),
                blurRadius: 8.0,
                offset: Offset(0, 4))
          ]),
      height: 56.0,
      child: Material(
        color: Styles.transparentColor,
        child: InkWell(
          onTap: () async {
            HapticFeedback.heavyImpact();
            await loginAction();
          },
          child: Center(
              child: Text(Translations.getString('mainApp', 'login'),
                  style: const TextStyle(
                      color: Styles.primaryColor,
                      fontSize: Styles.f18,
                      fontWeight: Styles.mediumFontWeight))),
        ),
      ),
    );
  }

  Widget widgetForgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Styles.small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(Translations.getString('mainApp', 'forgotPassword'),
              style: const TextStyle(
                  color: Styles.lightTextColor,
                  fontSize: Styles.f12,
                  fontWeight: Styles.lightFontWeight)),
          const SizedBox(width: Styles.small),
          InkWell(
            child: Text(Translations.getString('mainApp', 'getNew'),
                style: const TextStyle(
                    color: Styles.lightTextColor,
                    fontWeight: Styles.mediumFontWeight,
                    fontSize: Styles.f12)),
            onTap: () {
              HapticFeedback.heavyImpact();
            },
          ),
        ],
      ),
    );
  }

  Widget widgetRegister() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Styles.small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(Translations.getString('mainApp', 'haveNotAcount'),
              style: const TextStyle(
                  color: Styles.lightTextColor,
                  fontSize: Styles.f12,
                  fontWeight: Styles.lightFontWeight)),
          const SizedBox(width: Styles.small),
          InkWell(
            child: Text(Translations.getString('mainApp', 'signUp'),
                style: const TextStyle(
                    color: Styles.lightTextColor,
                    fontWeight: Styles.mediumFontWeight,
                    fontSize: Styles.f12)),
            onTap: () {
              HapticFeedback.heavyImpact();
              Navigator.push(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          RegisterPage(
                              namePage: NamePage.registerPage,
                              protocol: _protocol,
                              host: _hostControllers.text,
                              dbName: _database)));
            },
          ),
        ],
      ),
    );
  }

  Widget widgetChangeServer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Styles.small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(Translations.getString('mainApp', 'changUrl'),
              style: const TextStyle(
                  color: Styles.lightTextColor,
                  fontSize: Styles.f12,
                  fontWeight: Styles.lightFontWeight)),
          const SizedBox(width: Styles.small),
          InkWell(
            child: Text(Translations.getString('mainApp', 'clickMe'),
                style: const TextStyle(
                    color: Styles.lightTextColor,
                    fontWeight: Styles.mediumFontWeight,
                    fontSize: Styles.f12)),
            onTap: () async {
              HapticFeedback.heavyImpact();
              await Sessions.clearChangeServer();
              Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Routes.splashPage),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: hideKeyboard,
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
            body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(gradient: Styles.gradient),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Styles.xxlarge, vertical: Styles.xxlarge),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top,
                            bottom: Styles.xlarge),
                        child: Text(
                            Translations.getString('mainApp', 'welcome'),
                            style: const TextStyle(
                                color: Styles.lightTextColor,
                                fontSize: Styles.f36,
                                fontWeight: Styles.lightFontWeight)),
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              //Protocol & Host
                              if (_isChangeServer) widgetProtocolHost(),
                              //Databases
                              if (_isChangeServer && _databases.isNotEmpty)
                                widgetDatabases(),
                              //Username or Email
                              widgetUsername(),
                              //Password
                              widgetPassword(),
                              const SizedBox(height: 50.0),
                              //Login btn
                              widgetBtnLogin(),
                              const SizedBox(height: 40.0),
                              Column(
                                children: <Widget>[
                                  // widgetForgotPassword(),
                                  widgetRegister(),
                                  widgetChangeServer()
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading) Tools.loading()
          ],
        )));
  }
}

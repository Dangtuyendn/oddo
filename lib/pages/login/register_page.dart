import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/config.dart';
import '../../common/sessions.dart';
import '../../common/styles.dart';
import '../../common/tools.dart';
import '../../common/translations.dart';
import '../../common/utils.dart';
import '../../controllers/odoo_controller.dart';
import '../../routes/routes.dart';

class RegisterPage extends StatefulWidget {
  final String namePage;
  final String? protocol;
  final String? host;
  final String? dbName;
  const RegisterPage(
      {Key? key, required this.namePage, this.protocol, this.host, this.dbName})
      : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _rePasswordController = TextEditingController();

  final _nameNode = FocusNode();
  final _emailNode = FocusNode();
  final _mobileNode = FocusNode();
  final _passwordNode = FocusNode();
  final _rePasswordNode = FocusNode();

  bool _isShowPass = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final loginOK = await OdooController().authenticate(
            AppConfig.userBot, AppConfig.passBot, widget.dbName ?? '');
        printLog(loginOK);
      } catch (e, trace) {
        printLog(e.toString());
        printLog(trace.toString());
        Tools.showSnackBar(context, false,
            Translations.getString('mainApp', 'cannotRegister'));
        Navigator.of(context).pop();
      }

      hideLoading();
    });
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _mobileNode.dispose();
    _passwordController.dispose();
    _rePasswordController.dispose();

    _nameNode.dispose();
    _emailNode.dispose();
    _passwordNode.dispose();
    _rePasswordNode.dispose();
  }

  void showLoading() {
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

  Widget widgetName() {
    return Padding(
        padding: const EdgeInsets.only(top: Styles.xlarge),
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(
              color: Styles.lightTextColor,
              fontSize: Styles.f18,
              fontWeight: Styles.lightFontWeight),
          focusNode: _nameNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (val) {
            _nameNode.unfocus();
            FocusScope.of(context).requestFocus(_emailNode);
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            label: Text(
              '${Translations.getString('mainApp', 'fullname')} *',
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
          controller: _nameController,
        ));
  }

  Widget widgetEmail() {
    return Padding(
        padding: const EdgeInsets.only(top: Styles.xlarge),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.lightTextColor,
              fontSize: Styles.f18,
              fontWeight: Styles.lightFontWeight),
          focusNode: _emailNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (val) {
            _emailNode.unfocus();
            FocusScope.of(context).requestFocus(_mobileNode);
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            label: Text(
              '${Translations.getString('mainApp', 'usernameOrEmail')} *',
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
          controller: _emailController,
        ));
  }

  Widget widgetMobile() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.medium),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.lightTextColor,
              fontSize: Styles.f18,
              fontWeight: Styles.lightFontWeight),
          focusNode: _mobileNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (String? val) {
            _mobileNode.unfocus();
            FocusScope.of(context).requestFocus(_passwordNode);
          },
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            label: Text(
              Translations.getString('mainApp', 'mobile'),
              style: const TextStyle(
                  fontSize: Styles.f18,
                  color: Color.fromARGB(153, 255, 255, 255),
                  fontWeight: Styles.lightFontWeight),
            ),
            errorStyle: const TextStyle(color: Styles.errorColor),
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Styles.underlineInputBorderColor)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Styles.lightTextColor),
            ),
          ),
          validator: (String? val) {
            return null;
          },
          controller: _mobileController,
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
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (String? val) async {
              _passwordNode.unfocus();
              FocusScope.of(context).requestFocus(_rePasswordNode);
            },
            obscureText: !_isShowPass,
            decoration: InputDecoration(
                label: Text(
                  '${Translations.getString('mainApp', 'password')} *',
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
            controller: _passwordController));
  }

  Widget widgetRePassword() {
    return Padding(
        padding: const EdgeInsets.only(top: Styles.xlarge),
        child: TextFormField(
            style: const TextStyle(
                color: Styles.lightTextColor,
                fontSize: Styles.f18,
                fontWeight: Styles.lightFontWeight),
            focusNode: _rePasswordNode,
            textInputAction: TextInputAction.done,
            obscureText: !_isShowPass,
            decoration: InputDecoration(
                label: Text(
                  '${Translations.getString('mainApp', 'rePassword')} *',
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

              if (val != _passwordController.text) {
                return Translations.getString('mainApp', 'passwordNotMatch');
              }
              return null;
            },
            controller: _rePasswordController,
            onFieldSubmitted: (String? val) async {
              await registerAction();
            }));
  }

  Widget widgetBtnRegister() {
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
            await registerAction();
          },
          child: Center(
              child: Text(Translations.getString('mainApp', 'register'),
                  style: const TextStyle(
                      color: Styles.primaryColor,
                      fontSize: Styles.f18,
                      fontWeight: Styles.mediumFontWeight))),
        ),
      ),
    );
  }

  Widget widgetLogin() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Styles.small),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(Translations.getString('mainApp', 'haveAcount'),
              style: const TextStyle(
                  color: Styles.lightTextColor,
                  fontSize: Styles.f12,
                  fontWeight: Styles.lightFontWeight)),
          const SizedBox(width: Styles.small),
          InkWell(
            child: Text(Translations.getString('mainApp', 'login'),
                style: const TextStyle(
                    color: Styles.lightTextColor,
                    fontWeight: Styles.mediumFontWeight,
                    fontSize: Styles.f12)),
            onTap: () {
              HapticFeedback.heavyImpact();
              Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Routes.loginPage),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }

  Future registerAction() async {
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
        await OdooController().register({
          'name': _nameController.text,
          'email': _emailController.text,
          'mobile': _mobileController.text,
          'login': _emailController.text,
          'password': _passwordController.text,
          'lang': 'vi_VN'
        });
        await Sessions.setUsername(_emailController.text);
        Tools.showSnackBar(context, true,
            Translations.getString('mainApp', 'registerSuccess'));
        Navigator.pushReplacement(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    Routes.loginPage));
      } catch (e, trace) {
        printLog(e.toString());
        printLog(trace.toString());
        Tools.showSnackBar(context, false, e.toString());
      }
      hideLoading();
    }
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
                            Translations.getString(
                                'mainApp', 'registerWelcome'),
                            style: const TextStyle(
                                color: Styles.lightTextColor,
                                fontSize: Styles.f36,
                                fontWeight: Styles.lightFontWeight)),
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              widgetName(),
                              widgetEmail(),
                              widgetMobile(),
                              widgetPassword(),
                              widgetRePassword(),
                              const SizedBox(height: 50.0),
                              widgetBtnRegister(),
                              const SizedBox(height: 40.0),
                              Column(
                                children: <Widget>[
                                  widgetLogin(),
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

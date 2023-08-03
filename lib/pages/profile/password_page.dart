import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/odoo_controller.dart';
import '../../common/sessions.dart';
import '../../common/styles.dart';
import '../../common/tools.dart';
import '../../common/translations.dart';
import '../../common/utils.dart';
import '../../models/userinfo_model.dart';
import '../../routes/routes.dart';
import '../../views/main_view.dart';

class PasswordPage extends StatefulWidget {
  final String namePage;
  const PasswordPage({Key? key, required this.namePage}) : super(key: key);

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordNode = FocusNode();
  final _newPasswordNode = FocusNode();
  final _confirmPasswordNode = FocusNode();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  UserInfoModel? _userInfoModel;
  String? _odooSession;
  bool _isShowCurrentPass = false;
  bool _isShowNewPass = false;
  bool _isShowConfirmPass = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _odooSession = await Sessions.getSession();
      _userInfoModel = await Sessions.getUserInfo();

      hideLoading();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _currentPasswordNode.dispose();
    _newPasswordNode.dispose();
    _confirmPasswordNode.dispose();

    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
  }

  void showLoading() {
    _isLoading = true;
    setState(() {});
  }

  void hideLoading() {
    _isLoading = false;
    setState(() {});
  }

  Future actionSave() async {
    if (_isLoading) {
      Tools.showSnackBar(
          context, false, Translations.getString('mainApp', 'pleaseWait'));
      return;
    }

    Tools.hideKeyboard(context);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showLoading();
      try {
        await OdooController().changePassword({
          'curent_pass': _currentPasswordController.text,
          'new_pass': _newPasswordController.text
        });

        Tools.showSnackBar(context, true,
            Translations.getString('mainApp', 'changePassSuccess'));
        Sessions.clearLogout();
        Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    Routes.loginPage),
            (Route<dynamic> route) => false);
      } catch (e, trace) {
        printLog(e.toString());
        printLog(trace.toString());
        Tools.showSnackBar(context, false, e.toString());
        Tools.checkSessionExpired(context, e.toString());
      }
      hideLoading();
    }
  }

  Widget widgetCurrentPassword() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.medium),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.darkTextColor,
              fontSize: Styles.f16,
              fontWeight: Styles.lightFontWeight),
          focusNode: _currentPasswordNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (String? val) {
            _currentPasswordNode.unfocus();
            FocusScope.of(context).requestFocus(_newPasswordNode);
          },
          obscureText: !_isShowCurrentPass,
          decoration: InputDecoration(
              label: Text(
                Translations.getString('mainApp', 'currentPassword'),
                style: const TextStyle(
                    fontSize: Styles.f16,
                    color: Styles.primaryColor,
                    fontWeight: Styles.lightFontWeight),
              ),
              errorStyle: const TextStyle(color: Styles.errorColor),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Styles.darkTextColor)),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Styles.primaryColor),
              ),
              suffixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: IconButton(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        _isShowCurrentPass = !_isShowCurrentPass;
                        setState(() {});
                      },
                      icon: Icon(
                        _isShowCurrentPass
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Styles.primaryColor,
                        size: 24,
                      )))),
          validator: (String? val) {
            if (val == null || val.isEmpty) {
              return Translations.getString('mainApp', 'fieldRequired');
            }
            return null;
          },
          controller: _currentPasswordController,
        ));
  }

  Widget widgetNewPassword() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.medium),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.darkTextColor,
              fontSize: Styles.f16,
              fontWeight: Styles.lightFontWeight),
          focusNode: _newPasswordNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (String? val) {
            _newPasswordNode.unfocus();
            FocusScope.of(context).requestFocus(_confirmPasswordNode);
          },
          obscureText: !_isShowNewPass,
          decoration: InputDecoration(
              label: Text(
                Translations.getString('mainApp', 'newPassword'),
                style: const TextStyle(
                    fontSize: Styles.f16,
                    color: Styles.primaryColor,
                    fontWeight: Styles.lightFontWeight),
              ),
              errorStyle: const TextStyle(color: Styles.errorColor),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Styles.darkTextColor)),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Styles.primaryColor),
              ),
              suffixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: IconButton(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        _isShowNewPass = !_isShowNewPass;
                        setState(() {});
                      },
                      icon: Icon(
                        _isShowNewPass
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Styles.primaryColor,
                        size: 24,
                      )))),
          validator: (String? val) {
            if (val == null || val.isEmpty) {
              return Translations.getString('mainApp', 'fieldRequired');
            }

            return null;
          },
          controller: _newPasswordController,
        ));
  }

  Widget widgetConfirmPassword() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.medium),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.darkTextColor,
              fontSize: Styles.f16,
              fontWeight: Styles.lightFontWeight),
          focusNode: _confirmPasswordNode,
          textInputAction: TextInputAction.done,
          obscureText: !_isShowConfirmPass,
          decoration: InputDecoration(
              label: Text(
                Translations.getString('mainApp', 'confirmPassword'),
                style: const TextStyle(
                    fontSize: Styles.f16,
                    color: Styles.primaryColor,
                    fontWeight: Styles.lightFontWeight),
              ),
              errorStyle: const TextStyle(color: Styles.errorColor),
              enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Styles.darkTextColor)),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Styles.primaryColor),
              ),
              suffixIcon: Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: IconButton(
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        _isShowConfirmPass = !_isShowConfirmPass;
                        setState(() {});
                      },
                      icon: Icon(
                        _isShowConfirmPass
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Styles.primaryColor,
                        size: 24,
                      )))),
          validator: (String? val) {
            if (val == null || val.isEmpty) {
              return Translations.getString('mainApp', 'fieldRequired');
            }
            if (val != _newPasswordController.text) {
              return Translations.getString(
                  'mainApp', 'confirmPasswordNotMatch');
            }
            return null;
          },
          controller: _confirmPasswordController,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
        namePage: widget.namePage,
        userInfoModel: _userInfoModel,
        odooSession: _odooSession,
        title: Translations.getString('mainApp', 'titlePassword'),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              widgetCurrentPassword(),
              widgetNewPassword(),
              widgetConfirmPassword(),
              const SizedBox(height: 85.0)
            ]))),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            HapticFeedback.heavyImpact();
            await actionSave();
          },
          child: const Icon(Icons.save),
        ),
        onLoading: () {
          return _isLoading;
        });
  }
}

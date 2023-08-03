import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import '../../common/sessions.dart';
import '../../common/utils.dart';
import '../../models/userinfo_model.dart';
import '../../views/main_view.dart';
import '../../common/styles.dart';
import '../../common/tools.dart';
import '../../common/translations.dart';
import '../../controllers/odoo_controller.dart';

class ProfilePage extends StatefulWidget {
  final String namePage;
  const ProfilePage({Key? key, required this.namePage}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameNode = FocusNode();
  final _functionNode = FocusNode();
  final _mobileNode = FocusNode();
  final _phoneNode = FocusNode();
  final _emailNode = FocusNode();
  final _vatNode = FocusNode();
  final _streetNode = FocusNode();
  final _street2Node = FocusNode();
  final _cityNode = FocusNode();
  final _zipNode = FocusNode();

  final _nameController = TextEditingController();
  final _functionController = TextEditingController();
  final _mobileController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _vatController = TextEditingController();
  final _streetController = TextEditingController();
  final _street2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();

  ImageProvider<Object> _imageProvider = const AssetImage(
    'assets/avatars/user_icon.png',
  );
  UserInfoModel? _userInfoModel;
  String? _odooSession;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _odooSession = await Sessions.getSession();
      _userInfoModel = await Sessions.getUserInfo();

      _nameController.text = _userInfoModel?.name ?? '';
      _functionController.text = _userInfoModel?.function ?? '';
      _mobileController.text = _userInfoModel?.mobile ?? '';
      _phoneController.text = _userInfoModel?.phone ?? '';
      _emailController.text = _userInfoModel?.email ?? '';
      _vatController.text = _userInfoModel?.vat ?? '';
      _streetController.text = _userInfoModel?.street ?? '';
      _street2Controller.text = _userInfoModel?.street2 ?? '';
      _cityController.text = _userInfoModel?.city ?? '';
      _zipController.text = _userInfoModel?.zip ?? '';

      _imageProvider = NetworkImage(_userInfoModel?.image ?? '',
          headers: {'Cookie': _odooSession ?? ''});

      hideLoading();
    });
  }

  @override
  void dispose() {
    super.dispose();

    _nameNode.dispose();
    _functionNode.dispose();
    _mobileNode.dispose();
    _phoneNode.dispose();
    _emailNode.dispose();
    _vatNode.dispose();
    _streetNode.dispose();
    _street2Node.dispose();
    _cityNode.dispose();
    _zipNode.dispose();

    _nameController.dispose();
    _functionController.dispose();
    _mobileController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _vatController.dispose();
    _streetController.dispose();
    _street2Controller.dispose();
    _cityController.dispose();
    _zipController.dispose();
  }

  void showLoading() {
    _isLoading = true;
    setState(() {});
  }

  void hideLoading() {
    _isLoading = false;
    setState(() {});
  }

  void takePhotoAction(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: source,
    );
    final imageBytes = await pickedFile!.readAsBytes();

    _imageProvider = MemoryImage(imageBytes);
    setState(() {});

    Navigator.pop(context);
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
        var data = {
          'image': _imageProvider.runtimeType == MemoryImage
              ? convert.base64Encode((_imageProvider as MemoryImage).bytes)
              : false,
          'name': _nameController.text,
          'function': _functionController.text,
          'mobile': _mobileController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'street': _streetController.text,
          'street2': _street2Controller.text,
          'city': _cityController.text,
          'zip': _zipController.text,
          'vat': _vatController.text
        };
        final saveOK = await OdooController()
            .write('res.partner', [_userInfoModel!.id!], data);
        if (saveOK) {
          _userInfoModel?.name = _nameController.text;
          _userInfoModel?.function = _functionController.text;
          _userInfoModel?.mobile = _mobileController.text;
          _userInfoModel?.phone = _phoneController.text;
          _userInfoModel?.email = _emailController.text;
          _userInfoModel?.street = _streetController.text;
          _userInfoModel?.street2 = _street2Controller.text;
          _userInfoModel?.city = _cityController.text;
          _userInfoModel?.zip = _zipController.text;
          _userInfoModel?.vat = _vatController.text;
          await Sessions.setUserInfo(_userInfoModel!);
          Tools.showSnackBar(context, true,
              Translations.getString('mainApp', 'updateSuccess'));
        } else {
          Tools.showSnackBar(
              context, false, Translations.getString('mainApp', 'updateFail'));
        }
      } catch (e, trace) {
        printLog(e.toString());
        printLog(trace.toString());
        Tools.showSnackBar(context, false, e.toString());
        Tools.checkSessionExpired(context, e.toString());
      }
      hideLoading();
    }
  }

  Widget widgetImageName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        Stack(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(7.0),
                child: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      showModalBottomSheet<Map>(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return PhotoView(imageProvider: _imageProvider);
                          });
                    },
                    child: FadeInImage(
                        key: UniqueKey(),
                        image: _imageProvider,
                        fadeInDuration: const Duration(milliseconds: 150),
                        fit: BoxFit.fill,
                        width: 100.0,
                        height: 100.0,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/avatars/user_icon.png',
                            width: 100.0,
                            height: 100.0,
                          );
                        },
                        placeholder: const AssetImage(
                          'assets/avatars/user_icon.png',
                        )))),
            Positioned(
                bottom: 1,
                right: 1,
                child: GestureDetector(
                    onTap: () {
                      HapticFeedback.heavyImpact();
                      showModalBottomSheet(
                          context: context,
                          builder: ((builder) {
                            return Container(
                              height: 100.0,
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: Column(
                                children: <Widget>[
                                  const Text(
                                    'Choose photo',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        TextButton.icon(
                                          onPressed: () {
                                            HapticFeedback.heavyImpact();
                                            takePhotoAction(ImageSource.camera);
                                          },
                                          icon: const Icon(Icons.camera),
                                          label: const Text('Camera'),
                                        ),
                                        TextButton.icon(
                                          onPressed: () {
                                            HapticFeedback.heavyImpact();
                                            takePhotoAction(
                                                ImageSource.gallery);
                                          },
                                          icon: const Icon(Icons.image),
                                          label: const Text('Gallery'),
                                        ),
                                      ])
                                ],
                              ),
                            );
                          }));
                    },
                    child: const Icon(Icons.camera_alt,
                        color: Styles.darkTextColor)))
          ],
        ),
        const SizedBox(width: 16.0),
        Expanded(
            child: TextFormField(
          style: const TextStyle(
              color: Styles.darkTextColor,
              fontSize: Styles.f16,
              fontWeight: Styles.lightFontWeight),
          focusNode: _nameNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (String? val) {
            _nameNode.unfocus();
            FocusScope.of(context).requestFocus(_functionNode);
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            label: Text(
              Translations.getString('mainApp', 'name'),
              style: const TextStyle(
                  fontSize: Styles.f16,
                  color: Styles.primaryColor,
                  fontWeight: Styles.lightFontWeight),
            ),
            errorStyle: const TextStyle(color: Styles.errorColor),
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Styles.underlineInputBorderColor)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Styles.primaryColor),
            ),
          ),
          validator: (String? val) {
            if (val == null || val.isEmpty) {
              return Translations.getString('mainApp', 'fieldRequired');
            }
            return null;
          },
          controller: _nameController,
        ))
      ]),
    );
  }

  Widget widgetFunction() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.medium),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.darkTextColor,
              fontSize: Styles.f16,
              fontWeight: Styles.lightFontWeight),
          focusNode: _functionNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (String? val) {
            _functionNode.unfocus();
            FocusScope.of(context).requestFocus(_mobileNode);
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            label: Text(
              Translations.getString('mainApp', 'function'),
              style: const TextStyle(
                  fontSize: Styles.f16,
                  color: Styles.primaryColor,
                  fontWeight: Styles.lightFontWeight),
            ),
            errorStyle: const TextStyle(color: Styles.errorColor),
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Styles.underlineInputBorderColor)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Styles.primaryColor),
            ),
          ),
          validator: (String? val) {
            return null;
          },
          controller: _functionController,
        ));
  }

  Widget widgetMobile() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.medium),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.darkTextColor,
              fontSize: Styles.f16,
              fontWeight: Styles.lightFontWeight),
          focusNode: _mobileNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (String? val) {
            _mobileNode.unfocus();
            FocusScope.of(context).requestFocus(_phoneNode);
          },
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            label: Text(
              Translations.getString('mainApp', 'mobile'),
              style: const TextStyle(
                  fontSize: Styles.f16,
                  color: Styles.primaryColor,
                  fontWeight: Styles.lightFontWeight),
            ),
            errorStyle: const TextStyle(color: Styles.errorColor),
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Styles.underlineInputBorderColor)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Styles.primaryColor),
            ),
          ),
          validator: (String? val) {
            return null;
          },
          controller: _mobileController,
        ));
  }

  Widget widgetPhone() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.medium),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.darkTextColor,
              fontSize: Styles.f16,
              fontWeight: Styles.lightFontWeight),
          focusNode: _phoneNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (String? val) {
            _phoneNode.unfocus();
            FocusScope.of(context).requestFocus(_vatNode);
          },
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            label: Text(
              Translations.getString('mainApp', 'phone'),
              style: const TextStyle(
                  fontSize: Styles.f16,
                  color: Styles.primaryColor,
                  fontWeight: Styles.lightFontWeight),
            ),
            errorStyle: const TextStyle(color: Styles.errorColor),
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Styles.underlineInputBorderColor)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Styles.primaryColor),
            ),
          ),
          validator: (String? val) {
            return null;
          },
          controller: _phoneController,
        ));
  }

  Widget widgetEmail() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.medium),
        child: TextFormField(
          enabled: false,
          style: const TextStyle(
              color: Styles.darkTextColor,
              fontSize: Styles.f16,
              fontWeight: Styles.lightFontWeight),
          focusNode: _emailNode,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            label: Text(
              Translations.getString('mainApp', 'email'),
              style: const TextStyle(
                  fontSize: Styles.f16,
                  color: Styles.primaryColor,
                  fontWeight: Styles.lightFontWeight),
            ),
            errorStyle: const TextStyle(color: Styles.errorColor),
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Styles.underlineInputBorderColor)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Styles.primaryColor),
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

  Widget widgetVat() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.medium),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.darkTextColor,
              fontSize: Styles.f16,
              fontWeight: Styles.lightFontWeight),
          focusNode: _vatNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (String? val) {
            _vatNode.unfocus();
            FocusScope.of(context).requestFocus(_streetNode);
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            label: Text(
              Translations.getString('mainApp', 'vat'),
              style: const TextStyle(
                  fontSize: Styles.f16,
                  color: Styles.primaryColor,
                  fontWeight: Styles.lightFontWeight),
            ),
            errorStyle: const TextStyle(color: Styles.errorColor),
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Styles.underlineInputBorderColor)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Styles.primaryColor),
            ),
          ),
          validator: (String? val) {
            return null;
          },
          controller: _vatController,
        ));
  }

  Widget widgetStreet() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.medium),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.darkTextColor,
              fontSize: Styles.f16,
              fontWeight: Styles.lightFontWeight),
          focusNode: _streetNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (String? val) {
            _streetNode.unfocus();
            FocusScope.of(context).requestFocus(_street2Node);
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            label: Text(
              Translations.getString('mainApp', 'street'),
              style: const TextStyle(
                  fontSize: Styles.f16,
                  color: Styles.primaryColor,
                  fontWeight: Styles.lightFontWeight),
            ),
            errorStyle: const TextStyle(color: Styles.errorColor),
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Styles.underlineInputBorderColor)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Styles.primaryColor),
            ),
          ),
          validator: (String? val) {
            return null;
          },
          controller: _streetController,
        ));
  }

  Widget widgetStreet2() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.medium),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.darkTextColor,
              fontSize: Styles.f16,
              fontWeight: Styles.lightFontWeight),
          focusNode: _street2Node,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (String? val) {
            _street2Node.unfocus();
            FocusScope.of(context).requestFocus(_cityNode);
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            label: Text(
              Translations.getString('mainApp', 'street2'),
              style: const TextStyle(
                  fontSize: Styles.f16,
                  color: Styles.primaryColor,
                  fontWeight: Styles.lightFontWeight),
            ),
            errorStyle: const TextStyle(color: Styles.errorColor),
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Styles.underlineInputBorderColor)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Styles.primaryColor),
            ),
          ),
          validator: (String? val) {
            return null;
          },
          controller: _street2Controller,
        ));
  }

  Widget widgetCity() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.medium),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.darkTextColor,
              fontSize: Styles.f16,
              fontWeight: Styles.lightFontWeight),
          focusNode: _cityNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (String? val) {
            _cityNode.unfocus();
            FocusScope.of(context).requestFocus(_zipNode);
          },
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            label: Text(
              Translations.getString('mainApp', 'city'),
              style: const TextStyle(
                  fontSize: Styles.f16,
                  color: Styles.primaryColor,
                  fontWeight: Styles.lightFontWeight),
            ),
            errorStyle: const TextStyle(color: Styles.errorColor),
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Styles.underlineInputBorderColor)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Styles.primaryColor),
            ),
          ),
          validator: (String? val) {
            return null;
          },
          controller: _cityController,
        ));
  }

  Widget widgetZip() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: Styles.medium),
        child: TextFormField(
          style: const TextStyle(
              color: Styles.darkTextColor,
              fontSize: Styles.f16,
              fontWeight: Styles.lightFontWeight),
          focusNode: _zipNode,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            label: Text(
              Translations.getString('mainApp', 'zip'),
              style: const TextStyle(
                  fontSize: Styles.f16,
                  color: Styles.primaryColor,
                  fontWeight: Styles.lightFontWeight),
            ),
            errorStyle: const TextStyle(color: Styles.errorColor),
            enabledBorder: const UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Styles.underlineInputBorderColor)),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Styles.primaryColor),
            ),
          ),
          validator: (String? val) {
            return null;
          },
          controller: _zipController,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MainView(
        namePage: widget.namePage,
        userInfoModel: _userInfoModel,
        odooSession: _odooSession,
        title: Translations.getString('mainApp', 'titleProfile'),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              widgetImageName(),
              widgetFunction(),
              widgetMobile(),
              widgetPhone(),
              widgetEmail(),
              widgetVat(),
              widgetStreet(),
              widgetStreet2(),
              widgetCity(),
              widgetZip(),
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

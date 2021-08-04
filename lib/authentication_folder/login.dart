import 'package:ff_user/shared_folder/_buttons/default_button.dart';
import 'package:ff_user/shared_folder/_buttons/keyboard.dart';
import 'package:ff_user/shared_folder/_buttons/trans_button.dart';
import 'package:ff_user/shared_folder/_constants/FadeAnimation.dart';
import 'package:ff_user/shared_folder/_constants/constants.dart';
import 'package:ff_user/shared_folder/_constants/custom_surfix_icon.dart';
import 'package:ff_user/shared_folder/_constants/form_error.dart';
import 'package:ff_user/shared_folder/_constants/progressDialog.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/wrapper_folder/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _phonecontroller = TextEditingController();
  final _codeController = TextEditingController();
  String _start = '+63';

  bool remember = false;
  final List<String> errors = [];

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.1),
                  FadeAnimation(
                      2,
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: getProportionateScreenWidth(28),
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                  FadeAnimation(
                      2,
                      Text(
                        "Sign in with your email and password  \nor continue with social media",
                        textAlign: TextAlign.center,
                      )),
                  SizedBox(height: SizeConfig.screenHeight * 0.12),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FadeAnimation(2.2, buildPhoneNumberFormField()),
                        SizedBox(height: getProportionateScreenHeight(50)),
                        FormError(errors: errors),
                        SizedBox(height: getProportionateScreenHeight(50)),
                        FadeAnimation(
                            2.5,
                            DefaultButton(
                              text: "Continue",
                              color: Colors.blue[400],
                              press: () async {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  KeyboardUtil.hideKeyboard(context);
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) =>
                                          ProgressDialog(
                                              status: 'Please Wait...'));

                                  final phone = _phonecontroller.text.trim();
                                  await verifyNumber(_start + phone);
                                }
                              },
                            )),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        FadeAnimation(
                            2.6,
                            TransparentButton(
                              text: "Cancel",
                              press: () {
                                KeyboardUtil.hideKeyboard(context);
                                Navigator.of(context)
                                    .pushReplacementNamed('/getstarted');
                              },
                            ))
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: _phonecontroller,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty || value.length != 10) {
          addError(error: kPhoneNumberNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone Number",
        hintText: "9XXXXXXXXX",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  Future verifyNumber(String phone) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    final PhoneVerificationCompleted vrifyCompleted =
        (AuthCredential credential) async {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) =>
              ProgressDialog(status: 'Please Wait...'));
      AuthResult result = await _auth.signInWithCredential(credential);
      FirebaseUser user = result.user;
      if (user != null) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Wrapper()));
      } else {
        Navigator.of(context).pop();
        return null;
      }
    };

    final PhoneVerificationFailed verifailed = (AuthException exception) {
      print(exception.message);
    };

    final PhoneCodeSent codeSent =
        (String verificationid, [int forceResendingtoken]) {
      Navigator.of(context).pop();
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Enter Code:'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _codeController,
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Submit'),
                  style: TextButton.styleFrom(primary: Colors.blue),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) =>
                            ProgressDialog(status: 'Please Wait...'));
                    AuthCredential credential = PhoneAuthProvider.getCredential(
                        verificationId: verificationid,
                        smsCode: _codeController.text);
                    AuthResult result =
                        await _auth.signInWithCredential(credential);
                    FirebaseUser user = result.user;

                    if (user != null) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Wrapper()));
                    } else {
                      Navigator.of(context).pop();
                      return null;
                    }
                  },
                )
              ],
            );
          });
    };

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: vrifyCompleted,
        verificationFailed: verifailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: null);
  }
}

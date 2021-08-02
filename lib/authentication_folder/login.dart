import 'package:ff_user/shared_folder/_buttons/default_button.dart';
import 'package:ff_user/shared_folder/_buttons/keyboard.dart';
import 'package:ff_user/shared_folder/_buttons/trans_button.dart';
import 'package:ff_user/shared_folder/_constants/FadeAnimation.dart';
import 'package:ff_user/shared_folder/_constants/constants.dart';
import 'package:ff_user/shared_folder/_constants/custom_surfix_icon.dart';
import 'package:ff_user/shared_folder/_constants/form_error.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String phone;

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
                              press: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  KeyboardUtil.hideKeyboard(context);
                                  Navigator.of(context)
                                      .pushReplacementNamed('/signup');
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
      onSaved: (newValue) => phone = newValue,
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
}

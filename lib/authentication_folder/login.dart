import 'package:ff_user/shared_folder/_buttons/default_button.dart';
import 'package:ff_user/shared_folder/_buttons/keyboard.dart';
import 'package:ff_user/shared_folder/_constants/FadeAnimation.dart';
import 'package:ff_user/shared_folder/_constants/constants.dart';
import 'package:ff_user/shared_folder/_constants/custom_surfix_icon.dart';
import 'package:ff_user/shared_folder/_constants/form_error.dart';
import 'package:ff_user/shared_folder/_constants/no_account_text.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
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
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FadeAnimation(2.2, buildEmailFormField()),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        FadeAnimation(2.3, buildPasswordFormField()),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        FadeAnimation(
                            2.4,
                            Row(
                              children: [
                                Checkbox(
                                  value: remember,
                                  activeColor: kPrimaryColor,
                                  onChanged: (value) {
                                    setState(() {
                                      remember = value;
                                    });
                                  },
                                ),
                                Text("Remember me"),
                                Spacer(),
                                GestureDetector(
                                  onTap: () => {},
                                  child: Text(
                                    "Forgot Password",
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                )
                              ],
                            )),
                        FormError(errors: errors),
                        SizedBox(height: getProportionateScreenHeight(20)),
                        FadeAnimation(
                            2.5,
                            DefaultButton(
                              text: "Continue",
                              press: () {
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  // if all are valid then go to success screen
                                  KeyboardUtil.hideKeyboard(context);
                                }
                              },
                            )),
                      ],
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  FadeAnimation(2.6, NoAccountText()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}

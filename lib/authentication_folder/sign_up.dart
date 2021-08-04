import 'package:ff_user/models_folder/user.dart';
import 'package:ff_user/services_folder/_database/data.dart';
import 'package:ff_user/shared_folder/_buttons/default_button.dart';
import 'package:ff_user/shared_folder/_buttons/keyboard.dart';
import 'package:ff_user/shared_folder/_constants/constants.dart';
import 'package:ff_user/shared_folder/_constants/custom_surfix_icon.dart';
import 'package:ff_user/shared_folder/_constants/form_error.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  var _fullname = TextEditingController();
  var _email = TextEditingController();
  String _status = 'Enabled';
  String _type = 'Passenger';

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

  void register(String uid, phone) async {
    try {
      if (uid != null) {
        DatabaseReference dbref =
            FirebaseDatabase.instance.reference().child('users/$uid');
        Map userMap = {
          'Email': _email.text,
          'FullName': _fullname.text,
          'phone': phone,
        };
        dbref.set(userMap);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
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
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Text("Complete Profile", style: headingStyle),
                  Text(
                    "Complete your details or continue  \nwith social media",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.06),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        buildFullname(),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        buildEmail(),
                        SizedBox(height: getProportionateScreenHeight(30)),
                        FormError(errors: errors),
                        SizedBox(height: getProportionateScreenHeight(40)),
                        DefaultButton(
                          text: "continue",
                          color: Colors.blue[400],
                          press: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              KeyboardUtil.hideKeyboard(context);
                              dynamic result = await Data(uid: user.uid)
                                  .addPassenger(_email.text, _fullname.text,
                                      user.phone, _status);
                              if (result == null) {
                                await Data(uid: user.uid)
                                    .addPerson(_type, _status);
                                register(user.uid, user.phone);
                                Navigator.of(context)
                                    .pushReplacementNamed('/wrapper');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  Text(
                    "By continuing your confirm that you agree \nwith our Term and Condition",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildFullname() {
    return TextFormField(
      controller: _fullname,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Full Name",
        hintText: "John Doe",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _email,
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
        hintText: "Example@email.com",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}

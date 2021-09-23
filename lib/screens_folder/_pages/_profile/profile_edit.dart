import 'package:ff_user/services_folder/_database/data.dart';
import 'package:ff_user/shared_folder/_buttons/keyboard.dart';
import 'package:ff_user/shared_folder/_constants/progressDialog.dart';
import 'package:ff_user/shared_folder/_constants/size_config.dart';
import 'package:ff_user/shared_folder/_global/glob_var.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ProfileEdit extends StatefulWidget {
  final String title;
  final String edits;
  final String status;
  const ProfileEdit({Key key, this.title, this.edits, this.status})
      : super(key: key);
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool focus = false;
  var editable = FocusNode();
  @override
  void initState() {
    super.initState();
    print(widget.edits);
  }

  @override
  Widget build(BuildContext context) {
    setFocus();
    return AlertDialog(
      title: Text(
        widget.title,
        style: TextStyle(fontFamily: 'Muli'),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              focusNode: editable,
              controller: _textController,
            ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              style: TextButton.styleFrom(primary: Colors.blue),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(fontFamily: 'Muli'),
              ),
            ),
            SizedBox(width: getProportionateScreenWidth(20)),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  String value = _textController.text.toString();
                  if (value.isEmpty || value.length < 6) {
                    Toast.show("Iput Not valid Try Again", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                  } else {
                    KeyboardUtil.hideKeyboard(context);
                    if (widget.edits == 'FullName') {
                      dynamic result = Data(uid: currentUserinfo.uid)
                          .addPassenger(currentUserinfo.email, value,
                              currentUserinfo.phone, widget.status);
                      if (result != null) {
                        editProfile(widget.edits, value);
                      } else {
                        Toast.show("Cannot Edit Profile", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      }
                    } else {
                      dynamic result = Data(uid: currentUserinfo.uid)
                          .addPassenger(value, currentUserinfo.fullname,
                              currentUserinfo.phone, widget.status);
                      if (result != null) {
                        editProfile(widget.edits, value);
                      } else {
                        Toast.show("Cannot Edit Profile", context,
                            duration: Toast.LENGTH_SHORT,
                            gravity: Toast.BOTTOM);
                      }
                    }
                  }
                }
              },
              child: Text(
                'Submit',
                style: TextStyle(fontFamily: 'Muli'),
              ),
            )
          ],
        )
      ],
    );
  }

  void setFocus() {
    if (!focus) {
      FocusScope.of(context).requestFocus(editable);
      focus = true;
    }
  }

  void editProfile(String path, String value) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => ProgressDialog(
              status: 'Loading.....',
            ));
    DatabaseReference editref = FirebaseDatabase.instance
        .reference()
        .child('users/${currentUserinfo.uid}/$path');
    editref.once().then((DataSnapshot snapshot) {
      if (snapshot != null) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        editref.set(value);
        Toast.show("Profile Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Toast.show("Error Cannot Update", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }
}

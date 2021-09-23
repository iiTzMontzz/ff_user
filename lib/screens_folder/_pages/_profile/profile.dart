import 'package:ff_user/models_folder/passenger.dart';
import 'package:ff_user/screens_folder/_pages/_profile/profile_body.dart';
import 'package:ff_user/screens_folder/_pages/_profile/profile_edit.dart';
import 'package:ff_user/screens_folder/_pages/_profile/profile_header.dart';
import 'package:ff_user/services_folder/_database/data.dart';
import 'package:ff_user/shared_folder/_constants/FadeAnimation.dart';
import 'package:ff_user/shared_folder/_global/glob_var.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Passenger>(
        stream: Data(uid: currentUserinfo.uid).passengerData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/home');
                  },
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    FadeAnimation(2, ProfileHeader()),
                    SizedBox(height: 20),
                    FadeAnimation(
                        1.5,
                        ProfileBody(
                          text: snapshot.data != null
                              ? snapshot.data.phonenumber
                              : 'Loading.....',
                          icon: "assets/icons/Phone.svg",
                          editable: false,
                          press: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => ProfileEdit(
                                      title: 'Edit Phone',
                                      edits: 'phone',
                                      status: snapshot.data.status,
                                    ));
                          },
                        )),
                    FadeAnimation(
                        1.6,
                        ProfileBody(
                          text: snapshot.data != null
                              ? snapshot.data.fullname
                              : 'Loading.....',
                          icon: "assets/icons/User Icon.svg",
                          editable: true,
                          press: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => ProfileEdit(
                                      title: 'Edit Name',
                                      edits: 'FullName',
                                      status: snapshot.data.status,
                                    ));
                          },
                        )),
                    FadeAnimation(
                        1.7,
                        ProfileBody(
                          text: snapshot.data != null
                              ? snapshot.data.email
                              : 'Loading.....',
                          icon: "assets/icons/Mail.svg",
                          editable: true,
                          press: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) => ProfileEdit(
                                      title: 'Edit Email',
                                      edits: 'Email',
                                      status: snapshot.data.status,
                                    ));
                          },
                        )),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}

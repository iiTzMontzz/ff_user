import 'package:ff_user/models_folder/enums.dart';
import 'package:ff_user/screens_folder/_fronts/_landing/coustom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("History")),
      body: SafeArea(
        child: Container(),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.history),
    );
  }
}

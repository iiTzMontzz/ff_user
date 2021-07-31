import 'package:ff_user/screens_folder/_fronts/myapp.dart';
import 'package:ff_user/shared_folder/_global/key.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseApp.configure(
    name: dbName,
    options: const FirebaseOptions(
      googleAppID: googleID,
      apiKey: androidID,
      databaseURL: dbUrl,
    ),
  );

  runApp(MyApp());
}

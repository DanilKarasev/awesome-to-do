import 'package:awesome_to_do/injection.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app.dart';
import 'firebase_options.dart';
import 'hive.dart';

void main() async {
  await mainInitSetup();
  runApp(const ToDoApp());
}

Future<void> mainInitSetup() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  configureInjection();
  await initHive();
  initializeDateFormatting("ru_RU", null);
  FlutterNativeSplash.remove();
}

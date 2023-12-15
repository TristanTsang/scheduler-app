import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/translations.dart';
import 'package:improvement_journal/screens/AnalyticsScreen.dart';
import 'package:improvement_journal/screens/AppEditorScreen.dart';
import 'package:improvement_journal/screens/JournalsScreen.dart';
import 'package:improvement_journal/screens/homeScreen.dart';
import 'package:provider/provider.dart';
import 'Providers/AppData.dart';
import 'Providers/HabitData.dart';
import 'Providers/JournalData.dart';
import 'Providers/TaskData.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Services/sqlite_service.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SqliteService.initializeDB();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (context) => HabitData(),),
        ChangeNotifierProvider(
          create: (context) => AppData(),),
        ChangeNotifierProvider(
          create: (context) => TaskData(),),
        ChangeNotifierProvider(
          create: (context) => JournalData(),),


      ],
      child: MaterialApp(
        localizationsDelegates: const [
        DefaultCupertinoLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
          FlutterQuillLocalizations.delegate
        ],
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        initialRoute: 'homeScreen',
        routes: {
          'homeScreen': (context) => HomeScreen(),
          'settings' : (context) => AppEditorScreen(),
          'analytics' : (context) => AnalyticsScreen(),
          'journals' : (context) => JournalsScreen(),
        },
      ),
    );
  }
}

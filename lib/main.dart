import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/translations.dart';
import 'package:improvement_journal/screens/AnalyticsScreen.dart';
import 'package:improvement_journal/screens/AppEditorScreen.dart';
import 'package:improvement_journal/screens/JournalsScreen.dart';
import 'package:improvement_journal/screens/LoadingScreen.dart';
import 'package:improvement_journal/screens/homeScreen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'Providers/AppData.dart';
import 'Providers/HabitData.dart';
import 'Providers/JournalData.dart';
import 'Providers/TaskData.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Services/sqlite_service.dart';
import 'models/JournalPrompt.dart';
import 'models/TaskList.dart';
import 'models/habit.dart';
import 'models/journalEntry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SqliteService.initializeDB();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => HabitData(),
      ),
      ChangeNotifierProvider(
        create: (context) => AppData(),
      ),
      ChangeNotifierProvider(
        create: (context) => TaskData(),
      ),
      ChangeNotifierProvider(
        create: (context) => JournalData(),
      ),
    ],
    child: const MyApp(),
  ));
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {


    return MaterialApp(
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
      initialRoute: 'loadingScreen',
      routes: {
        'homeScreen': (context) => HomeScreen(),
        'settings': (context) => AppEditorScreen(),
        'analytics': (context) => AnalyticsScreen(),
        'journals': (context) => JournalsScreen(),
        'loadingScreen': (context) => LoadingScreen(),
      },
    );
  }
}



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/screens/homeScreen.dart';
import 'package:provider/provider.dart';
import '../Providers/AppData.dart';
import '../Providers/HabitData.dart';
import '../Providers/JournalData.dart';
import '../Providers/TaskData.dart';
import '../Services/sqlite_service.dart';
import '../models/JournalPrompt.dart';
import '../models/TaskList.dart';
import '../models/habit.dart';
import '../models/journalEntry.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var _habits = <Habit>[];
  var _journalPrompts = <JournalPrompt>[];
  var _journalMap =  new Map<DateTime, JournalEntry>();
  var _taskListMap =  new Map<DateTime, TaskList>();
  var firstRun = true;
  var date;
  Future<bool> loadData() async {
    for(Habit habit in await SqliteService.habits()){
      _habits.add(habit);
      for(DateTime date in await SqliteService.habitDates(habit)){
        habit.addDate(date);
      }
    }
    for(JournalPrompt prompt in await SqliteService.journalPrompts()){
      _journalPrompts.add(prompt);
    }
    _journalMap.addAll(await SqliteService.journalsMap());
    _taskListMap.addAll(await SqliteService.taskListsMap());

    date = await SqliteService.startDate();

    return true;
  }
  late final Future myFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFuture = loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  FutureBuilder(
          future: myFuture,
          builder : (BuildContext context, AsyncSnapshot snap){
            if(snap.data == true && firstRun){
              firstRun = false;
              Provider.of<HabitData>(context, listen:false).loadHabits(_habits);
              Provider.of<JournalData>(context, listen:false).loadPrompts(_journalPrompts);
              Provider.of<JournalData>(context, listen: false).loadJournals(_journalMap);
              Provider.of<TaskData>(context, listen: false).loadTasks(_taskListMap);
              Provider.of<AppData>(context, listen: false).loadInitialDate(date);

              return const HomeScreen();
            } else if(!firstRun){
              return const HomeScreen();
            } else{
              //return the widget that you want to display after loading
              return Center(child: Image( height: MediaQuery.of(context).size.width *0.33, image: const AssetImage('images/MetiorLogo.png'),),);
            }
          })
      );
  }


}

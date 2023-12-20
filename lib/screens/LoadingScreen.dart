import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/screens/homeScreen.dart';
import 'package:provider/provider.dart';
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
    return true;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  FutureBuilder(
          future: loadData(), // the function to get your data from firebase or firestore
          builder : (BuildContext context, AsyncSnapshot snap){
            if(snap.data == true){
              Provider.of<HabitData>(context, listen:false).loadHabits(_habits);
              Provider.of<JournalData>(context, listen:false).loadPrompts(_journalPrompts);
              Provider.of<JournalData>(context, listen: false).loadJournals(_journalMap);
              Provider.of<TaskData>(context, listen: false).loadTasks(_taskListMap);
              return HomeScreen();
            }
            else{
              //return the widget that you want to display after loading
              return Container(
                  child: Center(child: Image(image: AssetImage('images/MetiorLogo.png'),),),);
            }
          })
      );
  }


}

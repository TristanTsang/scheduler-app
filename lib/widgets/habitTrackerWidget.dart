import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/constants.dart';
import 'package:improvement_journal/screens/addHabitScreen.dart';
import 'package:provider/provider.dart';

import '../models/HabitData.dart';
import '../models/habit.dart';
import '../screens/HabitManagerScreen.dart';
import '../screens/addTaskScreen.dart';
import 'HabitWidget.dart';
class HabitTrackerWidget extends StatelessWidget {
  DateTime date;
  HabitTrackerWidget(this.date, {super.key});

  List<Widget> buildHabitList(Set<Habit> habits){
    var myList = <Widget>[];
    for(Habit habit in habits){
      myList.add(HabitWidget(habit, date));
    }
    return myList;
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<HabitData>(context, listen: false).updateDate(date);

    return RawMaterialButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => HabitManagerScreen()));
      },
      child: Container(
          height: MediaQuery.of(context).size.height*0.15,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Habit Tracker:", style:TextStyle(color: Colors.white, fontSize:defaultFontSize, fontWeight: FontWeight.bold )),
                Expanded(
                  child: ListView(
                    children: buildHabitList(Provider.of<HabitData>(context, listen: true).getHabits(date)),
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}

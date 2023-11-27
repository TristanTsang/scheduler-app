import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/constants.dart';
import 'package:improvement_journal/screens/addHabitScreen.dart';
import 'package:provider/provider.dart';

import '../Providers/HabitData.dart';
import '../models/habit.dart';
import '../screens/AppEditorScreen.dart';
import '../screens/AppEditorScreen.dart';
import '../screens/addTaskScreen.dart';
import 'HabitWidget.dart';
class HabitTrackerWidget extends StatelessWidget {
  DateTime date;
  HabitTrackerWidget(this.date, {super.key});

  List<Widget> buildHabitList(Set<Habit>? habits){
    var myList = <Widget>[];
    if(habits != null){
      for(Habit habit in habits){
        myList.add(HabitWidget(habit, date));
      }
    }

    return myList;
  }

  @override
  Widget build(BuildContext context) {
    var myList = buildHabitList(Provider.of<HabitData>(context, listen: true).getHabits(date));
    return RawMaterialButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AppEditorScreen()));
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
                    children: (myList.length==0)? [Center(
                      child: Column(
                        children: [
                          Icon(Icons.light_mode, color: Colors.white, size:45),
                          Text("No Habits Tracked For Today", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold ),),
                          Text("Click To Add More!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ],
                      )
                    )] : myList,
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}

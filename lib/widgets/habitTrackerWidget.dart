import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/constants.dart';
import 'package:improvement_journal/screens/addHabitScreen.dart';
import 'package:provider/provider.dart';

import '../models/HabitData.dart';
import '../models/habit.dart';
import '../screens/addTaskScreen.dart';

class HabitTrackerWidget extends StatefulWidget {
  DateTime date;
  HabitTrackerWidget(this.date, {super.key});

  @override
  State<HabitTrackerWidget> createState() => _HabitTrackerWidgetState();
}

class _HabitTrackerWidgetState extends State<HabitTrackerWidget> {

  List<Widget> buildHabitList(Set<Habit> habits){
    var myList = <Widget>[];
    for(Habit habit in habits){
      myList.add(Text(habit.name, style: TextStyle(color: Colors.white),));
    }
    return myList;
  }
  @override
  Widget build(BuildContext context) {
    Provider.of<HabitData>(context, listen: false).updateDate(widget.date);

    return Container(
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
              child: Stack(
                children:[ListView(
                  children: buildHabitList(Provider.of<HabitData>(context, listen: true).getHabits(widget.date)),
                ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      child: Icon(Icons.add, color: kPrimaryColor),
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) {
                              return AddHabitScreen();
                            });
                      },
                    ),
                  )]
              ),
            ),
          ],
        ),
      )
    );
  }
}

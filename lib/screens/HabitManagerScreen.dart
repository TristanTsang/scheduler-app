

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/HabitData.dart';
import '../models/habit.dart';
import '../widgets/HabitWidget.dart';
import 'addHabitScreen.dart';

class HabitManagerScreen extends StatefulWidget {
  const HabitManagerScreen({Key? key}) : super(key: key);

  @override
  State<HabitManagerScreen> createState() => _HabitManagerScreenState();
}

class _HabitManagerScreenState extends State<HabitManagerScreen> {
  @override
  Widget build(BuildContext context) {
    var myList = <Widget>[];
    for (Habit habit in Provider.of<HabitData>(context, listen: true).getAllHabits()) {
      myList.add(Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(habit.name, style: secondaryHeader,),
                      Row(children: [
                        Text("Current Streak: ${habit.getStreak(DateTime.now())} \t Highest Streak: ${habit.highestStreak}")
                      ],)
                    ],
                  ),
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: Checkbox(value: habit.tracked, onChanged: (bool){
                      print(bool);
                      setState(() {
                        if(bool!) {
                          Provider.of<HabitData>(context, listen: false).trackHabit(habit);
                        } else {
                          Provider.of<HabitData>(context, listen: false).untrackHabit(habit);
                        }
                      });
                    },
                      activeColor: kDarkGrey,
                      shape: CircleBorder(),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              )),
        ),
      ));
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.075,
                bottom: MediaQuery.of(context).size.height * 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Text(
                  "Habit Manager",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                IconButton(
                  icon: Icon(Icons.list_alt_outlined),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "All Habits",
                        style: primaryHeader,
                      ),
                      Text(
                        "Check the box to track",
                        style: primarySubtitle,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: ListView(
                          children: myList,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35),
                      Center(
                        child: RawMaterialButton(
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.67,
                                height:
                                MediaQuery.of(context).size.height * 0.055,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.black,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Add Habit",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                )),
                            onPressed: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return AddHabitScreen();
                                  });
                            }),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

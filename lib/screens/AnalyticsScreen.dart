import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Providers/HabitData.dart';
import '../Providers/JournalData.dart';
import '../constants.dart';
import '../extensions.dart';
import '../models/habit.dart';
import '../models/journalEntry.dart';
import 'JournalTextScreen.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _selectedIndex = 2;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.popAndPushNamed(context, "homeScreen");
    }
    if (index == 1) {
      Navigator.popAndPushNamed(context, 'journals');
    }
    if (index == 2) {
      Navigator.popAndPushNamed(context, 'analytics');
    }
  }

  final TextEditingController dropdownController = TextEditingController();
  Habit? selectedHabit;

  @override
  Widget build(BuildContext context) {
    var list =
        Provider.of<HabitData>(context, listen: false).getAllHabits().toList();
    if (list.length>0){
      selectedHabit = list[0];
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Color(0xffF5F5F5),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.description), label: "Journals"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: "Analytics"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings"),
          ],
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle:
          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          selectedIconTheme: IconThemeData(size: 35),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: kDarkGrey,
          onTap: _onItemTapped,
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: AppBar(
            titleSpacing: 0,
            leadingWidth: 45,
            title: Text("Your Habit Analytics", style: TextStyle(fontSize: 17.5),),
            leading: Icon(Icons.bar_chart),
          ),
        ),
        backgroundColor: backgroundColor,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Habit Analytics",
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      list.length > 0
                          ? Center(
                          child: DropdownMenu(
                              width: MediaQuery.of(context).size.width*0.33,
                              inputDecorationTheme: InputDecorationTheme(
                                  constraints: BoxConstraints(maxHeight:30),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide()
                                  )
                              ),
                              onSelected: (Habit? newHabit) {
                                setState(() {
                                  selectedHabit = newHabit!;
                                });
                              },
                              initialSelection: list[0],
                              dropdownMenuEntries: list
                                  .map<DropdownMenuEntry<Habit>>(
                                      (Habit habit) {
                                    return DropdownMenuEntry<Habit>(
                                        value: habit, label: habit.name);
                                  }).toList()))
                          : Container(),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start, children: [
                      TableCalendar(
                        headerStyle: HeaderStyle(
                          formatButtonVisible : false,
                        ),
                        calendarStyle: CalendarStyle(),
                        calendarBuilders: CalendarBuilders(
                          prioritizedBuilder: (context, day, focusedDay) {
                            Widget? item;
                            final text = DateFormat.d().format(day);
                            if (selectedHabit!.isDone(day)) {
                              item = Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color:Colors.black, width: 1),
                                  color: day.month == focusedDay.month ?  Colors.purple[800] : Colors.purple[400],
                                ),

                                child: Center(
                                  child: Text(
                                    text,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            } else{
                              item = Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color:Colors.black, width: 1),
                                ),
                                child: Center(
                                  child: Text(
                                    text,
                                    style: TextStyle(color: day.month == focusedDay.month ? Colors.black: Colors.grey),
                                  ),
                                ),
                              );}
                            return item;
                          },
                          todayBuilder: (context, day, focusedDay){
                            return null;
                          },
                          singleMarkerBuilder: (context, day, focusedDay){
                            return null;
                          },
                        ),
                        headerVisible: true,
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: DateTime.now(),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        "Current Streak: ${selectedHabit!.getStreak(DateTime.now())} days",
                        style: secondaryHeader,
                      ),
                      Text(
                        "Highest Streak:  ${selectedHabit!.highestStreak} days",
                        style: secondaryHeader,
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Current Duration:  ${DateTimeExtensions.daysBetween(selectedHabit!.startDate, DateTime.now())} days",
                        style: secondaryHeader,
                      ),
                      Text(
                        "Total Duration: ${DateTimeExtensions.daysBetween(selectedHabit!.startDate, selectedHabit!.endDate)} days",
                        style: secondaryHeader,
                      ),
                      SizedBox(height: 10,),
                      Text(
                        "Current Accuracy: ${selectedHabit!.getAccuracy()}%",
                        style: secondaryHeader,
                      ),
                      SizedBox(height: 20,),
                    ],),
                  )
                ],
              ),
            )
          ],
        ));}
    else{

      return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(30),
            child: AppBar(
              titleSpacing: 0,
              leadingWidth: 45,
              title: Text("Your Habit Analytics", style: TextStyle(fontSize: 17.5),),
              leading: Icon(Icons.bar_chart),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Color(0xffF5F5F5),
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.description), label: "Journals"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bar_chart), label: "Analytics"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Settings"),
            ],

            type: BottomNavigationBarType.fixed,
            selectedLabelStyle:
            TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            selectedIconTheme: IconThemeData(size: 35),
            unselectedLabelStyle: TextStyle(fontSize: 12),
            showUnselectedLabels: true,
            currentIndex: _selectedIndex,
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: kDarkGrey,
            onTap: _onItemTapped,
          ),
          backgroundColor: backgroundColor,
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Habit Analytics",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                SizedBox(height: 100,),
                Center(
                  child: Icon(Icons.light_mode,
                      color: Colors.black,
                      size: 60),
                ),
                Center(
                  child: Text(
                    "No Existing Habits To Manage",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold),),
                )
                  ],
                ),
              )
            ],
          ));
    }
  }
}

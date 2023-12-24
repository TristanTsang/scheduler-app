import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Providers/HabitData.dart';
import '../constants.dart';
import '../extensions.dart';
import '../models/habit.dart';
import 'AppEditorScreen.dart';

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
  }

  final TextEditingController dropdownController = TextEditingController();
  Habit? selectedHabit;
  bool firstRun = true;
  @override
  Widget build(BuildContext context) {
    var list =
        Provider.of<HabitData>(context, listen: false).getAllHabits().toList();
    if (list.isNotEmpty && firstRun) {
      selectedHabit = list[0];
      firstRun = false;
    }
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: const Color(0xffF5F5F5),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.description), label: "Journals"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart), label: "Analytics"),
          ],
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          selectedIconTheme: const IconThemeData(size: 35),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          showUnselectedLabels: true,
          currentIndex: _selectedIndex,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: kDarkGrey,
          onTap: _onItemTapped,
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: AppBar(
            titleSpacing: 0,
            leadingWidth: 45,
            title: const Text(
              "Your Habit Analytics",
              style: TextStyle(fontSize: 17.5),
            ),
            leading: const Icon(Icons.bar_chart),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AppEditorScreen()));
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Habit Analytics",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        list.isNotEmpty
                            ? Center(
                                child: DropdownMenu(
                                  menuStyle: MenuStyle(),
                                  textStyle: TextStyle(fontSize: smallFontSize, fontWeight: FontWeight.bold),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    inputDecorationTheme: const InputDecorationTheme(

                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide())),
                                    onSelected: (Habit? newHabit) {
                                      setState(() {
                                        selectedHabit = newHabit!;
                                      });
                                    },
                                    enableSearch: false,
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
                    list.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: TableCalendar(
                                      headerStyle: const HeaderStyle(
                                        formatButtonVisible: false,
                                      ),
                                      calendarStyle: const CalendarStyle(),
                                      calendarBuilders: CalendarBuilders(
                                        prioritizedBuilder:
                                            (context, day, focusedDay) {
                                          Widget? item;
                                          final text =
                                              DateFormat.d().format(day);
                                          if (selectedHabit!.isDone(day)) {
                                            item = Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1),
                                                color: day.month ==
                                                        focusedDay.month
                                                    ? Colors.black
                                                    : Colors.purple[400],
                                              ),
                                              child: Center(
                                                child: Text(
                                                  text,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            );
                                          } else if( selectedHabit!.isTracked(day)){
                                            item = Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1),
                                                color: day.month ==
                                                    focusedDay.month
                                                    ? kDarkGrey
                                                    : kLightGrey,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  text,
                                                  style: TextStyle(
                                                      color: day.month ==
                                                          focusedDay.month
                                                          ? Colors.white
                                                          : Colors.black),
                                                ),
                                              ),
                                            );
                                          } else{
                                            item = Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 1),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  text,
                                                  style: TextStyle(
                                                      color: day.month ==
                                                              focusedDay.month
                                                          ? Colors.black
                                                          : Colors.grey),
                                                ),
                                              ),
                                            );
                                          }
                                          return item;
                                        },
                                        todayBuilder:
                                            (context, day, focusedDay) {
                                          return null;
                                        },
                                        singleMarkerBuilder:
                                            (context, day, focusedDay) {
                                          return null;
                                        },
                                      ),
                                      headerVisible: true,
                                      firstDay: DateTime.utc(2010, 10, 16),
                                      lastDay: DateTime.utc(2030, 3, 14),
                                      focusedDay: DateTime.now(),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Material(
                                elevation: 2,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 1,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Your Stats:",
                                          style: primaryHeader,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15),
                                          child: const Divider(
                                            height: 20,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Current Streak: ",
                                                style: secondaryHeader,
                                              ),
                                              Text(
                                                "${selectedHabit!.getStreak(DateTime.now())} days",
                                                style: secondaryHeader,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Highest Streak: ",
                                                style: secondaryHeader,
                                              ),
                                              Text(
                                                " ${selectedHabit!.highestStreak} days",
                                                style: secondaryHeader,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25),
                                          child: const Divider(
                                            height: 20,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Current Duration: ",
                                                style: secondaryHeader,
                                              ),
                                              Text(
                                                "  ${DateTimeExtensions.daysBetween(selectedHabit!.startDate, DateTime.now())+1} days",
                                                style: secondaryHeader,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Total Duration: ",
                                                style: secondaryHeader,
                                              ),
                                              Text(
                                                "  ${DateTimeExtensions.daysBetween(selectedHabit!.startDate, selectedHabit!.endDate)} days",
                                                style: secondaryHeader,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25),
                                          child: const Divider(
                                            height: 20,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Current Accuracy: ",
                                                style: secondaryHeader,
                                              ),
                                              Text(
                                                "  ${selectedHabit!.getAccuracy()}%",
                                                style: secondaryHeader,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : const Padding(
                            padding: EdgeInsets.only(top: 40.0),
                            child: Center(
                              child: Column(children: [
                                Icon(Icons.light_mode,
                                    color: Colors.black, size: 60),
                                Text(
                                  "No Existing Habits",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ]),
                            ),
                          )
                  ]),
            )
          ],
        ));
  }
}

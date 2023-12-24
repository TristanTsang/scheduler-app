import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/screens/EditJournalScreen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../Providers/JournalData.dart';
import '../constants.dart';
import '../Providers/HabitData.dart';
import '../models/JournalPrompt.dart';
import '../models/habit.dart';
import 'AddJournalScreen.dart';
import 'EditHabitScreen.dart';
import 'addHabitScreen.dart';

class AppEditorScreen extends StatefulWidget {
  const AppEditorScreen({Key? key}) : super(key: key);

  @override
  State<AppEditorScreen> createState() => _HabitManagerScreenState();
}

class _HabitManagerScreenState extends State<AppEditorScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool habits = true;
  @override
  Widget build(BuildContext context) {
    var myList = <Widget>[];
    var myPrompts = <Widget>[];
    for (Habit habit
        in Provider.of<HabitData>(context, listen: true).getAllHabits()) {
      myList.add(Padding(
        padding: const EdgeInsets.all(5),
        child: RawMaterialButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return EditHabitScreen(habit: habit);
                });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 5,
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.75),
                          child: Text(
                            overflow: TextOverflow.ellipsis,
                            habit.name,
                            style: secondaryHeader,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Consistency: ${habit.getAccuracy()}% \t Highest Streak: ${habit.highestStreak}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                                "(${DateFormat.yMMMd('en_US').format(habit.startDate)} - ${DateFormat.yMMMd('en_US').format(habit.endDate)}) ")
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ));
    }

    for (JournalPrompt journal
        in Provider.of<JournalData>(context, listen: true).journalPrompts) {
      myPrompts.add(Padding(
        padding: const EdgeInsets.all(5),
        child: RawMaterialButton(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return EditJournalScreen(prompt: journal);
                });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 5,
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Flexible(
                      child: Text(
                        journal.text,
                        style: secondaryHeader,
                      ),
                    ),
                  ],
                )),
          ),
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
                const Text(
                  "App Editor",
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
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                ),
                color: backgroundColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    TabBar.secondary(
                      labelStyle: TextStyle(fontSize:18, fontWeight: FontWeight.bold),
                      indicatorWeight:2.5,
                      automaticIndicatorColorAdjustment: false,
                      indicatorColor: Colors.black,
                      controller: _tabController,
                      tabs: const [
                        Tab(text: "Habit Tracker"),
                        Tab(text: "Journal Prompts"),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Stack(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: ListView(
                                        padding: const EdgeInsets.only(top: 15),
                                        children: (myList.length == 0)
                                            ? [
                                                const Column(
                                                  children: [
                                                    Icon(Icons.light_mode,
                                                        color: Colors.black,
                                                        size: 60),
                                                    Text(
                                                      "No Existing Habits To Manage",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              ]
                                            : myList,
                                      ),
                                    ),
                                  ]),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: RawMaterialButton(
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.67,
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.055,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: Colors.black,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Add Habit",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          )),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return const AddHabitScreen();
                                            });
                                      }),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: ListView(
                                        padding: const EdgeInsets.only(top: 15),
                                        children: myPrompts,
                                      ),
                                    ),
                                  ]),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 30),
                                  child: RawMaterialButton(
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.67,
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.055,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: Colors.black,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "Add Journal",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15),
                                            ),
                                          )),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return const AddJournalScreen();
                                            });
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

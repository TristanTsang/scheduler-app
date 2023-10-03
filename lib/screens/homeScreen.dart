import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/extensions.dart';
import 'package:intl/intl.dart';
import 'package:improvement_journal/constants.dart';
import 'package:provider/provider.dart';

import '../models/journalData.dart';
import '../models/journalEntry.dart';
import '../models/task.dart';
import '../widgets/habitTrackerWidget.dart';
import '../widgets/taskWidget.dart';
import '../widgets/toDoListWidget.dart';
import 'addTaskScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime selectedDay;
  late JournalEntry selectedJournal;
  DateTime date = DateTime.now();
  @override
  String getDateText() {
    String text = "";
    if (selectedDay.isSameDate(date)) {
      text = "Today";
    } else if (selectedDay.isBefore(date)) {
      selectedDay.isSameDate(DateTime(date.year, date.month, date.day - 1))
          ? text = "Yesterday"
          : text =
              "${DateTimeExtensions.daysBetween(selectedDay, date)} days ago";
    } else if (selectedDay.isAfter(date)) {
      selectedDay.isSameDate(DateTime(date.year, date.month, date.day + 1))
          ? text = "Tomorrow"
          : text =
              "${DateTimeExtensions.daysBetween(date, selectedDay)} days from now";
    }
    return text;
    //Provider.of<JournalData>(context, listen: true).getSelectedDay();
  }

  @override
  Widget build(BuildContext context) {
    selectedDay =
        Provider.of<JournalData>(context, listen: true).getSelectedDay();
    selectedJournal =
        Provider.of<JournalData>(context, listen: true).getSelectedJournal();
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                DateFormat.yMMMMd('en_US').format(selectedDay),
                style: primaryHeader
              ),
              Text(getDateText(),
                  style: primarySubtitle),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              CalendarTimeline(),
              Divider(
                color: kLightAccentColor,
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              HabitTracker(),
              SizedBox(
                height: 10,
              ),
              toDoListWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          TextButton(
            onPressed: () {},
            child: Text(""),
          ),
          TextButton(
            onPressed: () {},
            child: Text(""),
          )
        ],
      ),
    );
  }
}

class CalendarTimeline extends StatefulWidget {
  const CalendarTimeline({Key? key}) : super(key: key);

  @override
  State<CalendarTimeline> createState() => _CalendarTimelineState();
}

class _CalendarTimelineState extends State<CalendarTimeline> {
  List<Widget> displayWeek(DateTime initialDate) {
    List<Widget> dateWidgets = [];
    for (int i = 0; i < 7; i++) {
      dateWidgets.add(DateWidget(
        date:
            DateTime(initialDate.year, initialDate.month, initialDate.day + i),
        selectedDate:
            Provider.of<JournalData>(context, listen: true).getSelectedDay(),
      ));
    }
    return dateWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          displayWeek(DateTimeExtensions.mostRecentMonday(DateTime.now())),
    );
  }
}

class DateWidget extends StatelessWidget {
  DateTime date;
  DateTime selectedDate;
  bool selected = false;
  Color currentDayColor = kPrimaryColor;
  Color beforeDayColor = kAccentColor;
  Color afterDayColor = kLightAccentColor;

  DateWidget(
      {required this.date,
      required this.selectedDate,
      currentDayColor,
      beforeDayColor,
      afterDayColor}) {}
  @override
  Widget build(BuildContext context) {
    TextStyle dayStyle = TextStyle(
      color: date.isSameDate(DateTime.now())
          ? currentDayColor
          : (date.isBefore(DateTime.now()) ? beforeDayColor : afterDayColor),
      fontSize: MediaQuery.of(context).size.width * 0.03,
    );
    TextStyle numStyle = TextStyle(
        color: date.isSameDate(DateTime.now())
            ? currentDayColor
            : (date.isBefore(DateTime.now()) ? beforeDayColor : afterDayColor),
        fontSize: MediaQuery.of(context).size.width * 0.045,
        fontWeight: FontWeight.bold);


    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      height: MediaQuery.of(context).size.height * 0.075,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color:
                selectedDate.isSameDate(date) ? Colors.black : Colors.transparent,
            width: 1),
      ),
      child: RawMaterialButton(

        onPressed: () {
          Provider.of<JournalData>(context, listen: false)
              .changeSelectedDay(date);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  DateFormat('E').format(date).substring(0, 3),
                  style: dayStyle,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  DateFormat('d').format(date).padLeft(2, "0"),
                  style: numStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}









import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/Services/sqlite_service.dart';
import 'package:improvement_journal/extensions.dart';
import 'package:intl/intl.dart';
import 'package:improvement_journal/constants.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../Providers/AppData.dart';
import '../Providers/journalData.dart';
import '../models/journalEntry.dart';
import '../models/task.dart';
import '../widgets/JournalButton.dart';
import '../widgets/QuoteWidget.dart';
import '../widgets/habitTrackerWidget.dart';
import '../widgets/taskWidget.dart';
import '../widgets/toDoListWidget.dart';
import 'AppEditorScreen.dart';
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
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(index ==1){
      Navigator.popAndPushNamed(context, 'journals');
    }
    if(index ==2){
      Navigator.popAndPushNamed(context, 'analytics');
    }
  }

  @override
  Widget build(BuildContext context) {

    selectedDay =
        Provider.of<AppData>(context, listen: true).getSelectedDay();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Text(DateFormat.yMMMMd('en_US').format(selectedDay),
                  style: primaryHeader),
              Text(getDateText(), style: primarySubtitle),
              SizedBox(height: MediaQuery.of(context).size.height*0.08,child: CalendarTimeline()),
              Divider(
                color: kLightAccentColor,
                thickness: 2,
              ),
              SizedBox(
                height: 10,
              ),
              HabitTrackerWidget(selectedDay),
              Divider(height: 15,),
              JournalButton(),
              Divider(height: 25, thickness: 2,),
              toDoListWidget(),

              Divider(height: 30, thickness: 2,),
              QuoteWidget(),

            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        backgroundColor: Color(0xffF5F5F5),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: "Journals"),

          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Analytics"),
          //BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize:15, fontWeight: FontWeight.bold),
        selectedIconTheme: IconThemeData(size:35),
        unselectedLabelStyle: TextStyle(fontSize:12),
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kDarkGrey,
        onTap: _onItemTapped,
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
  late int _index;

  List<Widget> displayWeek(DateTime startDate, Function myFunc) {
    DateTime date = DateTimeExtensions.mostRecentMonday(startDate);
    int numWeeks = DateTimeExtensions.daysBetween(date, DateTimeExtensions.mostRecentMonday(DateTime.now())) % 7;

    List<Widget> weekWidgets = [];
    for (int week = 0; week <= numWeeks+2; week++) {
      List<Widget> dateWidgets = [];

      for (int day = 0; day < 7; day++) {
        if(DateTime(date.year,date.month, date.day).add(Duration(days: day + week*7,)).isSameDate( DateTimeExtensions.mostRecentMonday(DateTime.now()))){
          _index = week;
        }

        dateWidgets.add(DateWidget(
          date: DateTime(
            date.year,date.month, date.day).add(Duration(days: day + week*7,)),
          selectedDate:
              Provider.of<AppData>(context, listen: true).getSelectedDay(),
        ));
      }

      weekWidgets.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: dateWidgets,
      ));
    }

    return weekWidgets;
  }

  var weekDate = DateTimeExtensions.mostRecentMonday(DateTime.now());
  myFunc(DateTime date) {
    setState(() {
      weekDate = date;
    });
  }




  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController(
      initialScrollOffset: MediaQuery.of(context).size.width, // or whatever offset you wish
      keepScrollOffset: true,
    );
    var children = displayWeek(weekDate, myFunc);
    return ScrollablePositionedList.builder(
      padding: EdgeInsets.symmetric(horizontal: 5),
      initialScrollIndex: _index,
      itemScrollController: ItemScrollController(),
      scrollDirection: Axis.horizontal,
      physics: const PageScrollPhysics(), // this for snapping
      itemCount: children.length,
      itemBuilder: (_, index) => SizedBox(width: MediaQuery.of(context).size.width*0.95,child: children[index]),
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
      fontSize: MediaQuery.of(context).size.width *0.04,
    );
    TextStyle numStyle = TextStyle(
        color: date.isSameDate(DateTime.now())
            ? currentDayColor
            : (date.isBefore(DateTime.now()) ? beforeDayColor : afterDayColor),
        fontSize: MediaQuery.of(context).size.width * 0.05,
        fontWeight: FontWeight.bold);

    return Container(
      width: MediaQuery.of(context).size.width * 0.1,
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: selectedDate.isSameDate(date)
                ? kDarkGrey
                : Colors.transparent,
            width: 1),
      ),
      child: RawMaterialButton(
        onPressed: () {
          Provider.of<AppData>(context, listen: false)
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

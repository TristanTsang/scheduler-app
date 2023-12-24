import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Providers/JournalData.dart';
import '../constants.dart';
import '../models/journalEntry.dart';
import 'JournalTextScreen.dart';

class JournalsScreen extends StatefulWidget {
  const JournalsScreen({Key? key}) : super(key: key);

  @override
  State<JournalsScreen> createState() => _JournalsScreenState();
}

class _JournalsScreenState extends State<JournalsScreen> {
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.popAndPushNamed(context, "homeScreen");
    }
    if (index == 2) {
      Navigator.popAndPushNamed(context, 'analytics');
    }
  }

  List<Widget> buildJournalList(LinkedHashMap<DateTime, JournalEntry>? map) {
    var journalObjects = <Widget>[];
    map!.forEach((date, journalEntry) {
      var text = <Widget>[];
      journalObjects.add(Padding(
        padding: EdgeInsets.all(5),
        child: RawMaterialButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => JournalTextScreen(date: date, journal: Provider.of<JournalData>(context, listen: false)
                        .getJournal(date),)));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 5,
                        ),
                        SizedBox(
                          width: 25,
                        ),
                        Text(
                          "Journal Entry",
                          style: primaryHeader,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 35),
                      child: Text(
                        DateFormat.yMMMMd('en_US').format(date),
                        style: secondaryHeader.copyWith(color: kDarkGrey),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 35),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: text,
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ));
    });

    return journalObjects;
  }

  @override
  Widget build(BuildContext context) {
    var journalObjects = buildJournalList(Provider.of<JournalData>(context, listen: true).getSortedJournalMap());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      JournalTextScreen(date: DateTime.now(), journal: Provider.of<JournalData>(context, listen: false)
                          .getJournal(DateTime.now()),))).then((_) => setState(() {}));
        },
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(30),
        child: AppBar(
          titleSpacing: 0,
          leadingWidth: 45,
          title: Text("Your Journals", style: TextStyle(fontSize: 17.5),),
          leading: Icon(Icons.description),
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
      body: ListView(padding: EdgeInsets.zero, children: [
        Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height * 0.2,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Journals",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        journalObjects.length > 0
            ? Column(children: journalObjects)
            : Column(
                children: const [
                  Icon(Icons.light_mode, color: Colors.black, size: 60),
                  Text(
                    "No Existing Journals",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ]),
    );
  }
}

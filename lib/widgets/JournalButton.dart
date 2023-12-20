import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/extensions.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Providers/AppData.dart';
import '../Providers/JournalData.dart';
import '../screens/JournalTextScreen.dart';

class JournalButton extends StatelessWidget {
  const JournalButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: (){
        if( Provider.of<AppData>(context, listen: false).getSelectedDay().dateIsBefore(DateTime.now()) ||  Provider.of<AppData>(context, listen: false).getSelectedDay().isSameDate(DateTime.now())){
          Navigator.push(context, MaterialPageRoute(builder: (context) => JournalTextScreen(date: Provider.of<AppData>(context, listen: false).getSelectedDay(), journal: Provider.of<JournalData>(context, listen: false).getJournal(Provider.of<AppData>(context, listen: false).getSelectedDay()))));
        }

      },
      child: Container(
          decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(15)
          ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  (Provider.of<AppData>(context, listen: false).getSelectedDay().dateIsBefore(DateTime.now()) ||  Provider.of<AppData>(context, listen: false).getSelectedDay().isSameDate(DateTime.now()))?
      [Icon(Icons.book, size: 35, color: Colors.white), Text("Create Journal", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),)] : [Icon(Icons.lock, size: 20, color: Colors.white), SizedBox(width: 10), Text("Journal Unlocks On ${DateFormat.yMd().format(Provider.of<AppData>(context, listen: false).getSelectedDay())}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),)],
          ),
        ),
      ),
    );
  }
}


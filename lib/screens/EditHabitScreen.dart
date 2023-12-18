import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:improvement_journal/Services/sqlite_service.dart';
import 'package:provider/provider.dart';
import '../Providers/HabitData.dart';
import '../constants.dart';
import '../extensions.dart';
import '../models/habit.dart';


class EditHabitScreen extends StatefulWidget {
  Habit habit;
  EditHabitScreen({Key? key, required Habit this.habit}) : super(key: key);

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  String? text;
  int? duration;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller:
              TextEditingController(text: widget.habit.name),
              style: secondaryHeader,
              decoration: InputDecoration(
                  hintText: "Habit Name",
                  hintStyle: secondarySubtitle,
                  border: InputBorder.none),
              maxLines: 1,
              autofocus: true,
              onChanged: (value) {
                text = value;
              },
            ),
            TextField(
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              style: secondaryHeader,
              keyboardType: TextInputType.number,
              controller:
              TextEditingController(text: DateTimeExtensions.daysBetween(widget.habit.startDate, widget.habit.endDate).toString()),
              decoration: InputDecoration(
                  hintText: "Habit Duration (days)",
                  hintStyle: secondarySubtitle,
                  border: InputBorder.none),
              maxLines: 1,
              autofocus: true,
              onChanged: (value) {
                duration = int.parse(value);
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              children: [
                SizedBox(width: 10,),
                Expanded(
                  child: RawMaterialButton(
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.055,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.black,
                          ),
                          child: const Center(
                            child: Text(
                              "Delete Habit",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          )),
                      onPressed: () {
                          Provider.of<HabitData>(context, listen: false).removeHabit(widget.habit);
                          Navigator.pop(context);
                      }),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: RawMaterialButton(
                      child: Container(

                          height: MediaQuery.of(context).size.height * 0.055,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.black,
                          ),
                          child: const Center(
                            child: Text(
                              "Save",
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          )),
                      onPressed: () {
                        if(duration!= null && text !=null){
                          widget.habit.setName(text!);
                          widget.habit.setEndDate( widget.habit.startDate.add(Duration(days: duration!)));
                          SqliteService.updateHabit(widget.habit);
                          Provider.of<HabitData>(context, listen: false).updateHabit();
                          Navigator.pop(context);
                        }
                      }),
                ),
                SizedBox(width: 10,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
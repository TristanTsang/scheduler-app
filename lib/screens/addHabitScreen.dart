import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../Providers/AppData.dart';
import '../constants.dart';
import '../Providers/HabitData.dart';
import '../models/habit.dart';
import '../Providers/journalData.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  String? text;
  int? duration;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
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
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              style: secondaryHeader,
              keyboardType: TextInputType.number,
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
            RawMaterialButton(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.67,
                    height: MediaQuery.of(context).size.height * 0.055,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.black,
                    ),
                    child: const Center(
                      child: Text(
                        "Add Habit",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )),
                onPressed: () {
                  if (duration != null && text != null) {
                    Provider.of<HabitData>(context, listen: false)
                        .addHabit(Habit(
                      text!,
                      duration!,
                    ));
                    Navigator.pop(context);
                  }
                }),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/HabitData.dart';
import '../models/habit.dart';

class HabitWidget extends StatelessWidget {
  Habit habit;
  DateTime date;
  HabitWidget(this.habit, this.date,  {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 30,
          width: 30,
          child: Checkbox(value: Provider.of<HabitData>(context, listen: true).isTrue(date, habit), onChanged: (bool){
            Provider.of<HabitData>(context, listen: false).markHabitDate(date, habit);
          },
            activeColor: kDarkGrey,
          side: BorderSide(color: Colors.white, width: 1.5),
            shape: CircleBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        Text(habit.name, style: secondarySubtitle.copyWith(color: Colors.white)),
        Expanded(child: SizedBox()),
        Text("${habit.getStreak(date)}", style: TextStyle(color: Colors.white), )
      ],
    );
  }
}
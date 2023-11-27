import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/extensions.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../Providers/HabitData.dart';
import '../models/habit.dart';

class HabitWidget extends StatelessWidget {
  Habit habit;
  DateTime date;
  HabitWidget(this.habit, this.date, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 25,
          width: 25,
          child: Checkbox(
            value: habit.isDone(date),
            onChanged: (bool) {
              if(bool!){
                habit.addDate(date);
                Provider.of<HabitData>(context, listen: false).updateHabit();
              }else{
                habit.removeDate(date);
                Provider.of<HabitData>(context, listen: false).updateHabit();
              }
            },
            activeColor: kLightGrey,
            side: BorderSide(color: (!date.isSameDate(DateTime.now()))? kLightGrey:  Colors.white, width: 1),
            shape: CircleBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width*0.75),
          child: Text(habit.name,overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color:  (habit.isDone(date) || !date.isSameDate(DateTime.now()))? kLightGrey:  Colors.white,
                  fontSize: 15,
              decoration: habit.isDone(date)? TextDecoration.lineThrough : TextDecoration.none,
              decorationThickness: 2),),
        ),
        Expanded(child: SizedBox()),
        Text(
          "${habit.getStreak(date)}",
          style: TextStyle(color: (!date.isSameDate(DateTime.now()))? kLightGrey:  Colors.white),
        )
      ],
    );
  }
}

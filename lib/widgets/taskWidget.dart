import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/Services/sqlite_service.dart';
import 'package:improvement_journal/constants.dart';
import 'package:improvement_journal/extensions.dart';
import 'package:improvement_journal/widgets/tag.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Providers/AppData.dart';
import '../Providers/TaskData.dart';
import '../Providers/journalData.dart';
import '../models/task.dart';
import '../screens/editTaskScreen.dart';


class SimpleTaskWidget extends StatelessWidget {
  Task task;
  SimpleTaskWidget({required this.task}) {}

  @override
  Widget build(BuildContext context) {

    DateTime date = Provider.of<AppData>(context, listen:true).getSelectedDay();

    return Row(children: [
      SizedBox(
        height: 30,
        width: 30,
        child: Checkbox(
          side:MaterialStateBorderSide.resolveWith(
            (states) => BorderSide(width: 1.5, color: kDarkGrey)),
          activeColor: kDarkGrey,
          shape: CircleBorder(),
          value: task.done,
          onChanged: (bool? value) {
            task.toggleDone();
            SqliteService.updateTask(task,DateTimeExtensions.stringFormat( Provider.of<AppData>(context, listen: false).getSelectedDay()));
            Provider.of<TaskData>(context, listen: false).updateTaskList();
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      Expanded(
        child: RawMaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onLongPress: (){
            Provider.of<TaskData>(context, listen: false).getTaskList(date).removeTask(task);
            SqliteService.deleteTask(task);
            Provider.of<TaskData>(context, listen: false).updateTaskList();
          },
          constraints: BoxConstraints(),
          onPressed: (){
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return EditTaskScreen(task: task,);
                });
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(2.5),
              child: Column(
                mainAxisSize:MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.taskName,
                    style: TextStyle(
                        fontSize: smallFontSize,
                        fontWeight: FontWeight.bold,
                        color: task.done? kAccentColor: kPrimaryColor,
                    decoration: task.done? TextDecoration.lineThrough : TextDecoration.none,
                    decorationThickness: 2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

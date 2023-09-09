import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/constants.dart';
import 'package:improvement_journal/widgets/tag.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/journalData.dart';
import '../models/task.dart';
import '../screens/editTaskScreen.dart';

class TaskWidget extends StatelessWidget {
  Task task;
  TaskWidget({required this.task}) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              height: 20,
              width: 30,
              child: Checkbox(
                shape: CircleBorder(),
                value: task.done,
                onChanged: (bool? value) {
                  Provider.of<JournalData>(context, listen: false)
                      .toggleDone(task);
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )),
          Expanded(
            child: RawMaterialButton(

              onPressed: () {},
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.taskName,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    if (task.description != null) Text(task.description!),
                    if (task.dueDate != null ||
                        task.priority != null ||
                        task.label != null)
                      SizedBox(
                        height: 10,
                      ),
                    if (task.dueDate != null ||
                        task.priority != null ||
                        task.label != null)
                      Row(
                        children: [
                          if (task.dueDate != null)
                            Tag(
                                text:
                                    DateFormat('MMM d').format(task.dueDate!)),
                          if (task.priority != null) Tag(text: task.priority!),
                          if (task.label != null) Tag(text: task.label!),
                        ],
                      ),
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

class SimpleTaskWidget extends StatelessWidget {
  Task task;
  SimpleTaskWidget({required this.task}) {}

  @override
  Widget build(BuildContext context) {
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
            Provider.of<JournalData>(context, listen: false)
                .toggleDone(task);
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      Expanded(
        child: RawMaterialButton(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onLongPress: (){
            Provider.of<JournalData>(context, listen: false).removeTask(task);
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

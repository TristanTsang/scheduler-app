import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/journalData.dart';
import '../models/task.dart';

class EditTaskScreen extends StatefulWidget {
  Task task;
  EditTaskScreen({required this.task}) {}

  @override
  State<EditTaskScreen> createState() => EditTaskScreenState();
}

class EditTaskScreenState extends State<EditTaskScreen> {
  String? text;
  String? description;
  DateTime? selectedDate;
  String? taskPriority;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year, DateTime.now().month),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

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
            Align(alignment: Alignment.centerLeft, child: Text("Edit Task", style: secondaryHeader,)),
            Row(
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: Icon(Icons.check_box,color: kPrimaryColor, size:22.5)
                ),
                Expanded(
                  child: TextField(
                    controller:
                        TextEditingController(text: widget.task.taskName),
                    style: defaultStyle,
                    decoration: InputDecoration(
                        hintText: "Task Name",
                        labelStyle: TextStyle(fontSize: 1),
                        border: InputBorder.none),
                    maxLines: 1,
                    autofocus: true,
                    onChanged: (value) {
                      text = value;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 30, height: 30, child: Icon(Icons.list,color: kPrimaryColor,size:22.5)),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    controller:
                        TextEditingController(text: widget.task.description),
                    style: defaultStyle,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Task Description",
                        isDense: true),
                    autofocus: true,
                    onChanged: (value) {
                      description = value;
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                RawMaterialButton(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(selectedDate != null
                          ? DateFormat('MMM d').format(selectedDate!)
                          : "Select Date"),
                    ),
                    onPressed: () {
                      _selectDate(context);
                    }),
              ],
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
                      color: kPrimaryColor,
                    ),
                    child: Center(
                      child: Text(
                        "Save",
                        style: defaultStyle.copyWith(color: Colors.white),
                      ),
                    )),
                onPressed: () {
                  Provider.of<JournalData>(context, listen: false).addTask(Task(
                    taskName: text!,
                    dueDate: selectedDate,
                    description: description,
                  ));
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}



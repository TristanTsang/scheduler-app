import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Providers/AppData.dart';
import '../Providers/TaskData.dart';
import '../constants.dart';
import '../Providers/journalData.dart';
import '../models/task.dart';

const List<DropdownMenuItem<String>> list = <DropdownMenuItem<String>>[
  DropdownMenuItem(
    value: null,
    child: Text('No Priority'),
  ),
  DropdownMenuItem(
    value: "Priority 1",
    child: Text('Priority 1'),
  ),
  DropdownMenuItem(
    value: "Priority 2",
    child: Text('Priority 2'),
  ),
  DropdownMenuItem(
    value: "Priority 3",
    child: Text('Priority 3'),
  ),
];
const List<DropdownMenuItem<String>> labelMenu = <DropdownMenuItem<String>>[
  DropdownMenuItem(
    value: null,
    child: Text('No Label'),
  ),
  DropdownMenuItem(
    value: "School",
    child: Text('School'),
  ),
  DropdownMenuItem(
    value: "Work",
    child: Text('Work'),
  ),
  DropdownMenuItem(
    value: "Personal",
    child: Text('Personal'),
  ),
];

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String? text;
  String? description;
  DateTime? selectedDate;
  String? taskPriority;
  String? dropdownValue = list.first.value;
  String? labelValue = labelMenu.first.value;
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
    DateTime date = Provider.of<AppData>(context, listen: true).getSelectedDay();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: secondaryHeader,
              decoration: InputDecoration(
                  hintText: "Task Name",
                  hintStyle: secondarySubtitle,
                  border: InputBorder.none),
              maxLines: 1,
              autofocus: true,
              onChanged: (value) {
                text = value;
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
                    child: Center(
                      child: Text(
                        "Add Task",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )),
                onPressed: () {
                  if(text !=null){
                    Provider.of<TaskData>(context, listen: false).getTaskList(date).addTask(Task(
                      taskName: text!,));
                    Provider.of<TaskData>(context, listen: false).updateTaskList();
                    Navigator.pop(context);
                  }
                }),
          ],
        ),
      ),
    );
  }
}

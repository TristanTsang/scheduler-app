import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/journalData.dart';
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
            TextField(
              style: TextStyle(fontSize: 15),
              maxLines: 1,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Task Description",
                  isDense: true),
              autofocus: true,
              onChanged: (value) {
                description = value;
              },
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
                DropdownButton(
                    focusNode: FocusNode(canRequestFocus: false),
                    style: const TextStyle(color: Colors.deepPurple),
                    value: dropdownValue,
                    items: list,
                    onChanged: (value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    }),
                DropdownButton(
                    focusNode: FocusNode(canRequestFocus: false),
                    style: const TextStyle(color: Colors.deepPurple),
                    value: labelValue,
                    items: labelMenu,
                    onChanged: (value) {
                      setState(() {
                        labelValue = value!;
                      });
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
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        "Add Task",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    )),
                onPressed: () {
                  Provider.of<JournalData>(context, listen: false).addTask(Task(
                      taskName: text!,
                      dueDate: selectedDate,
                      description: description,
                      label: labelValue,
                      priority: dropdownValue));
                  Navigator.pop(context);
                }),
          ],
        ),
      ),
    );
  }
}

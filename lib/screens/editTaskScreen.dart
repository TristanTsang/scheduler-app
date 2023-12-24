import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/Providers/AppData.dart';
import 'package:provider/provider.dart';
import '../Providers/TaskData.dart';
import '../Services/sqlite_service.dart';
import '../constants.dart';
import '../extensions.dart';
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
    text = widget.task.taskName;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Edit Task",
                  style: secondaryHeader,
                )),
            Row(
              children: [
                SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(Icons.check_box,
                        color: kPrimaryColor, size: 22.5)),
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              children: [
                Expanded(
                  child: RawMaterialButton(
                    onPressed: () {
                      Provider.of<TaskData>(context, listen: false)
                          .getTaskList(
                              Provider.of<AppData>(context, listen: false)
                                  .getSelectedDay())
                          .removeTask(widget.task);
                      SqliteService.deleteTask(widget.task);
                      Provider.of<TaskData>(context, listen: false)
                          .updateTaskList();
                      Navigator.pop(context);
                    },
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.055,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.black,
                        ),
                        child: const Center(
                          child: Text(
                            "Delete Task",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        )),
                  ),
                ),
                SizedBox(width: 15,),
                Expanded(
                  child: RawMaterialButton(
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
                        if (text != null) {
                          widget.task.setName(text!);
                          SqliteService.updateTask(
                              widget.task,
                              DateTimeExtensions.stringFormat(
                                  Provider.of<AppData>(context, listen: false)
                                      .getSelectedDay()));
                          Provider.of<TaskData>(context, listen: false)
                              .updateTaskList();
                          Navigator.pop(context);
                        }
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

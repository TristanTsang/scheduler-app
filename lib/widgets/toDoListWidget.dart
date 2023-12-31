import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:improvement_journal/widgets/taskWidget.dart';
import 'package:provider/provider.dart';
import '../Providers/AppData.dart';
import '../Providers/TaskData.dart';
import '../constants.dart';
import '../models/TaskList.dart';
import '../models/task.dart';
import '../screens/addTaskScreen.dart';

class toDoListWidget extends StatelessWidget {
  const toDoListWidget({Key? key}) : super(key: key);

  List<Widget> addTaskWidgets(List<Task> tasks) {
    List<Widget> widgets = [];
    for (int i = 0; i < tasks.length; i++) {
      widgets.add(SimpleTaskWidget(task: tasks[i]));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = Provider.of<AppData>(context, listen: true).getSelectedDay();
    TaskList taskList =
        Provider.of<TaskData>(context, listen: true).getTaskList(date);
    List<Widget> list = addTaskWidgets(taskList.getTasks());
    return Material(
      elevation: 2,
        borderRadius: BorderRadius.circular(10),

      child: Container(
        height: MediaQuery.of(context).size.height * 0.33,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 20, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today's Tasks:",
                          style: secondaryHeader,),
                      ],
                    ),

                    Text(
                    taskList.getLength()>0?"You have completed ${taskList.numCompletedTasks()}/${taskList.getLength()} tasks." : "No tasks scheduled.",
                      style: secondarySubtitle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                  child: Stack(children: [
                    ListView(
                      physics: list.isEmpty? const NeverScrollableScrollPhysics() : const ScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: list,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        shape: CircleBorder(),
                        heroTag: "taskButton",
                        child: Icon(Icons.add, color: Colors.white),
                        mini: true,
                        backgroundColor: kPrimaryColor,
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return AddTaskScreen();
                              });
                        },
                      ),
                    )
                  ]),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

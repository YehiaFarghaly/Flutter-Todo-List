import 'package:flutter/material.dart';
import 'package:todo_list/Modules/components/Common_Variables.dart';
import 'package:todo_list/Modules/components/Task_Widget.dart';

class NewTasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return ListView.separated(itemBuilder: (context,index) => buildTaskItem(tasks[index]),
        separatorBuilder: (context,index) => Container(
          width: double.infinity,
          height: 2,
          color: Colors.brown[300],
        ),
        itemCount: tasks.length);
  }
}

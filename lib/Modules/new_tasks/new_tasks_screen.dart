import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/Modules/components/Task_Widget.dart';
import 'package:todo_list/Modules/components/cubit/cubit.dart';
import 'package:todo_list/Modules/components/cubit/states.dart';

class NewTasksScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit,TasksStates>(

      listener: ( context, state) {  },
      builder:(context, state){
        var tasks = TasksCubit.get(context).tasks!!;
        return Container(
          color: Colors.brown[200],
          child: ListView.separated(itemBuilder: (context,index) => buildTaskItem(tasks[index]),
              separatorBuilder: (context,index) => Container(
                width: double.infinity,
                height: 2,
                color: Colors.brown[300],
              ),
              itemCount: tasks.length),
        );
      }
    );
  }
}

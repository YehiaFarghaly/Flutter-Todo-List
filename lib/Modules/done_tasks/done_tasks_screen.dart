import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/Task_Widget.dart';
import '../components/cubit/cubit.dart';
import '../components/cubit/states.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TasksCubit,TasksStates>(

        listener: ( context, state) {  },
        builder:(context, state){
          var tasks = TasksCubit.get(context).doneTasks!!;
          return Container(
            color: Colors.brown[200],
            child: ListView.separated(itemBuilder: (context,index) => buildTaskItem(tasks[index],context),
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

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/Modules/components/cubit/states.dart';

import '../../archived_tasks/archived_tasks_screen.dart';
import '../../done_tasks/done_tasks_screen.dart';
import '../../new_tasks/new_tasks_screen.dart';

class TasksCubit extends Cubit<TasksStates>{
  TasksCubit() : super(InitTaskState());

  static TasksCubit get(context) => BlocProvider.of(context);
  int currentIdx = 0;
  List<Widget> screens = [
    NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen()
  ];
  List<String> titles = ['My Tasks', 'Done Tasks', 'Archived Tasks'];

  void changeIndex(int index){
    currentIdx = index;
    emit(BottomNavChangeState());
  }
}
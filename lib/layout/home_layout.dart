import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/Modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_list/Modules/components/Text_Form_Field.dart';
import 'package:todo_list/Modules/components/cubit/cubit.dart';
import 'package:todo_list/Modules/components/cubit/states.dart';
import 'package:todo_list/Modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_list/Modules/new_tasks/new_tasks_screen.dart';


class HomeLayout extends StatelessWidget {


  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var statusController = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TasksCubit()..createDatabase(),
      child: BlocConsumer<TasksCubit, TasksStates>(
        listener:(context,state){
          if(state is InsertToDatabaseState) Navigator.pop(context);
        } ,
        builder:(context,state){
          TasksCubit cubit = TasksCubit.get(context);
          return  Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.brown,
              title: Text(
                cubit.titles[cubit.currentIdx],
              ),
            ),
            floatingActionButton: cubit.currentIdx == 0
                ? FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheet) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(title:titleController.text, date:dateController.text,
                        time:timeController.text);
                    titleController.text = '';
                    dateController.text='';
                    timeController.text='';
                  }
                } else {
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) =>
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  color: Colors.grey[300],
                                  child: defaultFormField(
                                      controller: titleController,
                                      type: TextInputType.text,
                                      validate: (String? value) {
                                        if (value == null || value.length == 0)
                                          return 'Task can not be empty';
                                      },
                                      label: 'Task',
                                      prefixIcon: Icons.title),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: Colors.grey[300],
                                  child: defaultFormField(
                                      controller: timeController,
                                      type: TextInputType.datetime,
                                      validate: (String? value) {
                                        if (value == null || value.length == 0)
                                          return 'Time can not be empty';
                                      },
                                      label: 'Time',
                                      prefixIcon: Icons.timer,
                                      onTap: () {
                                        showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                            .then((value) {
                                          timeController.text = (value == null
                                              ? '00:00'
                                              : value
                                              ?.format(context)
                                              .toString())!;
                                        });
                                      }),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  color: Colors.grey[300],
                                  child: defaultFormField(
                                    controller: dateController,
                                    type: TextInputType.datetime,
                                    validate: (String? value) {
                                      if (value == null || value.length == 0)
                                        return 'Date can not be empty';
                                    },
                                    label: 'Date',
                                    prefixIcon: Icons.calendar_month,
                                    onTap: () {
                                      showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.parse(DateTime(
                                              DateTime.now().year + 1,
                                              DateTime.now().month,
                                              DateTime.now().day)
                                              .toString()))
                                          .then((value) {
                                          dateController.text =
                                              DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    elevation: 20,
                  ).closed.then((value)  {
                    cubit.changeBottomSheetState(false, Icon(Icons.edit));

                  });
                 cubit.changeBottomSheetState(true, Icon(Icons.add_task));

                }
              },
              backgroundColor: Colors.brown,
              child: cubit.fabIcon,
            )
                : null,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.brown[400],
              selectedItemColor: Colors.white,
              currentIndex: cubit.currentIdx,
              onTap: (index) {
                cubit.changeIndex(index);

                  if (cubit.currentIdx != 0 && cubit.isBottomSheet) {
                    Navigator.pop(context);
                    cubit.changeBottomSheetState(false, Icon(Icons.edit));
                  }

              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
              ],
            ),
            body: cubit.screens[cubit.currentIdx],
          );
        },
      ),
    );
  }



}



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

import '../Modules/components/Common_Variables.dart';

class HomeLayout extends StatelessWidget {

  late Database db;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();
  var statusController = TextEditingController();
  bool isBottomSheet = false;
  Icon fabIcon = Icon(Icons.edit);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    TasksCubit cubit = TasksCubit.get(context);
    return BlocProvider(
      create: (context) => TasksCubit(),
      child: BlocConsumer<TasksCubit, TasksStates>(
        listener:(context,state){} ,
        builder:(context,state){
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
                if (isBottomSheet) {
                  if (formKey.currentState!.validate()) {
                    insertToDatabase(title:titleController.text, date:dateController.text,
                        time:timeController.text).then((value) {
                      getDataFromDatabase(db).then((value){
                        Navigator.pop(context);
                        isBottomSheet = false;
                        // setState(() {
                        //   fabIcon = const Icon(Icons.edit);
                        //   tasks = value;
                        // });

                      });

                    });
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
                                        // setState(() {
                                        //   dateController.text =
                                        //       DateFormat.yMMMd().format(value!);
                                        // });
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
                    isBottomSheet = false;
                    // setState(() {
                    //   fabIcon = const Icon(Icons.edit);
                    // });
                  });
                  isBottomSheet = true;
                  // setState(() {
                  //   fabIcon = Icon(Icons.add_task);
                  // });
                }
              },
              backgroundColor: Colors.brown,
              child: fabIcon,
            )
                : null,
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.brown[400],
              selectedItemColor: Colors.white,
              currentIndex: cubit.currentIdx,
              onTap: (index) {
                cubit.changeIndex(index);
                // setState(() {
                //   currentIdx = index;
                //   if (currentIdx != 0 && isBottomSheet) {
                //     Navigator.pop(context);
                //     isBottomSheet = false;
                //   }
                // });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
                BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
                BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
              ],
            ),
            body: tasks.length==0? Center(child: CircularProgressIndicator()) :cubit.screens[cubit.currentIdx],
          );
        },
      ),
    );
  }

  void createDatabase() async {
    try {
      db = await openDatabase('Todo.db', version: 1,
          onCreate: (database, version) async {
            await database.execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT, time TEXT, status TEXT)');
          }, onOpen: (database) {

            getDataFromDatabase(database).then((value) {

              // setState(() {
              //   tasks = value;
              // });
            });
          });
    } on Error {
      print('Error on creating database');
    }
  }

  Future insertToDatabase({required title,required date,required time}) async {
    return await db.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO tasks(title, date , time , status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
      }).catchError((error) {
        print("Error while inserting into the table ${error.toString()}");
      });
    });
  }
  Future<List<Map>> getDataFromDatabase(Database database) async {
    List<Map> tasks = await database.rawQuery('SELECT * FROM tasks');
    return tasks;
  }

}



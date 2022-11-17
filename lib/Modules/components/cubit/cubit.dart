import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/Modules/components/cubit/states.dart';

import '../../archived_tasks/archived_tasks_screen.dart';
import '../../done_tasks/done_tasks_screen.dart';
import '../../new_tasks/new_tasks_screen.dart';

class TasksCubit extends Cubit<TasksStates>{
  TasksCubit() : super(InitTaskState());
  late Database db;
  List<Map> tasks=[];
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

  void createDatabase()  {
    try {
      db =  openDatabase('Todo.db', version: 1,
          onCreate: (database, version)  {
             database.execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT, time TEXT, status TEXT)');
          }, onOpen: (database) {

            getDataFromDatabase(database).then((value) {
                 tasks = value;
                 emit(GetFromDatabase());
            });
          }).then((value) {
            db = value;
            emit(CreateDatabaseState());
      }) as Database;
    } on Error {
      print('Error on creating database');
    }
  }

   insertToDatabase({required title,required date,required time}) async {
     await db.transaction((txn) async {
      txn
          .rawInsert(
          'INSERT INTO tasks(title, date , time , status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        Fluttertoast.showToast(
          msg:'Task added',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black,
          textColor: Colors.white,
        );
        emit(InsertToDatabaseState());

        getDataFromDatabase(db).then((value) {
          tasks = value;
          emit(GetFromDatabase());
        });
      }).catchError((error) {
        print("Error while inserting into the table ${error.toString()}");
      });
    });
  }
  Future<List<Map>> getDataFromDatabase(Database database) async {
    List<Map> tasks = await database.rawQuery('SELECT * FROM tasks');
    return tasks;
  }

  bool isBottomSheet = false;
  Icon fabIcon = Icon(Icons.edit);
  void changeBottomSheetState(bool isShown, Icon icon){
    isBottomSheet = isShown;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }
}
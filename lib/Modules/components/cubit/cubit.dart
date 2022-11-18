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
  List<Map> newTasks=[];
  List<Map> doneTasks=[];
  List<Map> archivedTasks=[];
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

            getDataFromDatabase(database);
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
        getDataFromDatabase(db);
      }).catchError((error) {
        print("Error while inserting into the table ${error.toString()}");
      });
    });
  }
  void getDataFromDatabase(Database database)  {
    newTasks=[];
    doneTasks=[];
    archivedTasks=[];
      database.rawQuery('SELECT * FROM tasks').then((value) {
        value.forEach((element) {
          if(element['status']=='new'){
            newTasks.add(element);
          }
          else if(element['status']=='done'){
            doneTasks.add(element);
          }
          else archivedTasks.add(element);
        });
        emit(GetFromDatabase());
      });

  }
  void updateDatabase(String status,int id) async{
     db.rawUpdate('UPDATE Tasks SET status = ? WHERE id = ?',
    [status, '$id'],
    ).then((value) {
       getDataFromDatabase(db);
       emit(UpdateDatabaseState());
     });
  }

  void deleteFromDatabase(int id){
    db.rawDelete('DELETE FROM Tasks WHERE id = $id ').then((value) {
      getDataFromDatabase(db);
      emit(DeleteFromDatabaseState());
    });
  }

  bool isBottomSheet = false;
  Icon fabIcon = Icon(Icons.edit);
  void changeBottomSheetState(bool isShown, Icon icon){
    isBottomSheet = isShown;
    fabIcon = icon;
    emit(ChangeBottomSheetState());
  }
}
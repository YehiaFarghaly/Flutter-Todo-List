import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list/Modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_list/Modules/components/Text_Form_Field.dart';
import 'package:todo_list/Modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_list/Modules/new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIdx = 0;
  late Database db;
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  bool isBottomSheet = false;
  Icon fabIcon = Icon(Icons.edit);
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Widget> screens = [
    NewTasksScreen(),
    const DoneTasksScreen(),
    ArchivedTasksScreen()
  ];
  List<String> titles = ['My Tasks', 'Done Tasks', 'Archived Tasks'];
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
     createDatabase();
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          titles[currentIdx],
        ),
      ),
      floatingActionButton: currentIdx == 0
          ? FloatingActionButton(
              onPressed: () {
                if(isBottomSheet){
                  Navigator.pop(context);
                  isBottomSheet = false;
                  setState(() {
                    fabIcon = const Icon(Icons.edit);
                  });
                }
                else {
                  scaffoldKey.currentState?.showBottomSheet((context) =>
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          Container(
                            color: Colors.grey[300] ,
                            child: defaultFormField(
                                controller: titleController,
                                type: TextInputType.text,
                                validate: (String? value){
                                    if (value == null || value.length==0)
                                      return 'Title can not be empty';
                                  },
                                label: 'Title',
                                prefixIcon: Icons.title
                            ),
                          ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              color: Colors.grey[300],
                              child: defaultFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  validate: (String? value){
                                    if (value == null || value.length==0)
                                      return 'Time can not be empty';
                                  },
                                  label: 'Time',
                                  prefixIcon: Icons.timer,
                                onTap: (){
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now()
                                    ).then((value) {
                                      timeController.text = (value==null? '00:00':value?.format(context).toString())!;
                                    }
                                    );
                                }
                              ),
                            ),
                          ],
                        ),
                      ));
                  isBottomSheet = true;
                  setState(() {
                    fabIcon = Icon(Icons.add_task);
                  });
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
        currentIndex: currentIdx,
        onTap: (index) {
          setState(() {
            currentIdx = index;
            if(currentIdx!=0 && isBottomSheet) {
              Navigator.pop(context);
              isBottomSheet = false;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Done'),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
        ],
      ),
      body: screens[currentIdx],
    );
  }

  void createDatabase() async {
    try {
       db = await openDatabase('Todo.db', version: 1,
          onCreate: (database, version) async {
            await database.execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY,title TEXT,date TEXT, time TEXT, status TEXT)');
          }, onOpen: (database) {});
    }
    on Error{
      print('Error on creating database');
    }
  }

  void insertToDatabase(title,date,time,status){
   db.transaction((txn) async {
     txn.rawInsert('INSERT INTO tasks(title, date , time , status) VALUES($title,$date,$time,$status)').then((value) {

     }).catchError(
             (error)
             {
               print("Error while inserting into the table ${error.toString()}");
             });


   });
  }

}

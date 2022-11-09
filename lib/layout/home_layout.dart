import 'package:flutter/material.dart';
import 'package:todo_list/Modules/archived_tasks/archived_tasks_screen.dart';
import 'package:todo_list/Modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_list/Modules/new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIdx = 0;
  List<Widget> screens = [NewTasksScreen(),DoneTasksScreen(),ArchivedTasksScreen()];
  List<String> titles = ['My Tasks','Done Tasks', 'Archived Tasks'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title:  Text(
          titles[currentIdx],
        ),
      ),
      floatingActionButton: currentIdx==0? FloatingActionButton(
        onPressed: (){},
        backgroundColor: Colors.brown,
        child: const Icon(
          Icons.add_task,
        ),
      ):null,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.brown[400],
        selectedItemColor: Colors.white,
        currentIndex: currentIdx,
        onTap: (index){
          setState(()
          {
            currentIdx = index;
          }
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.task
            ),
            label: 'Tasks'
          ),
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.done
              ),
              label: 'Done'
          ),
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.archive
              ),
              label: 'Archived'
          ),
        ],
      ),
      body:  screens[currentIdx],
    );
  }
}

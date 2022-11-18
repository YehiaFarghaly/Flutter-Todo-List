
import 'package:flutter/material.dart';
import 'package:todo_list/Modules/components/cubit/cubit.dart';

Widget buildTaskItem(Map tasksList,context) => Dismissible(
  key: Key(tasksList['id'].toString()),
  child:   Container(
  
    color: Colors.black54,
  
    child:   Padding(
  
      padding: const EdgeInsets.all(20.0),
  
      child: Row(
  
        children: [
  
           Container(
  
             child: CircleAvatar(
  
              radius: 35,
  
              backgroundColor: Colors.amber,
  
              child: Text('${tasksList['time']}',
  
              style: TextStyle(
  
                color: Colors.black,
  
                fontWeight: FontWeight.bold,
  
              ),
  
              ),
  
          ),
  
           ),
  
          const SizedBox(
  
            width: 20,
  
          ),
  
          Expanded(
  
            child: Column(
  
              mainAxisSize: MainAxisSize.min,
  
              crossAxisAlignment: CrossAxisAlignment.start,
  
              children: [
  
                Text('${tasksList['title']}',
  
                  style: TextStyle(
  
                    fontSize: 18,
  
                    fontWeight: FontWeight.bold,
  
                    color: Colors.amber[800],
  
                  ),
  
                ),
  
                Text('${tasksList['date']}',
  
                  style: TextStyle(
  
                      color: Colors.white,
  
                  ),
  
                )
  
              ],
  
            ),
  
          ),
  
          const SizedBox(
  
            width: 20,
  
          ),
  
          IconButton(
  
              onPressed:tasksList['status']=='done'?(){
  
                TasksCubit.get(context).updateDatabase('new', tasksList['id']);
  
              }: (){
  
             TasksCubit.get(context).updateDatabase('done', tasksList['id']);
  
              },
  
              icon: Icon(
  
                tasksList['status']=='done'?Icons.unpublished_rounded:Icons.check_box,
  
                color: Colors.green,
  
              )
  
          ),
  
          IconButton(
  
              onPressed: tasksList['status']=='archived'? (){
  
                TasksCubit.get(context).updateDatabase('new', tasksList['id']);
  
              }: (){
  
                TasksCubit.get(context).updateDatabase('archived', tasksList['id']);
  
              },
  
              icon:
  
              Icon(
  
                tasksList['status']=='archived'?Icons.unarchive:Icons.archive,
  
                color: Colors.deepOrangeAccent,
  
              )
  
          ),
  
        ],
  
      ),
  
    ),
  
  ),
  onDismissed: (direction){
    TasksCubit.get(context).deleteFromDatabase(tasksList['id']);
  },
  background: Container(
    color: Colors.red,
    child:Icon(Icons.delete)
  ),
);
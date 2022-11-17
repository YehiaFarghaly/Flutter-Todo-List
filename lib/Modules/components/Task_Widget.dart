
import 'package:flutter/material.dart';

Widget buildTaskItem(Map tasksList) => Container(
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
        Column(
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
        )
      ],
    ),
  ),
);
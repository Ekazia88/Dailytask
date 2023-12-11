import 'package:dailytask_app/DetailTask.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to the Home Page!',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to DailyTaskPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DailyTaskPage()),
                );
              },
              child: Text('Go to Daily Tasks'),
              
            ),
          ],
        ),
      ),
    );
  }
}
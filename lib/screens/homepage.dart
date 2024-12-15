import 'package:fab/compenents/calender.dart';
import 'package:fab/compenents/custombutton.dart';
import 'package:fab/compenents/dailycoaching.dart';
import 'package:fab/compenents/routines.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Your Keystone Routines"),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CustomButton(
                      URL: "assets/images/RoutinesList.png",
                      routineName: "Morning",
                    ),
                    CustomButton(
                      URL: "assets/images/RoutinesList.png",
                      routineName: "Afternoon",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 244, 234, 234)),
                  child: Calendar()),
              SizedBox(
                height: 40,
              ),
              Text("Your Routines"),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Today"),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('${DateTime.now().hour}:${DateTime.now().minute}'),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Routines(
                        routine: "Wake Up Routine",
                        url: "assets/images/RoutinesList.png"),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(Icons.edit_calendar_rounded),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Someday"),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 50),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Routines(
                          routine: "Work Day  Routine",
                          url: "assets/images/sample2.jpg"),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Routines(
                          routine: "Bedtime Routine",
                          url: "assets/images/sample.jpg"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text("Your Daily Coachings"),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    DailyCoaching(
                      text: 'Daily Coaching',
                      caption: 'Get daily coaching to help you stay on track',
                      url: 'assets/images/sample.jpg',
                    ),
                    DailyCoaching(
                        text: 'Motivational Coaching',
                        caption: 'Get daily coaching to help you stay on track',
                        url: 'assets/images/sample2.jpg'),
                    DailyCoaching(
                        text: 'Motivational Coaching',
                        caption: 'Get daily coaching to help you stay on track',
                        url: 'assets/images/sample3.jpg'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

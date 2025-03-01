import 'package:fab/components/challenges/challengesgridtile.dart';

import 'package:fab/components/challenges/joinchallenge/joinchallenge.dart';
import 'package:fab/components/challenges/joinchallenge/joinchallengetile.dart';
import 'package:fab/screens/challenges/challengerevealscreen.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Challengesscreen extends StatefulWidget {
  const Challengesscreen({super.key});

  @override
  State<Challengesscreen> createState() => _ChallengesscreenState();
}

class _ChallengesscreenState extends State<Challengesscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Challenge',
            style: TextStyle(
                fontSize: 26,
                color: Color.fromARGB(255, 15, 138, 138),
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Host",
                style: TextStyle(
                  color: const Color.fromARGB(255, 15, 138, 138),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 40,
                child: Divider(
                  height: 10,
                  thickness: 4,
                  color: const Color.fromARGB(255, 15, 138, 138),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Challengesgridtile(
                  url: 'assets/images/login.jpg',
                  title: 'Host Your Own Live Challenge',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 186,
                    child: Divider(
                      height: 10,
                      thickness: 2,
                      color: const Color.fromARGB(255, 15, 138, 138),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "or",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 15, 138, 138),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 186,
                    child: Divider(
                      height: 10,
                      thickness: 2,
                      color: const Color.fromARGB(255, 15, 138, 138),
                    ),
                  ),
                ],
              ),
              Text(
                "Join",
                style: TextStyle(
                  color: const Color.fromARGB(255, 15, 138, 138),
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 30,
                child: Divider(
                  height: 10,
                  thickness: 4,
                  color: const Color.fromARGB(255, 15, 138, 138),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20),
                child: JoinchallengeHeader(title: "Mediation Challenge"),
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Joinchallengetile(
                        url: 'assets/images/login.jpg',
                        title: 'Join Challenge',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Challengerevealscreen(),
                            ),
                          );
                        },
                      ),
                    ),
                    Joinchallengetile(
                      url: 'assets/images/sample.jpg',
                      title: 'Join Challenge',
                    ),
                    Joinchallengetile(
                      url: 'assets/images/sample2.jpg',
                      title: 'Join Challenge',
                    ),
                    Joinchallengetile(
                      url: 'assets/images/sample3.jpg',
                      title: 'Join Challenge',
                    ),
                    Joinchallengetile(
                      url: 'assets/images/login.jpg',
                      title: 'Join Challenge',
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.only(left: 20),
                child: JoinchallengeHeader(title: "Mediation Challenge"),
              ),
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Joinchallengetile(
                        url: 'assets/images/login.jpg',
                        title: 'Join Challenge',
                      ),
                    ),
                    Joinchallengetile(
                      url: 'assets/images/sample.jpg',
                      title: 'Join Challenge',
                    ),
                    Joinchallengetile(
                      url: 'assets/images/sample2.jpg',
                      title: 'Join Challenge',
                    ),
                    Joinchallengetile(
                      url: 'assets/images/sample3.jpg',
                      title: 'Join Challenge',
                    ),
                    Joinchallengetile(
                      url: 'assets/images/login.jpg',
                      title: 'Join Challenge',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Container(
                    height: 400,
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        Image.asset('assets/images/sample3.jpg', height: 150),
                        SizedBox(height: 10),
                        Text(
                          'Rolling the dice randomly selects a challenge for you, Do you want to continue?',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin: EdgeInsets.only(left: 60),
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Nope',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 156, 149, 149),
                                      fontSize: 20),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Yes, let\'s do this',
                                  style: TextStyle(
                                      color: const Color.fromARGB(
                                          255, 36, 173, 173),
                                      fontSize: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          backgroundColor: const Color.fromARGB(255, 254, 254, 254),
          child: FaIcon(
            FontAwesomeIcons.diceD6,
            color: const Color.fromARGB(255, 36, 173, 173),
          ),
        ));
  }
}

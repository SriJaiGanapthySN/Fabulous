import 'package:fab/screens/audio.dart';
import 'package:fab/firebase_options.dart';
import 'package:fab/screens/challengerevealscreen.dart';

import 'package:fab/screens/challengesscreen.dart';
import 'package:fab/screens/discoverscreen.dart';
import 'package:fab/screens/guidedcoachingmenu.dart';
import 'package:fab/screens/guidedcoachingrevealscreen.dart';
import 'package:fab/screens/guidedcoachingsecondlevel.dart';
import 'package:fab/screens/homepage.dart';
import 'package:fab/screens/journeyscreen.dart';
import 'package:fab/screens/journeyscreenrevealtype1.dart';
import 'package:fab/screens/journeyscreenrevealtype2.dart';
import 'package:fab/screens/journeyscreentype3.dart';
import 'package:fab/screens/journeysecondlevel.dart';
import 'package:fab/screens/logingupinterfacescreen.dart';
import 'package:fab/screens/notesscreen.dart';
import 'package:fab/screens/routinelistscreen.dart';
import 'package:fab/screens/taskreveal.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!),
        debugShowCheckedModeBanner: false,
        // home: Discoverscreen());
        home:  Logingupinterfacescreen());
  }
}

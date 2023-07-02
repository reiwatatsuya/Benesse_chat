import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'chat_room.dart';
import 'firebase_options.dart';
import 'register_page.dart';
import 'room_list_mentor_page.dart';
import 'room_list_student_page.dart';
import 'add_room_page.dart';
import 'login_page.dart';
import 'select_page.dart';
import 'users.dart';

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
    return MaterialApp(home: LoginPage(), routes: <String, WidgetBuilder>{
      '/select': (BuildContext context) => new SelectPage(),
      '/login': (BuildContext context) => new LoginPage(),
      '/register': (BuildContext context) => new RegisterPage(
          userType: ModalRoute.of(context)!.settings.arguments as String),
      '/roomStudentList': (BuildContext context) => new RoomListStudentPage(
          userInfo: ModalRoute.of(context)!.settings.arguments as Users),
      '/roomMentorList': (BuildContext context) => new RoomListMentorPage(
          userInfo: ModalRoute.of(context)!.settings.arguments as Users),
      '/chatRoom': (BuildContext context) => new ChatRoom(
            arg: ModalRoute.of(context)!.settings.arguments as List<dynamic>,
          ),
      '/addRoom': (BuildContext context) => new AddRoomPage(
          userInfo: ModalRoute.of(context)!.settings.arguments as Users),
    });
  }
}

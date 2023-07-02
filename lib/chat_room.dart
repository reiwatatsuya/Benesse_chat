import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'users.dart';

String randomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

class ChatRoom extends StatefulWidget {
  final List<dynamic> arg;
  const ChatRoom({super.key, required this.arg});

  @override
  ChatRoomState createState() => ChatRoomState();
}

class ChatRoomState extends State<ChatRoom> {
  List<types.Message> _messages = [];
  late String name;
  late Users userInfo;
  late types.User _user;

  void initState() {
    _getUser();
    _getMessages();
    super.initState();
  }

  void _getUser() async {
    name = widget.arg[0];
    userInfo = widget.arg[1];
    _user = types.User(id: userInfo.id);
  }

  void _getMessages() async {
    final getData = await FirebaseFirestore.instance
        .collection('chat_room')
        .doc(name)
        .collection('contents')
        .orderBy('createdAt', descending: true)
        .get();

    final message = getData.docs
        .map((d) => types.TextMessage(
            author:
                types.User(id: d.data()['uid'], firstName: d.data()['name']),
            createdAt: d.data()['createdAt'],
            id: d.data()['id'],
            text: d.data()['text']))
        .toList();

    setState(() {
      _messages = [...message];
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("チャットルーム"),
        ),
        body: Chat(
          user: _user,
          messages: _messages,
          onSendPressed: _handleSendPressed,
        ),
      );

  void _addMessage(types.TextMessage message) async {
    setState(() {
      _messages.insert(0, message);
    });

    await FirebaseFirestore.instance
        .collection('chat_room')
        .doc(name)
        .collection('contents')
        .add({
      'uid': message.author.id,
      'name': message.author.firstName,
      'createdAt': message.createdAt,
      'id': message.id,
      'text': message.text,
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: randomString(),
      text: message.text,
    );
    _addMessage(textMessage);
  }
}

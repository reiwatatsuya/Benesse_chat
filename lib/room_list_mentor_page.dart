import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_room.dart';
import 'add_room_page.dart';
import 'users.dart';

class RoomListMentorPage extends StatefulWidget {
  final Users userInfo;
  RoomListMentorPage({super.key, required this.userInfo});

  @override
  _RoomListMentorPage createState() => _RoomListMentorPage();
}

class _RoomListMentorPage extends State<RoomListMentorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('お悩み一覧'),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat_room')
              //.where('school', isEqualTo: widget.userInfo.school)
              .orderBy('createdAt')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Text('読込中……'),
              );
            } else if (snapshot.hasData) {
              final List<DocumentSnapshot> _documents = snapshot.data!.docs;
              final List<DocumentSnapshot> documents = [];
              for (int i = 0; i < _documents.length; i++) {
                if (_documents[i]['school'] == widget.userInfo.school) {
                  documents.add(_documents[i]);
                }
              }
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(documents[index]['name']),
                        trailing: IconButton(
                          icon: Icon(Icons.input),
                          onPressed: () async {
                            await Navigator.of(context).pushNamed(
                              "/chatRoom",
                              arguments: [
                                documents[index]['name'],
                                widget.userInfo
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: Text('なし'),
              );
            }
          },
        ),
      ),
    );
  }
}

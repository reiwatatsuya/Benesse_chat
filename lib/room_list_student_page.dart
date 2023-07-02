import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_room.dart';
import 'add_room_page.dart';
import 'users.dart';

class RoomListStudentPage extends StatefulWidget {
  final Users userInfo;
  RoomListStudentPage({super.key, required this.userInfo});

  @override
  _RoomListStudentPage createState() => _RoomListStudentPage();
}

class _RoomListStudentPage extends State<RoomListStudentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('一覧 ' + widget.userInfo.name),
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chat_room')
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
                if (_documents[i]['studentID'] == widget.userInfo.id) {
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context)
              .pushNamed("/addRoom", arguments: widget.userInfo);
        },
      ),
    );
  }
}

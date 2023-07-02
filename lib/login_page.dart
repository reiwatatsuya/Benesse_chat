import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'users.dart';

class LoginPage extends StatefulWidget {
  LoginPage();

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  // 入力されたメールアドレス
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
  // 入力されたメールアドレス（ログイン）
  String loginUserEmail = "";
  // 入力されたパスワード（ログイン）
  String loginUserPassword = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 32),
              TextFormField(
                decoration: InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  setState(() {
                    loginUserEmail = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード"),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    loginUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでログイン
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.signInWithEmailAndPassword(
                      email: loginUserEmail,
                      password: loginUserPassword,
                    );
                    // ログインに成功した場合
                    final User user = result.user!;
                    var loginUser = await FirebaseFirestore.instance
                        .collection('users') // コレクションID.
                        .doc(user.uid)
                        .get();
                    Users userInfo = Users();
                    userInfo.email = loginUser['email'];
                    userInfo.id = user.uid;
                    userInfo.name = loginUser['name'];
                    userInfo.password = loginUser['password'];
                    userInfo.userType = loginUser['userType'];
                    userInfo.school = loginUser['school'];
                    if (loginUser['userType'] == "受験生") {
                      await Navigator.of(context)
                          .pushNamed("/roomStudentList", arguments: userInfo);
                    } else if (loginUser['userType'] == "ベネッセ関係者") {
                      await Navigator.of(context)
                          .pushNamed("/roomMentorList", arguments: userInfo);
                    }
                  } catch (e) {
                    // ログインに失敗した場合
                    setState(() {
                      infoText = "ログインNG：${e.toString()}";
                    });
                  }
                },
                child: Text("ログイン"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.of(context).pushNamed("/select");
                },
                child: Text("登録ページへ"),
              ),
              const SizedBox(height: 8),
              Text(infoText)
            ],
          ),
        ),
      ),
    );
  }
}

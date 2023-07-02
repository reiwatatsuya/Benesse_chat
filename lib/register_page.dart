import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'users.dart';

class RegisterPage extends StatefulWidget {
  final String userType;
  RegisterPage({super.key, required this.userType});

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  // 入力されたメールアドレス
  String newUserEmail = "";
  // 入力されたパスワード
  String newUserPassword = "";
  // 入力された名前
  String newUserName = "";
  // 入力された高校名
  String newUserSchool = "";
  // 登録・ログインに関する情報を表示
  String infoText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.network(
                width: 48, // 画像の幅を指定
                height: 48,
                'https://logos-download.com/wp-content/uploads/2018/07/Benesse_logo_colour-420x420.png'),
            const SizedBox(width: 8), // テキストとの間にスペースを設けるために SizedBox を使用
            const Text('Benesse'),
          ],
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            children: <Widget>[
              TextFormField(
                // テキスト入力のラベルを設定
                decoration: InputDecoration(labelText: "メールアドレス"),
                onChanged: (String value) {
                  setState(() {
                    newUserEmail = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(labelText: "パスワード（６文字以上）"),
                // パスワードが見えないようにする
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    newUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(labelText: "ユーザー名"),
                onChanged: (String value) {
                  setState(() {
                    newUserName = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: InputDecoration(labelText: "高校名"),
                onChanged: (String value) {
                  setState(() {
                    newUserSchool = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // メール/パスワードでユーザー登録
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.createUserWithEmailAndPassword(
                      email: newUserEmail,
                      password: newUserPassword,
                    );

                    // 登録したユーザー情報
                    final User user = result.user!;
                    Users userInfo = Users();
                    userInfo.email = newUserEmail;
                    userInfo.id = user.uid;
                    userInfo.name = newUserName;
                    userInfo.password = newUserPassword;
                    userInfo.school = newUserSchool;
                    userInfo.userType = widget.userType;
                    await FirebaseFirestore.instance
                        .collection('users') // コレクションID.
                        .doc(user.uid) // ドキュメントID.
                        .set({
                      'email': newUserEmail,
                      'password': newUserPassword,
                      'name': newUserName,
                      'school': newUserSchool,
                      'userType': widget.userType
                    }); // データ.
                    if (widget.userType == "受験生") {
                      await Navigator.of(context)
                          .pushNamed("/roomStudentList", arguments: userInfo);
                    } else if (widget.userType == "ベネッセ関係者") {
                      await Navigator.of(context)
                          .pushNamed("/roomMentorList", arguments: userInfo);
                    }
                  } catch (e) {
                    // 登録に失敗した場合
                    setState(() {
                      infoText = "登録NG：${e.toString()}";
                    });
                  }
                },
                child: Text("ユーザー登録"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
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

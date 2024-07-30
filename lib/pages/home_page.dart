import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:straypal/auth.dart';

class HomePage extends StatelessWidget {
   HomePage({Key? key}) : super(key: key);

  final User? user = Auth().currentUser;
  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title(){
    return Text("FireBase Auth");
  }
  Widget _userUid(){
    return Text(user?.email ?? 'User Email');
  }
  Widget _signOutButton(){

    return ElevatedButton(onPressed: signOut, child: Text('SignOut'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body:
        Container(
          height: double.infinity,
            width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _userUid(),
              _signOutButton(),
            ],
          )
        )
    );
  }
}

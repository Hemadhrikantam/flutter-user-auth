import 'package:firebaseauth/ui/login.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_firebase_auth/authentication.dart';
// import 'package:flutter_firebase_auth/login.dart';

import '../authentication_service.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('Welcome Buddy!!!'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AuthenticationHelper()
              .signOut()
              .then((_) => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (contex) => Login()),
                  ));
        },
        child: Icon(Icons.logout),
        tooltip: 'Logout',
      ),
    );
  }
}
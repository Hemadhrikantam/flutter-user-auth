import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseauth/ui/home.dart';
import 'package:flutter/material.dart';

//import 'phoneauth/welcome_screen.dart';
//import 'package:flutter_firebase_auth/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Login"),),
        body: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var otpController = TextEditingController();
  var numController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationId = "";

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
      await auth.signInWithCredential(phoneAuthCredential);

      if (authCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } on FirebaseAuthException catch (e) {
      print("catch");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Phone Number',
                  hintText: 'Enter valid number'
              ),
              controller: numController,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              obscureText: true,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Verification Code',
                  hintText: 'Enter valid Code'
              ),
              controller: otpController,
            ),
          ),

          TextButton(onPressed: () {
            fetchotp();
          }, child: const Text("Send OTP"),),
          TextButton(onPressed: () {
            verify();
          }, child: const Text("Login"))
        ],
      ),
    );
  }


  Future<void> verify() async {
    PhoneAuthCredential phoneAuthCredential =
    PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: otpController.text);

    signInWithPhoneAuthCredential(phoneAuthCredential);
  }


  Future<void> fetchotp() async {
    await auth.verifyPhoneNumber(
      phoneNumber: '+91'+ numController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
      },

      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },

      codeSent: (String verificationId, int? resendToken) async {
        this.verificationId = verificationId;

      },

      codeAutoRetrievalTimeout: (String verificationId) {
      },
    );
  }

}
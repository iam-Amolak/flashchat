import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashchat/Components/rounded_button.dart';
import 'package:flashchat/constants.dart';
import 'package:flashchat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login';

  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: const Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                    onChanged: (value){
                      email = value;
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.emailAddress,
                    decoration: kEmailInputDecor
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                child: TextField(
                  onChanged: (value){
                    password = value;
                  },
                  textAlign: TextAlign.center,
                  obscureText: true,
                  decoration: kPasswordInputDecor,
                ),
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                text: 'Login',
                onPress: () async{
                  setState(() {
                    showSpinner = true;
                  });
                  try{
                    final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                    if(user != null){
                      Navigator.pushNamed(context, ChatScreen.id);
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  }catch(e){
                    setState(() {
                      showSpinner = false;
                    });
                    //print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

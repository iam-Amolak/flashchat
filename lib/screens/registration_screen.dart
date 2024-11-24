import 'package:flashchat/Components/rounded_button.dart';
import 'package:flashchat/constants.dart';
import 'package:flashchat/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'reg';
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
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
              const SizedBox(height: 10.0,),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value){
                  email = value;
                },
                decoration: kEmailInputDecor,
              ),
              const SizedBox(height: 8.0,),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value){
                  password = value;
                },
                decoration: kPasswordInputDecor,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                text: 'Register',
                onPress: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try{
                    final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                    print(newUser);
                    if(newUser != null){
                      Navigator.pushNamed(context, ChatScreen.id);
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  }catch(e){
                    setState(() {
                      showSpinner = false;
                    });

                    print(e);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );;
  }
}

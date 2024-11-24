import 'package:flashchat/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat';

  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();
  late String message;
  String msglist = '';

  void getCurrentUser() async{
    try{
      final user = await _auth.currentUser;
      if(user != null){
        loggedInUser = user;
      }
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getMessageStream() async{
    await for(var snapshot in _firestore.collection('messages').snapshots()){
      for(var msg in snapshot.docChanges){
        print('${msg.doc.data()?.entries.last.value} from ${msg.doc.data()?.entries.first.value}');
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: (){
              _auth.signOut();
              Navigator.pop(context);
            },
          )
        ],
        title: const Text('⚡Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value){
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: (){
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'message': message,
                        'sender': loggedInUser.email,
                      });
                      setState(() {
                        message = '';
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        List<MessageBubble> messageWidgets = [];
        final messages = snapshot.data?.docs.reversed;

        String? currentUser = loggedInUser.email;

        for(var message in messages!){
          final msgText = message.get('message').toString();
          final sender = message.get('sender').toString();
          final msgwidget = MessageBubble(text: msgText, sender: sender, isME: currentUser == sender,);
          messageWidgets.add(msgwidget);
        }
        return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              child: ListView(
                reverse: true,
                children: messageWidgets,
              ),
            )
        );
      },
    );
  }
}


class MessageBubble extends StatelessWidget {
  MessageBubble({super.key, required this.text, required this.sender, required this.isME});

  String text;
  String sender;
  final bool isME;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isME ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
                color: Colors.black54
            ),
          ),
          Material(
            elevation: 10.0,
            borderRadius: isME ? const BorderRadius.only(topLeft: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)) : const BorderRadius.only(topRight: Radius.circular(30.0), bottomLeft: Radius.circular(30.0), bottomRight: Radius.circular(30.0)),
            color: isME ? Colors.lightBlueAccent : Colors.red,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                ),),
            ),
          ),
        ],
      ),
    );
  }
}

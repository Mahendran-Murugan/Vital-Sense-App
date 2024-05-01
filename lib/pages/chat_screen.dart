import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _user = ChatUser(id: '1', firstName: 'User', lastName: '1');
  final _server = ChatUser(id: '2', firstName: 'Chat', lastName: 'Bot');

  final List<ChatMessage> _messsages = [];
  final List<ChatUser> _typingUser = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text('V I T A L   S E N S E',
            style: GoogleFonts.amaranth(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            )),
        centerTitle: true,
      ),
      body: DashChat(
        currentUser: _user,
        onSend: (ChatMessage m) => {
          getResponse(m),
        },
        typingUsers: _typingUser,
        messageOptions: MessageOptions(
          currentUserContainerColor: Colors.red.shade400,
          containerColor: Colors.grey.shade400,
          textColor: Colors.white,
        ),
        messages: _messsages,
      ),
    );
  }

  Future<void> getResponse(ChatMessage m) async {
    setState(() {
      _messsages.insert(
          0,
          ChatMessage(
            user: m.user,
            createdAt: m.createdAt,
            text: m.text.trimRight(),
          ));
      _typingUser.add(_server);
    });
    const response = "Hello, I'm a ChatBot";
    setState(() {
      _messsages.insert(
        0,
        ChatMessage(
          user: _server,
          createdAt: DateTime.now(),
          text: response,
        ),
      );
    });
    setState(() {
      _typingUser.remove(_server);
    });
  }
}

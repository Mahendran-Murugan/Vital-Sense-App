import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:vitalsense/model/chat_response.dart';

const List<String> list = <String>['Prescription', 'ChatBot'];

class ChatScreen extends StatefulWidget {
  final String serverUrl;

  const ChatScreen({super.key, required this.serverUrl});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _user = ChatUser(id: '1', firstName: 'User', lastName: '1');
  final _server = ChatUser(id: '2', firstName: 'Chat', lastName: 'Bot');

  final List<ChatMessage> _messsages = [];
  final List<ChatUser> _typingUser = [];

  String dropDownValue = list.first;

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
      body: Container(
        padding: const EdgeInsets.all(5),
        color: Colors.grey.shade300.withOpacity(0.5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    'Chat Bot:',
                    style: GoogleFonts.amaranth(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: DropdownMenu<String>(
                    initialSelection: list.first,
                    onSelected: (String? value) {
                      setState(() {
                        dropDownValue = value!;
                      });
                    },
                    dropdownMenuEntries:
                        list.map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                ),
              ],
            ),
            Expanded(
              child: DashChat(
                currentUser: _user,
                onSend: (ChatMessage m) => {
                  getResponse(m),
                },
                typingUsers: _typingUser,
                messageOptions: MessageOptions(
                  currentUserContainerColor: Colors.red.shade400,
                  containerColor: Colors.grey.shade600,
                  textColor: Colors.white,
                ),
                messages: _messsages,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Chat> post(ChatMessage m) async {
    final Uri uri;
    if (dropDownValue == "ChatBot") {
      uri = Uri.parse("$widget.serverUrl/api/post/medicine");
    } else {
      uri = Uri.parse("$widget.serverUrl/api/post/chatbot");
    }
    Map<String, dynamic> request = {
      'message': m.text.trimRight(),
    };
    try {
      final response = await http.post(uri, body: request);
      return Chat.fromJson(json.decode(response.body));
    } catch (e) {
      return Chat(message: "Error");
    }
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
    Chat serverResponse = await post(m);
    setState(() {
      _messsages.insert(
        0,
        ChatMessage(
          user: _server,
          createdAt: DateTime.now(),
          text: serverResponse.message,
        ),
      );
    });
    setState(() {
      _typingUser.remove(_server);
    });
  }
}

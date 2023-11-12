import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String userId;

  const ChatScreen({super.key, required this.chatId, required this.userId});

  @override
  State<StatefulWidget> createState() => ChatState(chatId, userId);
}

class ChatState extends State<ChatScreen> {
  final String webSocketUrl = '127.0.0.1:8080';
  late StompClient _client;
  final TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages = List.empty();
  final String userId;
  final String chatId;

  ChatState(this.chatId, this.userId);

  @override
  void initState(){
    super.initState();
    getMessages();
    // _client = StompClient(
    //     config: StompConfig(url: webSocketUrl, onConnect: onConnectCallback));
    // _client.activate();
  }

  void getMessages() async {
    var url = "http://localhost:8080/api/chat/getMessages";

    var body = {
      'me': userId,
      'other': "afijadofnds",
    };
    var postBody = jsonEncode(body);

    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: postBody);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<Map<String, dynamic>> chatList = [];
      for (var chat in jsonList) {
        var fromMe = chat['sender'] == userId;
        chatList.add({'data': chat['content'], 'isMe': fromMe});
      }
      setState(() => messages = chatList);
    } else {
      throw Exception('Failed to get players');
    }
  }

  void onConnectCallback(StompFrame? connectFrame) async {
    // _client.subscribe(
    //     //destination: '/topic/chat/${widget.chatId}',
    //     destination: '/chat/getMessages',
    //     headers: {},
    //     callback: (frame) {
    //       print(frame.body);
    //       // Received a frame for this subscription
    //       messages = jsonDecode(frame.body!).reversed.toList();
    //     });
  }

  void _sendMessage() {
    final message = messageController.text;
    if (message.isNotEmpty) {
      _client.send(
        //destination: '/app/chat/${widget.chatId}', // Replace with your chat ID
        destination: '/chat.sendMessage',
        body: json.encode({
          'data': message,
          'userId': widget.userId
        }), // Format the message as needed
      );
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(),
            SizedBox(width: 10),
            Text('John Smith'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                // Extract the item from the list
                Map<String, dynamic> item = messages[index];

                // Create a Text widget for the item
                return ChatBubble(
                  text: item['data'],
                  isMe: item['isMe'],
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                  tooltip: 'Send message',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _client.deactivate();
    messageController.dispose();
    super.dispose();
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  ChatBubble({required this.text, required this.isMe});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.black : Colors.grey,
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

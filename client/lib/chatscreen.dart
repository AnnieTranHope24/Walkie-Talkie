import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  final String receiverUserName;
  final String senderUserName;

  const ChatScreen(
      {super.key,
      required this.receiverUserName,
      required this.senderUserName});

  @override
  State<StatefulWidget> createState() =>
      ChatState(receiverUserName, senderUserName);
}

class ChatState extends State<ChatScreen> {
  late StompClient _client;
  final TextEditingController messageController = TextEditingController();
  List<Map<String, dynamic>> messages = List.empty();
  final String senderUserName;
  final String receiverUserName;

  ChatState(this.receiverUserName, this.senderUserName);

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  void getMessages() async {
    var url = "http://localhost:80/api/chat/getChatMessages";

    var body = {
      'SenderUserName': senderUserName,
      'ReceiverUserName': receiverUserName,
    };
    var postBody = jsonEncode(body);

    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: postBody);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<Map<String, dynamic>> chatList = [];
      for (var chat in jsonList) {
        var fromMe = chat['sender']['userName'] == senderUserName;
        chatList.add({'data': chat['content'], 'isMe': fromMe});
      }
      setState(() => messages = chatList);
    } else {
      throw Exception('Failed to get messages');
    }
  }

  Future<void> _sendMessage() async {
    final message = messageController.text;
    if (message.isNotEmpty) {
      var url = "http://localhost:80/api/chat/addChatMessage";

      var body = {
        'SenderUserName': senderUserName,
        'ReceiverUserName': receiverUserName,
        'Content': message,
        'Type': 'chat',
      };

      var postBody = jsonEncode(body);

      final response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json; charset=UTF-8"},
          body: postBody);

      if (response.statusCode == 200) {
        setState(() {
          messages.add({'data': message, 'isMe': true});
        });
      } else {
        throw Exception('Failed to send message');
      }

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
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
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
  const ChatBubble({super.key, required this.text, required this.isMe});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.black : Colors.grey,
          borderRadius: isMe
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                )
              : const BorderRadius.only(
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

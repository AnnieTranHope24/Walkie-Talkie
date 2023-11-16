import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChatApp extends StatefulWidget {
  final String userID;
  const ChatApp({super.key, required this.userID});

  @override
  State<StatefulWidget> createState() => MainScreen(userID);
}

class MainScreen extends State<ChatApp> {
  final String userID;
  MainScreen(this.userID);
  List<ChatMainPreview> chatPreviews = List.empty();
  List<ChatMainPreview> filterList = List.empty();
  TextEditingController searchContact = TextEditingController();

  @override
  void initState() {
    super.initState();
    getChatPreviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: searchContact,
              onChanged: filterContacts,
              decoration: const InputDecoration(
                hintText: 'Search for a name in your contacts',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: searchContact.text.isEmpty
                    ? chatPreviews.length
                    : filterList.length,
                itemBuilder: (context, index) {
                  final chatPreview = searchContact.text.isEmpty
                      ? chatPreviews[index]
                      : filterList[index];
                  return ChatMainPreview(
                      name: chatPreview.name,
                      message: chatPreview.message,
                      timeStamp: chatPreview.timeStamp);
                }),
          ),
          BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.chat),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.contacts),
                label: 'Contacts',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }

  void getChatPreviews() async {
    var url = "http://localhost:8080/api/chat/loadMessages";
    final response = await http.get(Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"});
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<ChatMainPreview> msgs = [];
      for (var chat in jsonList) {
        msgs.add(ChatMainPreview(
          name: chat['name'],
          message: chat['message'],
          timeStamp: chat['timeStamp'],
        ));
      }
      setState(() => chatPreviews = msgs);
    } else {
      throw Exception('Failed to get chat previews');
    }
  }

  void filterContacts(String search) {
    filterList = chatPreviews
        .where((contact) =>
            contact.name.toLowerCase().contains(search.toLowerCase()))
        .toList();
    setState(() {});
  }
}

class ChatMainPreview extends StatelessWidget {
  final String name;
  final String message;
  final String timeStamp;
  const ChatMainPreview({
    super.key,
    String? name,
    String? message,
    String? timeStamp,
  })  : name = name ?? 'Default Name',
        message = message ?? 'Default message',
        timeStamp = timeStamp ?? 'Default time';
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: const CircleAvatar(),
        title: Text(name),
        subtitle: Text(message),
        trailing: Text(timeStamp),
        onTap: () {},
      ),
    );
  }
}

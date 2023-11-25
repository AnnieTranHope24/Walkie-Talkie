import 'dart:convert';
import 'package:client/chatscreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ChatApp extends StatefulWidget {
  final String userName;
  const ChatApp({super.key, required this.userName});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => MainScreen(userName);
}

class MainScreen extends State<ChatApp> {
  final String userName;
  MainScreen(this.userName);
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
            padding: const EdgeInsets.all(8.0),
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
                      timeStamp: chatPreview.timeStamp,
                      userName: userName);
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
    var url = "http://localhost:80/api/chat/loadChatPreviews";

    var body = {'SenderUserName': userName};

    var postBody = jsonEncode(body);

    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: postBody);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<ChatMainPreview> msgs = [];
      for (var chat in jsonList) {
        msgs.add(ChatMainPreview(
          name: chat['contact']['userName'],
          message: chat['lastMessage'],
          timeStamp: chat['timestamp'],
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
  final String userName;
  const ChatMainPreview(
      {super.key,
      String? name,
      String? message,
      String? timeStamp,
      String? userName})
      : name = name ?? 'Default Name',
        message = message ?? 'Default message',
        timeStamp = timeStamp ?? 'Default time',
        userName = userName ?? 'Default user name';
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: const CircleAvatar(),
        title: Text(name),
        subtitle: Text(message),
        trailing: Text(timeStamp),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      senderUserName: userName,
                      receiverUserName: name,
                    )),
          );
        },
      ),
    );
  }
}

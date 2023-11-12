import 'package:flutter/material.dart';

class ChatApp extends StatelessWidget {
  ChatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a name in your contacts',
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ChatPreview(
                  name: 'John Smith',
                  message: 'Hello...',
                  timeStamp: 'Now',
                ),
                ChatPreview(
                  name: 'Alice Johnson',
                  message: 'How are you?',
                  timeStamp: '1 hour ago',
                ),
              ],
            ),
          ),
          BottomNavigationBar(
            items: [
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
}

class ChatPreview extends StatelessWidget {
  final String name;
  final String message;
  final String timeStamp;
  ChatPreview({
    required this.name,
    required this.message,
    required this.timeStamp,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(),
        title: Text(name),
        subtitle: Text(message),
        trailing: Text(timeStamp),
        onTap: () {},
      ),
    );
  }
}

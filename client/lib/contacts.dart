import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Contacts extends StatefulWidget {
  final String userID;
  const Contacts({super.key, required this.userID});

  @override
  State<StatefulWidget> createState() => ContactState(userID);
}

class ContactState extends State<Contacts> {
  final String userID;
  List<ContactItem> contactPreviews = List.empty();
  List<ContactItem> filterList = List.empty();
  TextEditingController searchContact = TextEditingController();

  ContactState(this.userID);

  @override
  void initState() {
    super.initState();
    getContactPreviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchContact,
                  onChanged: filterContacts,
                  decoration: InputDecoration(
                    hintText: 'Search for a contact',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  addContactDialog(context);
                },
                child: const Text('Add Contact'),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: searchContact.text.isEmpty
                        ? contactPreviews.length
                        : filterList.length,
                    itemBuilder: (context, index) {
                      final chatPreview = searchContact.text.isEmpty
                          ? contactPreviews[index]
                          : filterList[index];
                      return ContactItem(
                        contactName: chatPreview.contactName,
                        phoneNumber: chatPreview.phoneNumber,
                      );
                    }),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getContactPreviews() async {
    var url = "http://localhost:8080/api/chat/loadContacts";
    final response = await http.get(Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"});
    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<ContactItem> previews = [];
      for (var contacts in jsonList) {
        previews.add(ContactItem(
          contactName: contacts['name'],
          phoneNumber: contacts['phoneNumber'],
        ));
      }
      setState(() => contactPreviews = previews);
    } else {
      throw Exception('Failed to get contact previews');
    }
  }

  void filterContacts(String search) {
    filterList = contactPreviews
        .where((contact) =>
            contact.contactName.toLowerCase().contains(search.toLowerCase()))
        .toList();
    setState(() {});
  }

  Future<void> addContactDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Contact'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                addContact(nameController.text, phoneController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void addContact(String name, String phone) {
    setState(() {
      contactPreviews.add(ContactItem(contactName: name, phoneNumber: phone));
    });
  }
}

class ContactItem extends StatelessWidget {
  final String contactName;
  final String phoneNumber;
  const ContactItem(
      {Key? key, required this.contactName, required this.phoneNumber})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 40,
                height: 40,
              ),
              Text(
                contactName,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontFamily: 'Archivo',
                  fontWeight: FontWeight.bold,
                  height: 0.08,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            phoneNumber,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontFamily: 'Archivo',
              fontWeight: FontWeight.normal,
              height: 0.10,
            ),
          ),
        ],
      ),
    );
  }
}

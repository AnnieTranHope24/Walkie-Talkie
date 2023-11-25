import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Contacts extends StatefulWidget {
  final String userName;
  const Contacts({super.key, required this.userName});

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => ContactState(userName);
}

class ContactState extends State<Contacts> {
  final String userName;
  List<ContactItem> contactPreviews = List.empty();
  List<ContactItem> filterList = List.empty();
  TextEditingController searchContact = TextEditingController();

  ContactState(this.userName);

  @override
  void initState() {
    super.initState();
    getContactPreviews(userName);
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

  void getContactPreviews(String userName) async {
    var url = "http://localhost:80/api/contact/loadContacts";
    var body = {
      'UserName': userName,
    };
    var postBody = jsonEncode(body);

    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: postBody);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      List<ContactItem> previews = [];
      for (var contacts in jsonList) {
        previews.add(ContactItem(
          contactName: contacts['contactName'],
          phoneNumber: contacts['contact']['phoneNumber'],
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
                _addContact(
                    nameController.text, phoneController.text, userName);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addContact(String name, String phone, String userName) async {
    var url = "http://localhost:80/api/contact/addContact";
    var body = {
      'UserName': userName,
      'ContactName': name,
      'ContactPhoneNumber': phone,
    };
    var postBody = jsonEncode(body);
    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: postBody);

    if (response.statusCode != 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a registered number"),
        ),
      );
    } else {
      setState(() {
        contactPreviews.add(ContactItem(contactName: name, phoneNumber: phone));
      });
    }
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

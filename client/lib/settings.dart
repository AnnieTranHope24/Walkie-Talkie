import 'dart:convert';

import 'package:client/validators.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key, required this.username});

  String username;
  final _nameForm = GlobalKey<FormState>();
  final _passwordForm = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<bool> _updateName() async {
    var url = "http://localhost:80/api/user/changeName";
    final name = _nameController.text;

    var body = {
      'Username': username,
      'NewName': name,
    };
    var postBody = jsonEncode(body);

    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: postBody);
    return response.statusCode == 200;
  }

  Future<bool> _updatePassword() async {
    var url = "http://localhost:80/api/user/changePassword";
    final password = _passwordController.text;

    var body = {
      'Username': username,
      'NewPassword': password,
    };
    var postBody = jsonEncode(body);

    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: postBody);
    return response.statusCode == 200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: 5,
          left: 5,
          child: IconButton(
            onPressed: () => {Navigator.pop(context)},
            icon: const Icon(
              Icons.arrow_back,
            ),
            splashRadius: 25,
          ),
        ),
        Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(40),
                ),
                Text(
                  username,
                  textScaleFactor: 2,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(15)),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text("Change Name"),
                            content: Column(children: [
                              Form(
                                  key: _nameForm,
                                  child: Column(
                                    children: [
                                      const Text("New Name:"),
                                      TextFormField(
                                        controller: _nameController,
                                        validator: nameValidator,
                                      ),
                                    ],
                                  ))
                            ]),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel')),
                              TextButton(
                                child: const Text("Confirm"),
                                onPressed: () {
                                  if (_nameForm.currentState!.validate()) {
                                    //send to database
                                    _updateName().then((succeeded) {
                                      if (succeeded) {
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Could not update Name!"),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                },
                              )
                            ],
                          );
                        });
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const SignInPage()),
                    // );
                  },
                  child: const SizedBox(
                    width: 140,
                    height: 40,
                    child: Center(
                      child: Text(
                        'Change Name',
                        textScaleFactor: 1.25,
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(15),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            title: const Text("Change Password"),
                            content: Column(children: [
                              Form(
                                  key: _passwordForm,
                                  child: Column(
                                    children: [
                                      const Text("New Password:"),
                                      TextFormField(
                                        controller: _passwordController,
                                        validator: passwordValidator,
                                      ),
                                    ],
                                  ))
                            ]),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel')),
                              TextButton(
                                child: const Text("Confirm"),
                                onPressed: () {
                                  if (_passwordForm.currentState!.validate()) {
                                    //send to database
                                    _updatePassword().then((succeeded) {
                                      if (succeeded) {
                                        Navigator.pop(context);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Could not update Password!"),
                                          ),
                                        );
                                      }
                                    });
                                  }
                                },
                              )
                            ],
                          );
                        });
                  },
                  child: const SizedBox(
                    width: 140,
                    height: 40,
                    child: Center(
                      child: Text(
                        'Change Password',
                        textScaleFactor: 1.25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}

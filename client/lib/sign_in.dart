import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class SignInPageFormState extends State<SignInPageForm> {
  final _usernameForm = GlobalKey<FormState>();
  final _passwordForm = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<bool> checkDataBase() async {
    var url = "http://localhost:8080/api/user/check";
    final username = _usernameController.text;
    final password = _passwordController.text;

    var body = {
      'Username': username,
      'Password': password,
    };
    var postBody = jsonEncode(body);

    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: postBody);

    if (response.statusCode != 200) {
      return false;
    }
    return true;
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
                    padding: EdgeInsets.all(20),
                  ),
                  const Text(
                    "Sign In",
                    textScaleFactor: 2,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Form(
                    key: _usernameForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Enter your username:"),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            helperText: " ",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a username';
                            }
                            if (RegExp(r'^[\w\s_\-0-9]+$').hasMatch(value)) {
                              return null;
                            }
                            return "Invalid username!";
                          },
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Form(
                    key: _passwordForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Enter your Password:"),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            helperText: " ",
                          ),
                          validator: (value) {
                            if (value == null ||
                                value
                                    .isEmpty) // matches any character that is not a number
                            {
                              return 'Please enter a password';
                            }

                            if (value.length < 8 ||
                                !RegExp(r'[A-Z]').hasMatch(value)) {
                              return "Invalid password!";
                            }

                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(20)),
                  ElevatedButton(
                    onPressed: () {
                      _usernameForm.currentState!.validate();
                      _passwordForm.currentState!.validate();
                      checkDataBase().then((succeeded) => {
                            if (!succeeded)
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Invalid username and/or password!"),
                                  ),
                                )
                              }
                            else
                              {
                                // go to chat list page
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Going to chats page"),
                                  ),
                                )
                              }
                          });
                    },
                    child: const SizedBox(
                      width: 140,
                      height: 40,
                      child: Center(
                        child: Text(
                          'Sign In',
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
      ),
    );
  }
}

class SignInPageForm extends StatefulWidget {
  const SignInPageForm({super.key});

  @override
  State<SignInPageForm> createState() {
    return SignInPageFormState();
  }
}

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const SignInPageForm();
  }
}

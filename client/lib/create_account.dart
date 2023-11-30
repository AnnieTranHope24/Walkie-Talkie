import 'package:client/create_or_signin.dart';
import 'package:client/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import "validators.dart";

class CreateAccountPageFormState extends State<CreateAccountPageForm> {
  final _phoneNumberForm = GlobalKey<FormState>();
  final _nameForm = GlobalKey<FormState>();
  final _usernameForm = GlobalKey<FormState>();
  final _passwordForm = GlobalKey<FormState>();
  final _phoneNumberController = TextEditingController();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<String?> createAccount() async {
    var url = "http://localhost:80/api/user/create";
    final username = _usernameController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final phonenumber = _phoneNumberController.text;
    var body = {
      'Username': username,
      'Password': password,
      'Name': name,
      'Phonenumber': phonenumber
    };
    var postBody = jsonEncode(body);

    final response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: postBody);

    if (response.statusCode == 200) {
      return response.body;
    }
    return null;
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
              icon: const Icon(Icons.arrow_back),
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
                    "Create Account",
                    textScaleFactor: 2,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                  ),
                  Form(
                    key: _nameForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Enter your Name:"),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            helperText: " ",
                          ),
                          validator: nameValidator,
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Form(
                    key: _usernameForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Create a username:"),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            helperText: " ",
                          ),
                          validator: usernameValidator,
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                  ),
                  Form(
                    key: _phoneNumberForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Enter your Phone Number:"),
                        TextFormField(
                          controller: _phoneNumberController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            helperText: " ",
                          ),
                          validator: phonenumberValidator,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                        const Text("Create a Password:"),
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            helperText: " ",
                          ),
                          validator: passwordValidator,
                        )
                      ],
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(20)),
                  ElevatedButton(
                    onPressed: () {
                      if (_nameForm.currentState!.validate() &&
                          _usernameForm.currentState!.validate() &&
                          _phoneNumberForm.currentState!.validate() &&
                          _passwordForm.currentState!.validate()) {
                        createAccount().then((value) => {
                              if (value != null &&
                                  value.toLowerCase() != "all good!")
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(value),
                                    ),
                                  )
                                }
                              else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Account created!'),
                                    ),
                                  ),
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInPage()),
                                  )
                                }
                            });
                      }
                    },
                    child: const SizedBox(
                      width: 140,
                      height: 40,
                      child: Center(
                        child: Text(
                          'Create Account',
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

class CreateAccountPageForm extends StatefulWidget {
  const CreateAccountPageForm({super.key});

  @override
  State<CreateAccountPageForm> createState() {
    return CreateAccountPageFormState();
  }
}

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const CreateAccountPageForm();
  }
}

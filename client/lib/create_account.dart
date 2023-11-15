import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateAccountPageFormState extends State<CreateAccountPageForm> {
  final _phoneNumberForm = GlobalKey<FormState>();
  final _nameForm = GlobalKey<FormState>();
  final _usernameForm = GlobalKey<FormState>();
  final _passwordForm = GlobalKey<FormState>();

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
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0,
                              horizontal: 10.0,
                            ),
                            helperText: " ",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            if (RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                              return null;
                            }
                            return "Names may not be anything other than spaces and alphabetic characters";
                          },
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
                            return "Usernames may include alphabetical characters, underscores '_', hyphens '-', or numerical characters";
                          },
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
                              return 'Please enter a phone number';
                            }

                            if (!RegExp(r'\d{10}').hasMatch(value)) {
                              return "Invalid phone number format";
                            }

                            return null;
                          },
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

                            if (value.length < 8) {
                              return "Your password must be at least 8 characters";
                            }

                            if (!RegExp(r'[A-Z]').hasMatch(value)) {
                              return "Your password must contain an uppercase character";
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
                      _nameForm.currentState!.validate();
                      _usernameForm.currentState!.validate();
                      _phoneNumberForm.currentState!.validate();
                      _passwordForm.currentState!.validate();
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

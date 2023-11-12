import 'package:flutter/material.dart';

import 'CreateAccount.dart';
import 'SignIn.dart';

class CreateOrSignInPageFormState extends State<CreateOrSignInPageForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.8,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(40),
              ),
              const Text(
                "Walkie Talkie",
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
                          "https://static.thenounproject.com/png/3972603-200.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(15)),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInPage()),
                  );
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
              const Padding(
                padding: EdgeInsets.all(15),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateAccountPage()),
                  );
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
    );
  }
}

class CreateOrSignInPageForm extends StatefulWidget {
  const CreateOrSignInPageForm({super.key});

  @override
  State<CreateOrSignInPageForm> createState() {
    return CreateOrSignInPageFormState();
  }
}

class CreateOrSignInPage extends StatelessWidget {
  const CreateOrSignInPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const CreateOrSignInPageForm();
  }
}

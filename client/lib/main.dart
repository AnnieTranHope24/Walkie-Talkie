import 'dart:async';
import 'package:flutter/material.dart';
import 'create_or_signin.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 227, 174, 181),
        primarySwatch: Colors.pink,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var app = MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.pink,
      ),
      home: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 133,
                height: 133,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://static.thenounproject.com/png/3972603-200.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('WalkieTalkie',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontFamily: 'Alata',
                    fontWeight: FontWeight.w400,
                    height: 0.04,
                    letterSpacing: 1.05,
                  )),
            )
          ],
        ),
      )),
    );
    Timer(
      const Duration(seconds: 2),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateOrSignInPage()),
      ),
    );
    return app;
  }
}

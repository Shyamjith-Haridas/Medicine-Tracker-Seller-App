import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "HomeScreen",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}

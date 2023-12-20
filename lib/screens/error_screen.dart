import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  const ErrorScreen({super.key});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SizedBox(
      child: Center(
        child: Text("Unauthorized usage of the app"),
      ),
    ));
  }
}

import 'package:flutter/material.dart';

import 'model/user_details.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyDataWidget());
  }
}

class MyDataWidget extends StatefulWidget {
  const MyDataWidget({Key? key}) : super(key: key);

  @override
  State<MyDataWidget> createState() => _MyDataWidgetState();
}

class _MyDataWidgetState extends State<MyDataWidget> {
  String? defaultValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: UserDetailsWidget("Divyanshu", "Kumar", true, 1234, 1234.4232,
          UserType.verified, "assets/icon", DateTime.now()),
    );
  }
}

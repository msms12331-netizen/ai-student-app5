import 'package:flutter/material.dart';

void main() {
  runApp(const StudentAIApp());
}

class StudentAIApp extends StatelessWidget {
  const StudentAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مساعد الطلاب بالذكاء الاصطناعي',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مساعد الطلاب'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'مرحباً! أنا مساعدك الدراسي الذكي 🎓',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String openAiApiKey = "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

void main() {
  runApp(const StudentAIApp());
}

class StudentAIApp extends StatelessWidget {
  const StudentAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'مساعد الطلاب بالذكاء الاصطناعي',
      theme: ThemeData.dark(),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String responseText = "";
  bool loading = false;

  Future<void> getAIResponse(String prompt) async {
    setState(() {
      loading = true;
      responseText = "";
    });

    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $openAiApiKey"
    };
    final body = jsonEncode({
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "system", "content": "أنت مساعد ذكي يساعد الطلاب في دراستهم."},
        {"role": "user", "content": prompt}
      ]
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      final data = jsonDecode(response.body);
      setState(() {
        responseText = data["choices"][0]["message"]["content"];
      });
    } catch (e) {
      setState(() {
        responseText = "حدث خطأ أثناء الاتصال بالخدمة.";
      });
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("مساعد الطلاب الذكي"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "اكتب سؤالك هنا...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  getAIResponse(_controller.text);
                }
              },
              child: const Text("إرسال"),
            ),
            const SizedBox(height: 16),
            if (loading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    responseText,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

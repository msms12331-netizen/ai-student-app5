import 'package:flutter/material.dart';

void main() {
  runApp(const AIStudentApp());
}

class AIStudentApp extends StatelessWidget {
  const AIStudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Student Helper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  final _pages = const [
    SummarizePage(),
    FlashcardsPage(),
    PlannerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Student Helper')),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.text_snippet_outlined), label: 'ملخّص'),
          NavigationDestination(icon: Icon(Icons.style_outlined), label: 'فلاش كارد'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'خطة'),
        ],
      ),
    );
  }
}

/// صفحة التلخيص (محلية بدون باك إند؛ للفكرة فقط)
class SummarizePage extends StatefulWidget {
  const SummarizePage({super.key});
  @override
  State<SummarizePage> createState() => _SummarizePageState();
}

class _SummarizePageState extends State<SummarizePage> {
  final _controller = TextEditingController();
  String _summary = '';

  String _fakeSummarize(String text) {
    final words = text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    if (words.isEmpty) return 'اكتب نصًا أولاً…';
    final chunk = (words.length / 3).ceil();
    final parts = [
      words.take(chunk).join(' '),
      words.skip(chunk).take(chunk).join(' '),
      words.skip(2 * chunk).join(' ')
    ].where((s) => s.trim().isNotEmpty).toList();
    return parts.as_map().entries.map((e) => '• ${e.value}').join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'ألصق نص المذاكرة هنا…',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            icon: const Icon(Icons.bolt),
            label: const Text('تلخيص سريع'),
            onPressed: () => setState(() => _summary = _fakeSummarize(_controller.text)),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: Text(_summary.isEmpty ? 'سيظهر التلخيص هنا…' : _summary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// صفحة الفلاش كاردز (محلية في الذاكرة)
class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});
  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  final _q = TextEditingController();
  final _a = TextEditingController();
  final List<(String, String)> _cards = [];
  int _current = 0;
  bool _showAnswer = false;

  void _addCard() {
    if (_q.text.trim().isEmpty || _a.text.trim().isEmpty) return;
    setState(() {
      _cards.add((_q.text.trim(), _a.text.trim()));
      _q.clear();
      _a.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField(controller: _q, decoration: const InputDecoration(labelText: 'سؤال'))),
              const SizedBox(width: 8),
              Expanded(child: TextField(controller: _a, decoration: const InputDecoration(labelText: 'إجابة'))),
              const SizedBox(width: 8),
              IconButton(onPressed: _addCard, icon: const Icon(Icons.add_circle), tooltip: 'إضافة'),
            ],
          ),
          const SizedBox(height: 12),
          if (_cards.isEmpty)
            const Text('أضف بطاقات للمراجعة.')
          else
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _showAnswer = !_showAnswer),
                      child: Card(
                        elevation: 3,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              _showAnswer ? _cards[_current].$2 : _cards[_current].$1,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 22),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => setState(() {
                          _current = (_current - 1) % _cards.length;
                          if (_current < 0) _current = _cards.length - 1;
                          _showAnswer = false;
                        }),
                        icon: const Icon(Icons.chevron_left, size: 32),
                      ),
                      Text('${_current + 1} / ${_cards.length}'),
                      IconButton(
                        onPressed: () => setState(() {
                          _current = (_current + 1) % _cards.length;
                          _showAnswer = false;
                        }),
                        icon: const Icon(Icons.chevron_right, size: 32),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// صفحة خطة مذاكرة بسيطة (قائمة مهام يومية)
class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});
  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  final _task = TextEditingController();
  final List<(String, bool)> _tasks = [];

  void _addTask() {
    if (_task.text.trim().isEmpty) return;
    setState(() {
      _tasks.add((_task.text.trim(), false));
      _task.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: TextField(controller: _task, decoration: const InputDecoration(labelText: 'أضف مهمة مذاكرة'))),
              const SizedBox(width: 8),
              FilledButton(onPressed: _addTask, child: const Text('إضافة')),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: _tasks.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final (title, done) = _tasks[i];
                return CheckboxListTile(
                  value: done,
                  onChanged: (v) => setState(() => _tasks[i] = (title, v ?? false)),
                  title: Text(title),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoHomeScreen extends StatefulWidget {
  const TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
  int _counter = 0;
  final TextEditingController _taskController = TextEditingController();
  List<String> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadStoredData();
  }

  Future<void> _loadStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter_key') ?? 0;
      _tasks = prefs.getStringList('todo_key') ?? [];
    });
  }

  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter_key', _counter);
    await prefs.setStringList('todo_key', _tasks);
  }

  void _increment() {
    setState(() => _counter++);
    _saveToDisk();
  }

  void _decrement() {
    setState(() => _counter--);
    _saveToDisk();
  }

  void _addTask() {
    if (_taskController.text.isNotEmpty) {
      setState(() {
        _tasks.insert(0, _taskController.text); // New tasks appear at the top
        _taskController.clear();
      });
      _saveToDisk();
    }
  }

  void _deleteTask(int index) {
    setState(() => _tasks.removeAt(index));
    _saveToDisk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Matches Splash Screen Navy
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "DASHBOARD",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // --- BEAUTIFIED COUNTER SECTION ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent.withOpacity(0.2), Colors.blueAccent.withOpacity(0.05)],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text("QUICK COUNTER",
                      style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 10),
                  Text("$_counter",
                      style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w300)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCounterBtn(Icons.remove, _decrement),
                      const SizedBox(width: 30),
                      _buildCounterBtn(Icons.add, _increment),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- BEAUTIFIED TO-DO SECTION ---
            const Text("DAILY TASKS",
                style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const SizedBox(height: 15),

            // Input Field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _taskController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Add a new mission...",
                  hintStyle: const TextStyle(color: Colors.white38),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: _addTask,
                    icon: const Icon(Icons.add_task_rounded, color: Colors.blueAccent),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Task List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.radio_button_unchecked, color: Colors.blueAccent, size: 20),
                    title: Text(_tasks[index], style: const TextStyle(color: Colors.white, fontSize: 16)),
                    trailing: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 20),
                      onPressed: () => _deleteTask(index),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for Counter Buttons
  Widget _buildCounterBtn(IconData icon, VoidCallback action) {
    return InkWell(
      onTap: action,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }
}
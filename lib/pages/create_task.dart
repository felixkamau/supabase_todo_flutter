import 'package:flutter/material.dart';
import 'package:flutter_db/utils/supabase.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _supaBaseClient = supabaseClient;
  final _taskController = TextEditingController();

  void _createTask(String taskName) async {
    final userid = _supaBaseClient.auth.currentUser?.id;
    await _supaBaseClient.from('tasks').insert({
      'task_name': taskName,
      'user_id': userid,
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create task")),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            child: TextField(
              controller: _taskController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(15),
                hint: Text("Create a task"),
              ),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final String controllerText = _taskController.text.trim();
          if (controllerText.isNotEmpty) {
            _createTask(controllerText);
            _taskController.clear();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Task Created")));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

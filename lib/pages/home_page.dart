import 'package:flutter/material.dart';
import 'package:flutter_db/auth/auth_service.dart';
import 'package:flutter_db/utils/supabase.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final authService = AuthService();

  void logout() async {
    authService.logOut();
  }

  Future<List<Map<String, dynamic>>> fetchTasks() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final response = await supabaseClient
        .from('tasks')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return response;
  }

  Stream<List<Map<String, dynamic>>> supabseStream() {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final response = supabaseClient
        .from('tasks')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .order('created_at');

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home Page"),
        leading: IconButton(onPressed: logout, icon: Icon(Icons.logout)),
      ),

      body: StreamBuilder(
        stream: supabseStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final tasks = snapshot.data ?? [];

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              final isDone = task['status'] ?? false;
              // return ListTile(title: Text(task['task_name']));

              final createdAt = task['created_at'];
              final formattedDate = (createdAt != null)
                  ? DateFormat.yMMMd().add_jm().format(
                      DateTime.parse(createdAt),
                    )
                  : 'Unknown Date';

              return Padding(
                padding: const EdgeInsets.all(5.0),
                child: CheckboxListTile(
                  tileColor: isDone
                      ? Colors.green.withOpacity(0.3)
                      : Colors.orange.withOpacity(0.25),
                  title: Text(
                    task['task_name'],
                    style: TextStyle(
                      decoration: isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(formattedDate),
                  value: isDone,
                  onChanged: (bool? value) async {
                    await supabaseClient
                        .from('tasks')
                        .update({'status': value})
                        .eq('id', task['id']);

                    // setState(() {}); // rebuild do away with this and use stream

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Updated task"),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),

      // Use future builder
      // body: FutureBuilder(
      //   future: fetchTasks(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }

      //     if (snapshot.hasError) {
      //       return Center(child: Text("Error: ${snapshot.error}"));
      //     }

      //     final tasks = snapshot.data ?? [];

      //     return ListView.builder(
      //       itemCount: tasks.length,
      //       itemBuilder: (context, index) {
      //         final task = tasks[index];
      //         final isDone = task['status'] ?? false;
      //         // return ListTile(title: Text(task['task_name']));
      //         return Padding(
      //           padding: const EdgeInsets.all(5.0),
      //           child: CheckboxListTile(
      //             tileColor: isDone
      //                 ? Colors.green.withOpacity(0.3)
      //                 : Colors.orange.withOpacity(0.25),
      //             title: Text(
      //               task['task_name'],
      //               style: TextStyle(
      //                 decoration: isDone ? TextDecoration.lineThrough : null,
      //               ),
      //             ),
      //             subtitle: Text(task['created_at']),
      //             value: isDone,
      //             onChanged: (bool? value) async {
      //               await supabaseClient
      //                   .from('tasks')
      //                   .update({'status': value})
      //                   .eq('id', task['id']);

      //               // setState(() {}); // rebuild do away with this and use stream

      //               ScaffoldMessenger.of(context).showSnackBar(
      //                 SnackBar(
      //                   content: Text("Updated task"),
      //                   duration: Duration(seconds: 1),
      //                 ),
      //               );
      //             },
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}

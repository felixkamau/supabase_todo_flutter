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

  // Function to fetchTasks from our db using
  // FutureBuilder() widget
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

  // A re-write of fetchTasks() function to fetch all tasks from supabase
  // using StreamBuilder() widget
  Stream<List<Map<String, dynamic>>> supabseStream() {
    final user = supabaseClient.auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    final response = supabaseClient
        .from('tasks')
        .stream(primaryKey: ['id'])
        .eq('user_id', user.id)
        .order('created_at');

    print(response); // for debug in production
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
                  // BuildContext across async lint erroe
                  onChanged: (bool? value) async {
                    final messenger = ScaffoldMessenger.of(context);
                    await supabaseClient
                        .from('tasks')
                        .update({'status': value})
                        .eq('id', task['id']);

                    // Fix: BuildContext error across async gaps
                    // Checks if the context is still available in the widget tree
                    // if mounted == false that means the widget is no longer
                    // available in the widget tree, thus the context used here will not
                    // be valid
                    if (!mounted) return;

                    // Now it's safe to use context
                    // setState(() {}); // rebuild do away with this and use stream
                    messenger.showSnackBar(
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

      // ==> Prefered StreamBuilder() widget for real-time updates instead
      // of FutureBuilder() which keeps re-building the widgets.

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

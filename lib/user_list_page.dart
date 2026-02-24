import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'edit_user_page.dart';
import 'registration_page.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  static const String baseUrl =
      "http://localhost/flutter_register_student/php_api";

  List users = [];
  bool isLoading = true;

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse("$baseUrl/get_users.php"));

    if (response.statusCode == 200) {
      users = json.decode(response.body);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteUser(String id) async {
    await http.post(
      Uri.parse("$baseUrl/delete_user.php"),
      body: {"id": id},
    );
    fetchUsers();
  }

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student List"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RegistrationPage(),
            ),
          );
          fetchUsers();
        },
        child: const Icon(Icons.add),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("No Data"))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: Image.network(
                          "$baseUrl/images/${user['image']}",
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image),
                        ),

                        title: Text(
                          "${user['student_id']} - ${user['name']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text("Email: ${user['email']}"),
                            Text("Phone: ${user['phone']}"),
                            Text(
                              "Department: ${user['department']}",
                            ),
                          ],
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon:
                                  const Icon(Icons.edit),
                              onPressed: () async {
                                final result =
                                    await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        EditUserPage(
                                            user: user),
                                  ),
                                );

                                if (result == true) {
                                  fetchUsers();
                                }
                              },
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.delete),
                              onPressed: () async {
                                final confirm =
                                    await showDialog(
                                  context: context,
                                  builder: (_) =>
                                      AlertDialog(
                                    title:
                                        const Text(
                                            "Confirm Delete"),
                                    content:
                                        const Text(
                                            "Delete this student?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(
                                                context,
                                                false),
                                        child: const Text(
                                            "Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(
                                                context,
                                                true),
                                        child: const Text(
                                            "Delete"),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  deleteUser(user['id']
                                      .toString());
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
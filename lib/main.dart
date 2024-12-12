import 'package:flutter/material.dart';
import 'screens/fetch_users_screen.dart';
import 'screens/delete_post_screen.dart';
import 'screens/update_post_screen.dart';
import 'screens/create_post_screen.dart'; // Implement this screen

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter CRUD',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/create-post': (context) => const CreatePostScreen(), // Create Post Screen
        '/update-post': (context) => const UpdatePostScreen(), // Update Post Screen
        '/delete-post': (context) => const DeletePostScreen(), // Delete Post Screen
        '/fetch-users': (context) => const FetchUsersScreen(), // Fetch Users Screen
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CRUD Operations')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Create Post'),
            onTap: () => Navigator.pushNamed(context, '/create-post'),
          ),
          ListTile(
            title: const Text('Update Post'),
            onTap: () => Navigator.pushNamed(context, '/update-post'),
          ),
          ListTile(
            title: const Text('Delete Post'),
            onTap: () => Navigator.pushNamed(context, '/delete-post'),
          ),
          ListTile(
            title: const Text('Fetch Users'),
            onTap: () => Navigator.pushNamed(context, '/fetch-users'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> _createPost(String title, String body) async {
    setState(() {
      _isSubmitting = true;
    });

    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'body': body}),
    );

    setState(() {
      _isSubmitting = false;
    });

    if (response.statusCode == 201) {
      // Successfully created post
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully!')),
      );
      _titleController.clear();
      _bodyController.clear();
    } else {
      // Failed to create post
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create post. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Body'),
              maxLines: 5,
            ),
            const SizedBox(height: 16.0),
            _isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () {
                final title = _titleController.text.trim();
                final body = _bodyController.text.trim();

                if (title.isEmpty || body.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Both fields are required!')),
                  );
                  return;
                }

                _createPost(title, body);
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

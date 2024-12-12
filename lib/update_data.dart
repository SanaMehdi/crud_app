import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/post.dart';

class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<List<Post>> futurePosts;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  // Fetch posts from the API
  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((postJson) => Post.fromJson(postJson)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Update a post
  Future<void> updatePost(int id, String title, String body) async {
    final response = await http.put(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'body': body}),
    );

    if (response.statusCode == 200) {
      setState(() {
        futurePosts = fetchPosts(); // Reload posts after update
      });
    } else {
      throw Exception('Failed to update post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Post'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: bodyController,
              decoration: InputDecoration(labelText: 'Body'),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final postId = 1; // Replace with dynamic post ID if necessary
              updatePost(postId, titleController.text, bodyController.text);
              titleController.clear();
              bodyController.clear();
            },
            child: Text('Update Post'),
          ),
          Expanded(
            child: FutureBuilder<List<Post>>(
              future: futurePosts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No posts found.'));
                }

                final posts = snapshot.data!;

                return ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text(post.body),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          titleController.text = post.title;
                          bodyController.text = post.body;
                          // Update post when user clicks edit button
                          updatePost(post.id, titleController.text, bodyController.text);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

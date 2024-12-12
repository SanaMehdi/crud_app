import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Post model
class Post {
  final int id;
  final String title;

  Post({required this.id, required this.title});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
    );
  }
}

class DeletePostScreen extends StatefulWidget {
  const DeletePostScreen({Key? key}) : super(key: key);

  @override
  _DeletePostScreenState createState() => _DeletePostScreenState();
}

class _DeletePostScreenState extends State<DeletePostScreen> {
  late Future<List<Post>> futurePosts;

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((postJson) => Post.fromJson(postJson)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'));

    if (response.statusCode == 200) {
      setState(() {
        futurePosts = fetchPosts(); // Reload posts after deletion
      });
    } else {
      throw Exception('Failed to delete post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delete Post')),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No posts found.'));
          }

          final posts = snapshot.data!;

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.title),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => deletePost(post.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

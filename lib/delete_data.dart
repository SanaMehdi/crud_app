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

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts(); // Fetch posts when screen is initialized
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

  // Delete a post
  Future<void> deletePost(int id) async {
    final response = await http.delete(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
    );

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
      appBar: AppBar(
        title: Text('Delete Post'),
      ),
      body: FutureBuilder<List<Post>>(
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
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deletePost(post.id);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

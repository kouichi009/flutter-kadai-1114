import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter02/services/api/post_service.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class TestPost extends StatefulWidget {
  const TestPost({Key? key}) : super(key: key);

  @override
  _TestPostState createState() => _TestPostState();
}

class _TestPostState extends State<TestPost> {
  newPost() async {
    final authUser = Provider.of<User>(context, listen: false);
    String downloadUrl =
        'https://firebasestorage.googleapis.com/v0/b/instagram-flutter-kadai.appspot.com/o/post_036e504f-91a0-4b98-9fa8-69a2f62e7f03.jpg?alt=media&token=7261c43e-d9da-4c8e-a277-72925990c3a5';

    for (int i = 0; i < 30; i++) {
      String postId = Uuid().v4();

      await PostService.uploadPost(
          postId, authUser.uid, downloadUrl, '${i} 番目');
      print('${i} 番目 ${postId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(35.0),
      height: 130.0,
      child: FlatButton(
        onPressed: () => newPost(),
        color: Colors.orange,
        padding: const EdgeInsets.all(10.0),
        child: Text(
          '投稿',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}

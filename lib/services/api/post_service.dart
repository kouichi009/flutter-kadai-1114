import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:instagram_flutter02/models/post.dart';
import 'package:instagram_flutter02/models/user_model.dart';
import 'package:instagram_flutter02/screens/home_screen.dart';
import 'package:instagram_flutter02/utilities/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide UserCredential;

class PostService {
  // static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // static final FirebaseMessaging _messaging = FirebaseMessaging();

  dynamic? lastDocument = null;

  static Future<Map<String, dynamic>> queryTimeline(
      documentLimit, lastDocument, hasMore) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List<Post> posts = [];
    List<UserModel> userModels = [];
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await _firestore
          .collection('posts')
          .where('status', isEqualTo: 1)
          .orderBy('timestamp', descending: true)
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await _firestore
          .collection('posts')
          .where('status', isEqualTo: 1)
          .orderBy('timestamp', descending: true)
          .startAfterDocument(lastDocument!)
          .limit(documentLimit)
          .get();
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    if (querySnapshot.docs.length > 0) {
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
      await Future.forEach<QueryDocumentSnapshot<Object?>>(querySnapshot.docs,
          (doc) async {
        Post post = Post.fromDoc(doc);
        String postUid = doc['uid'];

        DocumentSnapshot documentSnapshot = await usersRef.doc(postUid).get();
        UserModel userModel = UserModel.fromDoc(documentSnapshot);

        posts.add(post);
        userModels.add(userModel);
      });
    }
    return {
      'posts': posts,
      'userModels': userModels,
      'hasMore': hasMore,
      'lastDocument': lastDocument,
    };
  }

  static Future<List<Post>> queryUserPosts(userId) async {
    QuerySnapshot snapshot = await postsRef
        .where('uid', isEqualTo: userId)
        .where('status', isEqualTo: 1)
        .orderBy('timestamp', descending: true)
        .get();

    List<Post> posts = snapshot.docs.map((doc) => Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<List<Post>> queryLikedPosts(currentUid) async {
    List<Post> posts = [];
    QuerySnapshot snapshot = await usersRef
        .doc(currentUid)
        .collection('likedPosts')
        .where('isLiked', isEqualTo: true)
        .where('status', isEqualTo: 1)
        .orderBy('timestamp', descending: true)
        .get();
    await Future.forEach<QueryDocumentSnapshot<Object?>>(snapshot.docs,
        (doc) async {
      String postId = doc['postId'];
      DocumentSnapshot documentSnapshot = await postsRef.doc(postId).get();
      Post post = Post.fromDoc(documentSnapshot);
      posts.add(post);
    });
    return posts;
  }

  static Future<void> likePost(String? currentUid, Post? post) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentSnapshot doc = await postsRef.doc(post?.id).get();
    int likeCount = doc['likeCount'];
    final timestamp = FieldValue.serverTimestamp();

    batch.update(postsRef.doc(post?.id), {
      'likeCount': likeCount + 1,
      'likes.${currentUid}': true,
    });

    batch.set(usersRef.doc(currentUid).collection('likedPosts').doc(post?.id), {
      'postId': post?.id,
      'isLiked': true,
      'timestamp': timestamp,
      'uid': post?.uid,
      'status': 1
    });

    await batch.commit();
  }

  static Future<void> unLikePost(String? currentUid, Post? post) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentSnapshot doc = await postsRef.doc(post?.id).get();
    int likeCount = doc['likeCount'];
    final timestamp = FieldValue.serverTimestamp();

    batch.update(postsRef.doc(post?.id), {
      'likeCount': likeCount - 1,
      'likes.${currentUid}': false,
    });

    batch.update(
        usersRef.doc(currentUid).collection('likedPosts').doc(post?.id), {
      'isLiked': false,
      'timestamp': timestamp,
    });

    await batch.commit();
  }

  //
  static Future uploadPost(postId, currentUid, downloadUrl, caption) async {
    final timestamp = FieldValue.serverTimestamp();
    await postsRef.doc(postId).set({
      "id": postId,
      "uid": currentUid,
      "photoUrl": downloadUrl,
      "likeCount": 0,
      "timestamp": timestamp,
      "caption": caption,
      "likes": {},
      'status': 1
    });
  }

  static Future deletePost(post) async {
    await postsRef.doc(post.id).update({'status': 2});
    final likes = post.likes;
    List likeUids = likes.keys.toList();
    likeUids.forEach((likeUid) {
      usersRef
          .doc(likeUid)
          .collection('likedPosts')
          .doc(post.id)
          .update({'status': 2});
    });
  }

  static Future<Map> getLatestPost(post) async {
    List futureDocs = await Future.wait([
      postsRef.doc(post.id).get(),
      usersRef.doc(post.uid).get(),
    ]);

    final latestPostDoc = futureDocs[0];
    final latestUserModelDoc = futureDocs[1];

    Post latestPost = Post.fromDoc(latestPostDoc);
    UserModel latestUserModel = UserModel.fromDoc(latestUserModelDoc);

    return {'latestPost': latestPost, 'latestUserModel': latestUserModel};
  }
}

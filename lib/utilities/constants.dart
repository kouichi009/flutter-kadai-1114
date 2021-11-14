import 'package:cloud_firestore/cloud_firestore.dart';

final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final MYPOSTS = 'MYPOSTS';
final FAV = 'FAV';
final MALE = 'male';
final FEMALE = 'female';
final TIMELINE_PAGE = 'TIMELINE';
final PROFILE_PAGE = 'PROFILE';

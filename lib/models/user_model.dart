import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  String? name;
  String? profileImageUrl;
  Map<String, dynamic>? dateOfBirth;
  String? gender;
  Timestamp? timestamp;
  String? androidNotificationToken;
  int? status;

  UserModel({
    this.uid,
    this.name,
    this.profileImageUrl,
    this.dateOfBirth,
    this.gender,
    this.timestamp,
    this.androidNotificationToken,
    this.status,
  });

  factory UserModel.fromDoc(DocumentSnapshot doc) {
    return UserModel(
      uid: doc['uid'],
      name: doc['name'],
      profileImageUrl: doc['profileImageUrl'],
      dateOfBirth: doc['dateOfBirth'],
      gender: doc['gender'],
      timestamp: doc['timestamp'],
      androidNotificationToken: doc['androidNotificationToken'],
      status: doc['status'],
    );
  }
}

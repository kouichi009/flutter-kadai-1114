import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? uid;
  final String? name;
  final String? profileImageUrl;
  final Map<String, dynamic>? dateOfBirth;
  final String? gender;
  final Timestamp? timestamp;
  final String? androidNotificationToken;
  final int? status;

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

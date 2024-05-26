import 'package:flutter/foundation.dart';
import 'dart:core';

@immutable
class UserModel {
  final String uid;
  final String email;
  final String name;
  final String profilePic;
  final String bannerPic;
  final String bio;
  final List<String> followers;
  final List<String> following;
  final bool isBlue;

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.profilePic,
    required this.bannerPic,
    required this.bio,
    required this.followers,
    required this.following,
    required this.isBlue,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    List<String>? followers,
    List<String>? following,
    String? profilePic,
    String? bannerPic,
    String? bio,
    bool? isBlue,
  }) {
    return UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        name: name ?? this.name,
        profilePic: profilePic ?? this.profilePic,
        bannerPic: bannerPic ?? this.bannerPic,
        bio: bio ?? this.bio,
        followers: followers ?? this.followers,
        following: following ?? this.following,
        isBlue: isBlue ?? this.isBlue);
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'name': name});
    result.addAll({'profilePic': profilePic});
    result.addAll({'bannerPic': bannerPic});
    result.addAll({'bio': bio});
    result.addAll({'followers': followers});
    result.addAll({'following': following});
    result.addAll({'isBlue': isBlue});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['\$id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      bannerPic: map['bannerPic'] ?? '',
      bio: map['bio'] ?? '',
      followers: List<String>.from(map['followers']),
      following: List<String>.from(map['following']),
      isBlue: map['isBlue'] ?? false,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid:$uid email: $email, name:$name, followers: $followers, following: $following, profilePic: $profilePic, bannerPic: $bannerPic, bio: $bio, isBlue: $isBlue)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.email == email &&
        other.name == name &&
        listEquals(other.followers, followers) &&
        listEquals(other.following, following) &&
        other.profilePic == profilePic &&
        other.bannerPic == bannerPic &&
        other.uid == uid &&
        other.bio == bio &&
        other.isBlue == isBlue;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        name.hashCode ^
        followers.hashCode ^
        following.hashCode ^
        profilePic.hashCode ^
        bannerPic.hashCode ^
        uid.hashCode ^
        bio.hashCode ^
        isBlue.hashCode;
  }
}

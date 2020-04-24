import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String firstName;
  String email;
  String lastName;
  String bio;
  bool isVerified;

  User({
    this.id,
    this.firstName,
    this.email,
    this.lastName,
    this.bio,
  });

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, email: $email, lastName: $lastName, bio: $bio, isVerified, $isVerified}';
  }

  User copyWith({
    String firstName,
    String email,
    String lastName,
    String bio,
  }) {
    return User(
      id: this.id,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      lastName: lastName ?? this.lastName,
      bio: bio ?? this.bio,
    );
  }

  Map<String, Object> toDocument() {
    return {
      'uid': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'bio': bio,
    };
  }

  static User fromSnapshot(DocumentSnapshot document) {
    return new User(
      id: document.documentID,
      firstName: document['first_name'] as String ?? "",
      email: document['email'] as String ?? "",
      lastName: document['last_name'] as String ?? "",
      bio: document['bio'] as String ?? "",
    );
  }
}

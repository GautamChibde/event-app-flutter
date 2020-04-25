import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String firstName;
  String email;
  String lastName;
  String imageUrl;
  String bio;
  bool isVerified;

  User(
      {this.id,
      this.firstName,
      this.email,
      this.lastName,
      this.bio,
      this.imageUrl});

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, email: $email, lastName: $lastName, bio: $bio, isVerified, $isVerified, imageUrl: $imageUrl}';
  }

  User copyWith({
    String firstName,
    String email,
    String lastName,
    String bio,
    String imageUrl,
  }) {
    return User(
        id: this.id,
        firstName: firstName ?? this.firstName,
        email: email ?? this.email,
        lastName: lastName ?? this.lastName,
        bio: bio ?? this.bio,
        imageUrl: imageUrl ?? this.imageUrl);
  }

  Map<String, Object> toDocument() {
    return {
      'uid': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'bio': bio,
      'image_url': imageUrl
    };
  }

  static User fromSnapshot(DocumentSnapshot document) {
    return new User(
      id: document.documentID,
      firstName: document['first_name'] ?? "",
      email: document['email'] ?? "",
      lastName: document['last_name'] ?? "",
      bio: document['bio'] ?? "",
      imageUrl: document['image_url'] ?? "",
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/model/user.dart';
import 'package:eventapp/repository/base_repository.dart';

class UserRepository extends BaseRepository<User> {
  UserRepository._privateConstructor();

  static final UserRepository instance = UserRepository._privateConstructor();
  final userCollection = Firestore.instance.collection('users');

  Future<void> add(User user) {
    return userCollection.document(user.id).setData(user.toDocument());
  }

  Future<void> delete(User user) async {
    return userCollection.document(user.id).delete();
  }

  Stream<List<User>> getAll() {
    return userCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) => User.fromSnapshot(doc)).toList();
    });
  }

  Future<void> update(User user) {
    return userCollection.document(user.id).updateData(user.toDocument());
  }

  Future<User> getById(String id) async {
    DocumentSnapshot doc = await userCollection.document(id).get();
    if (doc.data == null) return null;
    User user = User.fromSnapshot(doc);
    return user;
  }

  Stream<User> getByIdStream(String id) {
    return userCollection
        .where("uid", isEqualTo: id)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map((doc) => User.fromSnapshot(doc))
          .toList()
          .first;
    });
  }
}

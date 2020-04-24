

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/model/event.dart';

import 'base_repository.dart';

class FirebaseEventRepository extends BaseRepository<Event> {

  final eventCollection = Firestore.instance.collection('event');

  Future<void> add(Event event) {
    return eventCollection.add(event.toDocument());
  }


  Future<void> delete(Event event) async {
    return eventCollection.document(event.id).delete();
  }


  Stream<List<Event>> getAll() {
    return eventCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Event.fromSnapshot(doc))
          .toList();
    });
  }


  Future<void> update(Event update) {
    return eventCollection
        .document(update.id)
        .updateData(update.toDocument());
  }
}
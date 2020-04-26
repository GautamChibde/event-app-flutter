import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventapp/model/event.dart';
import 'package:eventapp/utils/event_type.dart';

import 'base_repository.dart';

class FirebaseEventRepository extends BaseRepository<Event> {
  FirebaseEventRepository._privateConstructor();

  static final FirebaseEventRepository instance =
      FirebaseEventRepository._privateConstructor();
  final eventCollection = Firestore.instance.collection('event');

  Future<void> add(Event event) {
    return eventCollection.add(event.toDocument());
  }

  Future<void> delete(Event event) async {
    return eventCollection.document(event.id).delete();
  }

  Stream<List<Event>> getAll() {
    return eventCollection.snapshots().map((snapshot) {
      return snapshot.documents.map((doc) => Event.fromSnapshot(doc)).toList();
    });
  }

  Stream<List<Event>> getByType(EventType eventType) {
    Query query;
    if (eventType == EventType.upcomming) {
      query = eventCollection
          .where("date", isGreaterThan: DateTime.now().millisecondsSinceEpoch)
          .orderBy("date");
    } else {
      query = eventCollection
          .where("date", isLessThan: DateTime.now().millisecondsSinceEpoch)
          .orderBy("date", descending: true);
    }
    return query.snapshots().map(
      (snapshot) {
        return snapshot.documents
            .map((doc) => Event.fromSnapshot(doc))
            .toList();
      },
    );
  }

  Future<void> update(Event update) {
    return eventCollection.document(update.id).updateData(update.toDocument());
  }
}

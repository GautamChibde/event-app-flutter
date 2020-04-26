import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String title;
  String description;
  String location;
  String imageUrl;
  int startTime;
  int endTime;
  int date;

  Event(
    this.title,
    this.description,
    this.location,
    this.date,
    this.startTime,
    this.endTime, {
    this.id,
    this.imageUrl,
  });

  Event copyWith({
    String title,
    String description,
    String imageUrl,
    String location,
    int startTime,
    int endTime,
    int date,
  }) {
    return Event(
      title ?? this.title,
      description ?? this.description,
      location ?? this.location,
      date ?? this.date,
      startTime ?? this.startTime,
      endTime ?? this.endTime,
      imageUrl: imageUrl ?? this.imageUrl,
      id: this.id,
    );
  }

  @override
  String toString() {
    return 'Event{title: $title, description: $description, imageUrl: $imageUrl, date: $date}';
  }

  Map<String, Object> toDocument() {
    return {
      'name': title,
      'description': description,
      'image': imageUrl,
      'date': date,
      'location': location,
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  static Event fromSnapshot(DocumentSnapshot document) {
    return new Event(
      document['name'],
      document['description'],
      document['location'],
      document['date'],
      document['start_time'] as int,
      document['end_time'] as int,
      imageUrl: document['image'],
      id: document.documentID,
    );
  }
}

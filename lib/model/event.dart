import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String id;
  String title;
  String description;
  String imageUrl;
  int date;

  Event(this.id, this.title, this.description, this.imageUrl, this.date);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Event &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description &&
          imageUrl == other.imageUrl &&
          date == other.date;

  @override
  int get hashCode =>
      title.hashCode ^ description.hashCode ^ imageUrl.hashCode ^ date.hashCode;

  Event copyWith(
      {String title, String description, String imageUrl, int date}) {
    return Event(
      this.id,
      title ?? this.title,
      description ?? this.description,
      imageUrl ?? this.imageUrl,
      date ?? this.date,
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
    };
  }

  static Event fromSnapshot(DocumentSnapshot document) {
    return new Event(
      document.documentID,
      document['name'],
      document['description'],
      document['image'],
      document['date'],
    );
  }
}

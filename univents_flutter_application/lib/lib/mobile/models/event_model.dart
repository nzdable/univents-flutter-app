// models/event.dart
class Event {
  final String uid;
  final String eventbanner;
  final String orguid;
  final String title;
  final String description;
  final String location;
  final String type;
  final DateTime datetimestart;
  final DateTime datetimeend;
  final String status;
  final String tags;

  Event({
    required this.uid,
    required this.eventbanner,
    required this.orguid,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.datetimestart,
    required this.datetimeend,
    required this.status,
    required this.tags,
  });

  factory Event.fromMap(Map<String, dynamic> m) => Event(
        uid: m['uid'] as String,
        eventbanner: m['eventbanner']as String,
        orguid: m['orguid'] as String,
        title: m['title'] as String,
        description: m['description'] as String,
        location: m['location'] as String,
        type: m['type'] as String,
        datetimestart: DateTime.parse(m['datetimestart'] as String),
        datetimeend: DateTime.parse(m['datetimeend'] as String? ?? DateTime.now().toIso8601String()),
        status: m['status'] as String? ?? 'Unknown',
        tags: m['tags'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'eventbanner': eventbanner,
        'orguid': orguid,
        'title': title,
        'description': description,
        'location': location,
        'type': type,
        'datetimestart': datetimestart.toIso8601String(),
        'datetimeend': datetimeend.toIso8601String(),
        'status': status,
        'tags': tags,
      };
}
import 'package:libora/features/models/Message.dart';

class Space {
  final String id;
  final String name;
  final String code;
  final List people;
  final List messages;
  final String createdAt;

  Space({
    required this.id,
    required this.name,
    required this.code,
    required this.people,
    required this.messages,
    required this.createdAt,
  });

  factory Space.fromJson(Map<String, dynamic> json) {
    print("Raw JSON: $json"); // Debugging: See full object structure

    return Space(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      code: json['code'] ?? '',
      people: List<String>.from(json['people'] ?? []),
      messages: _parseMessages(json['messages']),
      createdAt: json['createdAt'] ?? '',
    );
  }

  static List<Message> _parseMessages(dynamic messages) {
    if (messages == null) return []; // ✅ Return empty list if missing

    if (messages is List) {
      return messages
          .whereType<Map<String, dynamic>>() // ✅ Ensure each item is a Map
          .map((x) => Message.fromJson(x))
          .toList();
    }

    print("Unexpected messages format: $messages"); // Debugging output
    return []; // ✅ Return empty list if format is unexpected
  }
}

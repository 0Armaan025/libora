import 'package:libora/features/models/Message.dart';

class Space {
  final String id;
  final String name;
  final String code;
  final List people;
  final List messages;
  final DateTime createdAt;

  Space({
    required this.id,
    required this.name,
    required this.code,
    required this.people,
    required this.messages,
    required this.createdAt,
  });

  factory Space.fromJson(Map json) {
    List messagesList = [];
    if (json['messages'] != null) {
      messagesList =
          List.from(json['messages'].map((x) => Message.fromJson(x)));
    }

    return Space(
      id: json['_id'],
      name: json['name'],
      code: json['code'],
      people: List.from(json['people']),
      messages: messagesList,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

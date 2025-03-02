class Message {
  final String user;
  final String message;
  final DateTime timestamp;

  Message({
    required this.user,
    required this.message,
    required this.timestamp,
  });

  factory Message.fromJson(Map json) {
    return Message(
      user: json['user'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

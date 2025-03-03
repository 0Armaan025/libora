class Message {
  final String user;
  final String message;
  final DateTime timestamp;

  Message({
    required this.user,
    required this.message,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      user: json.containsKey('user')
          ? json['user']
          : 'Unknown', // ✅ Handles missing user
      message: json['message'] ?? '', // Add null check here
      timestamp: json.containsKey('createdAt')
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(), // Handle missing timestamp
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libora/features/models/Message.dart';
import 'package:libora/features/repositories/space_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async'; // Import for timer

class GroupChatScreen extends StatefulWidget {
  final String code;
  final String spaceName;

  const GroupChatScreen({
    super.key,
    required this.code,
    required this.spaceName,
  });

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<dynamic> _messages = [];
  String? _currentUsername;
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String _debugInfo = "Initializing...";
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _updateDebugInfo("Init state called");
    _getCurrentUsername();
    _fetchMessages();
    // Set up polling to fetch messages every 4 seconds
    _setupPolling();
  }

  @override
  void dispose() {
    // Cancel the timer when widget is disposed
    _pollingTimer?.cancel();
    super.dispose();
  }

  void _updateDebugInfo(String info) {
    print("DEBUG: $info"); // Print to console for debugging
    setState(() {
      _debugInfo = info;
    });
  }

  void _getCurrentUsername() async {
    try {
      _updateDebugInfo("Getting username from SharedPreferences");
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final username = prefs.getString('name');

      if (username == null) {
        _updateDebugInfo("Username is null in SharedPreferences");
      } else {
        _updateDebugInfo("Got username: $username");
      }

      setState(() {
        _currentUsername = username;
      });
    } catch (e) {
      _updateDebugInfo("Error getting username: $e");
    }
  }

  void _setupPolling() {
    _updateDebugInfo("Setting up message polling (4-second interval)");
    // Cancel any existing timer
    _pollingTimer?.cancel();

    // Set up a new timer that runs every 4 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      _fetchMessages(isPolling: true);
    });
  }

  void _fetchMessages({bool isPolling = false}) async {
    // Only show loading indicator on initial fetch, not during polling
    if (!isPolling) {
      setState(() {
        _isLoading = true;
        _updateDebugInfo("Fetching messages (initial load)");
      });
    } else {
      _updateDebugInfo("Polling for new messages");
    }

    try {
      final messages = await _apiService.getMessages(widget.code);

      if (messages == null) {
        _updateDebugInfo("API returned null messages");
      } else {
        _updateDebugInfo("Received ${messages.length} messages from API");
      }

      if (mounted) {
        // Check if widget is still in the tree
        setState(() {
          _messages = messages ?? [];
          _isLoading = false;
        });
      }
    } catch (e) {
      _updateDebugInfo("Error fetching messages: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _sendMessage() async {
    if (_messageController.text.isEmpty) {
      _updateDebugInfo("Attempted to send empty message");
      return;
    }

    if (_currentUsername == null) {
      _updateDebugInfo("Cannot send message: username is null");
      // Show a snackbar to inform the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to send message. Please restart the app."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final messageText = _messageController.text;
    _messageController.clear();
    _updateDebugInfo("Sending message: $messageText");

    // Create a temporary message to show immediately
    // We're creating a Message object for consistency
    final tempMessage = Message(
      user: _currentUsername!,
      message: messageText,
      timestamp: DateTime.now(),
    );

    setState(() {
      // Add a special property to identify pending messages
      // We'll add it dynamically since it's not part of the Message class
      _messages.add(tempMessage);
      // Store the index of pending message
      _pendingMessageIndices.add(_messages.length - 1);
    });

    try {
      // Send message to server
      _updateDebugInfo("Calling API to send message");
      final sentMessages = await _apiService.sendMessage(
          widget.code, _currentUsername!, messageText);

      // If the server returns an updated message list, update the UI
      if (sentMessages != null && sentMessages.isNotEmpty) {
        _updateDebugInfo("Received updated message list from server");
        if (mounted) {
          setState(() {
            _messages = sentMessages;
            // Clear pending indices as we've refreshed the entire list
            _pendingMessageIndices.clear();
            _errorMessageIndices.clear();
          });
        }
      } else {
        _updateDebugInfo(
            "Server confirmed message but didn't return updated list");
        // We'll fetch messages to make sure we have the latest
        _fetchMessages(isPolling: true);
      }
    } catch (e) {
      _updateDebugInfo("Error sending message: $e");
      // Mark message as error
      if (mounted) {
        setState(() {
          // Find the index of the pending message and mark it as error
          if (_pendingMessageIndices.isNotEmpty) {
            final index = _pendingMessageIndices.removeLast();
            _errorMessageIndices.add(index);
          }
        });

        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to send message: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Lists to track pending and error message indices
  final List<int> _pendingMessageIndices = [];
  final List<int> _errorMessageIndices = [];

  // Helper method to check if a message is pending
  bool _isMessagePending(int index) {
    return _pendingMessageIndices.contains(index);
  }

  // Helper method to check if a message has error
  bool _isMessageError(int index) {
    return _errorMessageIndices.contains(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.spaceName,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          // Debug refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _updateDebugInfo("Manual refresh triggered");
              _fetchMessages();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Debug info banner - only visible in debug mode
          if (true) // Replace with something like kDebugMode when ready for production
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.yellow[100],
              width: double.infinity,
              child: Text(
                "DEBUG: $_debugInfo",
                style: GoogleFonts.robotoMono(
                  fontSize: 12,
                  color: Colors.black87,
                ),
              ),
            ),

          // Chat Messages
          Expanded(
            child: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        "Loading messages...",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                : _messages.isEmpty
                    ? Center(
                        child: Text(
                          "No messages yet. Start the conversation!",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isPending = _isMessagePending(index);
                          final hasError = _isMessageError(index);
                          return _buildMessageBubble(message,
                              isPending: isPending, hasError: hasError);
                        },
                      ),
          ),

          // Message Input Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.grey[100],
            child: Row(
              children: [
                // Text Input Field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: _currentUsername == null
                          ? "Unable to send messages..."
                          : "Type a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Send Button
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: _currentUsername == null ? Colors.grey : Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message,
      {bool isPending = false, bool hasError = false}) {
    final isCurrentUser = message.user == _currentUsername;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? (hasError ? Colors.red[100] : Colors.blue)
              : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isCurrentUser ? const Radius.circular(16) : Radius.zero,
            bottomRight:
                isCurrentUser ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Sender's Name
            if (!isCurrentUser)
              Text(
                message.user,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            if (!isCurrentUser) const SizedBox(height: 4),

            // Message Text
            Text(
              message.message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isCurrentUser
                    ? (hasError ? Colors.red[900] : Colors.white)
                    : Colors.black,
              ),
            ),
            const SizedBox(height: 4),

            // Timestamp and Status
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: isCurrentUser ? Colors.white70 : Colors.grey[600],
                  ),
                ),
                if (isCurrentUser) ...[
                  const SizedBox(width: 4),
                  if (isPending)
                    const Icon(Icons.access_time,
                        size: 12, color: Colors.white70)
                  else if (hasError)
                    const Icon(Icons.error_outline, size: 12, color: Colors.red)
                  else
                    const Icon(Icons.check, size: 12, color: Colors.white70),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
}

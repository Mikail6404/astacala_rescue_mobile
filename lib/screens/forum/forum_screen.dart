// package:astacala_rescue_mobile/screens/forum/forum_screen.dart

import 'package:astacala_rescue_mobile/models/disaster_report_card_model.dart';
import 'package:astacala_rescue_mobile/models/forum_message_model.dart';
import 'package:flutter/material.dart';

class ForumScreen extends StatefulWidget {
  final DisasterReportCardModel report;

  const ForumScreen({super.key, required this.report});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  // TODO: Backend Integration
  // This mock data should be replaced with a list fetched from your API
  // for this specific disaster report.
  final List<ForumMessageModel> _messages = [
    ForumMessageModel(
      userName: 'Mikail',
      userImageUrl:
          'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=100',
      timestamp: '26 September 2024 20:57 WIB',
      message:
          'Tolong bantu saya untuk menjelaskan apakah akses kendaraan untuk perjalanan untuk menuju lokasi bencana tersebut bisa dilalui.',
      replies: [
        ForumMessageModel(
          userName: 'Gibran',
          userImageUrl:
              'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
          timestamp: '26 September 2024 21:05 WIB',
          message:
              'Betul sekali, saya juga sangat ingin tahu terkait akses kendaraan kesana itu bisa dilalui atau tidak.',
        ),
      ],
    ),
    ForumMessageModel(
      userName: 'Astacala',
      userImageUrl:
          'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?w=100',
      timestamp: '27 September 2024 08:30 WIB',
      message:
          'Informasi terakhir yang saya dapat, jalur utama masih terputus. Mungkin bisa coba jalur alternatif via desa sebelah.',
    ),
  ];

  final _messageController = TextEditingController();

  void _postMessage() {
    // TODO: Backend Integration
    // This method should send the text from _messageController.text to your API.
    // The API would save it and the app would then refresh the message list.
    if (_messageController.text.isNotEmpty) {
      // Message posting logic - replace with API call
      // await _forumService.postMessage(widget.report.id, _messageController.text);
      _messageController.clear();
      FocusScope.of(context).unfocus(); // Hide keyboard
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.report.title),
      ),
      body: Column(
        children: [
          // List of messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _MessageWidget(message: _messages[index]);
              },
            ),
          ),
          // Input field
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 4,
            color: Colors.black.withValues(alpha: 0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ketik pesan...',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
            onPressed: _postMessage,
          ),
        ],
      ),
    );
  }
}

// A widget to display a single message and its replies
class _MessageWidget extends StatelessWidget {
  final ForumMessageModel message;
  const _MessageWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(message.userImageUrl),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(message.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(message.timestamp,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text(message.message),
                    ],
                  ),
                ),
              ],
            ),
            // Display replies if any
            if (message.replies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 48.0, top: 8.0),
                child: Column(
                  children: message.replies
                      .map((reply) => _MessageWidget(message: reply))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

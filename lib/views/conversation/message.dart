import 'package:flutter/material.dart';
import 'package:messenger_app/services/message.dart';
import 'package:messenger_app/services/character.dart';
import 'package:messenger_app/models/character.dart';

class MessagePage extends StatefulWidget {
  final int conversationId;
  final String characterId;

  MessagePage({required this.conversationId, required this.characterId});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _controller = TextEditingController();
  final MessageService _messageService = MessageService();
  final CharacterService _characterService = CharacterService();
  List<Map<String, dynamic>> _messages = [];
  Character? _character;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _loadCharacter();
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await _messageService.getMessages(widget.conversationId);
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('Failed to load messages: $e');
    }
  }

  Future<void> _loadCharacter() async {
    try {
      final character = await _characterService.getCharacterById(widget.characterId);
      setState(() {
        _character = character;
      });
    } catch (e) {
      print('Failed to load character: $e');
    }
  }

  void _resendLastUserMessage() async {
    try {
      final lastUserMessage = _messages.lastWhere((message) => message['is_sent_by_human']);
      if (lastUserMessage != null) {
        final newMessage = {
          'content': lastUserMessage['content'],
          'is_sent_by_human': true,
          'conversation_id': widget.conversationId,
        };
        print('Resending message: $newMessage');
        final response = await _messageService.sendMessage(newMessage);
        if (response['success']) {
          setState(() {
            _messages.add(response['message']);
            if (response.containsKey('answer')) {
              _messages.add(response['answer']);
            }
            _controller.clear();
          });
          print('Message resent successfully');
        } else {
          setState(() {
            _errorMessage = 'Failed to resend message';
          });
          print('Failed to resend message: ${response['message']}');
        }
      } else {
        setState(() {
          _errorMessage = 'No user message to resend';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to resend last user message';
      });
      print('Failed to resend last user message: $e');
    }
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final newMessage = {
        'content': _controller.text,
        'is_sent_by_human': true,
        'conversation_id': widget.conversationId,
      };
      print('Sending message: $newMessage');
      try {
        final response = await _messageService.sendMessage(newMessage);
        if (response['success']) {
          setState(() {
            _messages.add(response['message']);
            if (response.containsKey('answer')) {
              _messages.add(response['answer']);
            }
            _controller.clear();
          });
          print('Message sent successfully');
        } else {
          setState(() {
            _errorMessage = 'Failed to send message';
          });
          print('Failed to send message: ${response['message']}');
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error sending message';
        });
        print('Error sending message: $e');
      }
    } else {
      setState(() {
        _errorMessage = 'Message is empty';
      });
      print('Message is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_character != null ? _character!.name : 'Loading...'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resendLastUserMessage,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isSentByHuman = message['is_sent_by_human'];
                final messageContent = ListTile(
                  leading: !isSentByHuman && _character != null
                      ? Image.network(
                          _character!.image,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                        )
                      : null,
                  title: Text(message['content']),
                  subtitle: Text(isSentByHuman ? 'You' : _character!.name),
                );
                return messageContent;
              },
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message here...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

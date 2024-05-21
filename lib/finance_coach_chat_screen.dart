import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class FinanceCoachChatScreen extends StatefulWidget {
  final String category;

  FinanceCoachChatScreen({required this.category});

  @override
  _FinanceCoachChatScreenState createState() => _FinanceCoachChatScreenState();
}

class _FinanceCoachChatScreenState extends State<FinanceCoachChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<MessageItem> _messages = [];

  @override
  void initState() {
    super.initState();
    // Gemini API'nin başlatılması burada yapılacak
  }

  void _sendMessage() async {
    final String message = _controller.text;
    if (message.isNotEmpty) {
      setState(() {
        _messages.add(MessageItem(message: message, isSentByMe: true));
      });
      _controller.clear();

      // Gemini API ile iletişim kurarak mesaj gönderme ve yanıt alma
      try {
        // Örnek olarak, Gemini API'den yanıt almak için aşağıdaki kodu kullanabilirsiniz:
        // Bu bir örnek kod bloğudur ve gerçek bir API çağrısı değildir.
        final response = await Gemini.instance.text(message);
        setState(() {
          _messages.add(MessageItem(message: response?.output ?? 'Yanıt alınamadı', isSentByMe: false));
        });
      } catch (e) {
        setState(() {
          _messages.add(MessageItem(message: 'Yanıt alınamadı', isSentByMe: false));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category} Koçluğu'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final messageItem = _messages[index];
                return Align(
                  alignment: messageItem.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: messageItem.isSentByMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      messageItem.message,
                      style: TextStyle(color: messageItem.isSentByMe ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1.0),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: TextField(
              controller: _controller,
              onSubmitted: (String text) {
                _sendMessage();
              },
              decoration: InputDecoration(
                hintText: 'Bir şeyler yazın...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageItem {
  String message;
  bool isSentByMe;

  MessageItem({required this.message, required this.isSentByMe});
}

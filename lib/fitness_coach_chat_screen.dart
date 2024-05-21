import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class FitnessCoachChatScreen extends StatefulWidget {
  final String category;

  FitnessCoachChatScreen({required this.category});

  @override
  _FitnessCoachChatScreenState createState() => _FitnessCoachChatScreenState();
}

class _FitnessCoachChatScreenState extends State<FitnessCoachChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    // Gemini API'nin başlatılması burada yapılacak
  }

  void _sendMessage() async {
    final String message = _controller.text;
    if (message.isNotEmpty) {
      setState(() {
        _messages.add('Ben: $message');
      });
      _controller.clear();

      // Gemini API ile iletişim kurarak mesaj gönderme ve yanıt alma
      try {
        // Örnek olarak, Gemini API'den yanıt almak için aşağıdaki kodu kullanabilirsiniz:
        // Bu bir örnek kod bloğudur ve gerçek bir API çağrısı değildir.
        final response = await Gemini.instance.text(message);
        setState(() {
          _messages.add('Fitness Koçu: ${response?.output}');
        });
      } catch (e) {
        setState(() {
          _messages.add('Fitness Koçu: Yanıt alınamadı');
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
              itemBuilder: (context, index) => ListTile(
                title: Text(_messages[index]),
              ),
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

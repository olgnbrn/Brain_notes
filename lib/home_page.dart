import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'fitness_coach_chat_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          _buildCoachingButton(context, 'Fitness Koçu', 'fitness'),
          _buildCoachingButton(context, 'Eğitim Koçu', 'education'),
          _buildCoachingButton(context, 'Finansal Koç', 'finance'),
          _buildCoachingButton(context, 'Sağlık Koçu', 'health'),
        ],
      ),
    );
  }

  Widget _buildCoachingButton(BuildContext context, String title, String category) {
    return ElevatedButton(
      child: Text(title),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FitnessCoachChatScreen(category: category)),
        );
      },
    );
  }
}

class GeminiClient {
  final String apiKey;

  GeminiClient({required this.apiKey});

  // Bu metot, API'ye mesaj göndermek için kullanılacak.
  Future<GeminiResponse> sendMessage({required String category, required String message}) async {
    // API isteği yapın ve yanıtı alın
    // Bu örnek için basit bir yanıt döndürüyoruz
    return GeminiResponse(message: 'Bu bir test yanıtıdır.');
  }
}

class GeminiResponse {
  final String message;

  GeminiResponse({required this.message});
}

class GeminiCoachingPage extends StatefulWidget {
  final String category;

  GeminiCoachingPage({required this.category});

  @override
  _GeminiCoachingPageState createState() => _GeminiCoachingPageState();
}

class _GeminiCoachingPageState extends State<GeminiCoachingPage> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  late GeminiClient _geminiClient;

  @override
  void initState() {
    super.initState();
    _geminiClient = GeminiClient(apiKey: 'AIzaSyCnA6fcq1bMtGBtgaiw0r4Yb3O6M3D1H_8');
  }

  void _sendMessage() async {
    final String message = _controller.text;
    if (message.isNotEmpty) {
      final GeminiResponse geminiResponse = await _geminiClient.sendMessage(
        category: widget.category,
        message: message,
      );
      setState(() {
        _response = geminiResponse.message;
      });
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
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(_response),
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
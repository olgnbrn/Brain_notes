import 'package:flutter/material.dart';
import 'services/api_client.dart'; // ApiClient sınıfınızın olduğu dosyayı import edin

class GeminiCoachingPage extends StatefulWidget {
  final String category;

  GeminiCoachingPage({required this.category});

  @override
  _GeminiCoachingPageState createState() => _GeminiCoachingPageState();
}

class _GeminiCoachingPageState extends State<GeminiCoachingPage> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  late ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    // ApiClient sınıfınızın bir örneğini oluşturun ve API anahtarınızı buraya ekleyin
    _apiClient = ApiClient(baseUrl: 'API_BASE_URL', apiKey: 'AIzaSyAAOKE0RVFqb7YMzVXbgymIUonRHKesgOY');
  }

  void _sendMessage() async {
    final String message = _controller.text;
    if (message.isNotEmpty) {
      try {
        // API isteğini gönderin ve yanıtı alın
        final Map<String, dynamic> response = await _apiClient.postRequest(
          'API_ENDPOINT', // API uç noktasını buraya ekleyin
          {'message': message, 'category': widget.category},
        );

        // API'den gelen yanıtı ekranda göstermek için setState kullanın
        setState(() {
          _response = response['data']; // API'nin döndürdüğü yanıtın anahtarını buraya ekleyin
        });
      } catch (e) {
        // Hata durumunda kullanıcıya hata mesajını gösterin
        setState(() {
          _response = 'Bir hata oluştu: $e';
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

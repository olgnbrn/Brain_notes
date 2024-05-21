import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'fitness_coach_chat_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ana Sayfa'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: <Widget>[
            _buildCoachingButton(context, 'Fitness Koçu', 'fitness'),
            _buildCoachingButton(context, 'Eğitim Koçu', 'education'),
            _buildCoachingButton(context, 'Finansal Koç', 'finance'),
            _buildCoachingButton(context, 'Sağlık Koçu', 'health'),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachingButton(BuildContext context, String title, String category) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FitnessCoachChatScreen(category: category)),
          );
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

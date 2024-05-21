import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

import 'fitness_coach_chat_screen.dart';
import 'education_coach_chat_screen.dart'; // Eğitim Koçu ekranını import edin
import 'finance_coach_chat_screen.dart'; // Finansal Koç ekranını import edin
import 'health_coach_chat_screen.dart'; // Sağlık Koçu ekranını import edin

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: (1 / 0.5), // Butonların yükseklik/genişlik oranını ayarla
            children: <Widget>[
              _buildCoachingButton(context, 'Fitness Koçu', 'fitness', Icons.fitness_center, FitnessCoachChatScreen(category: 'fitness')),
              _buildCoachingButton(context, 'Eğitim Koçu', 'education', Icons.school, EducationCoachChatScreen(category: 'education')),
              _buildCoachingButton(context, 'Finansal Koç', 'finance', Icons.account_balance, FinanceCoachChatScreen(category: 'finance')),
              _buildCoachingButton(context, 'Sağlık Koçu', 'health', Icons.local_hospital, HealthCoachChatScreen(category: 'health')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoachingButton(BuildContext context, String title, String category, IconData icon, Widget screen) {
    return Card(
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.5),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

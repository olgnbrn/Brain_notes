import 'package:brain_notes/services/api_client.dart';
import 'package:brain_notes/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'reminder_page.dart';
import 'profile_page.dart';
import 'login_page.dart';
import 'fitness_coach_chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(apiKey: 'AIzaSyCnA6fcq1bMtGBtgaiw0r4Yb3O6M3D1H_8');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uygulama Başlığı',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/profile': (context) => ProfilePage(),
        '/reminder': (context) => ReminderPage(),
        '/login': (context) => LoginPage(),
        // '/fitness_coach_chat' rotası kaldırıldı
      },
      onGenerateRoute: (settings) {
        // FitnessCoachChatScreen için dinamik rota oluşturma
        if (settings.name == '/fitness_coach_chat') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return FitnessCoachChatScreen(category: args['category']);
            },
          );
        }
        // Diğer rotalar burada tanımlanabilir
        return null;
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = [
    HomePage(),
    ReminderPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Hatırlatıcı',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

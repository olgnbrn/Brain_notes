import 'package:brain_notes/home.dart';
import 'package:brain_notes/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kişisel Asistan Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Yap'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Logo ekleniyor
              SizedBox(
                height: 300,
                child: Image.asset('assets/logo.jpg'),
              ),
              SizedBox(height: 48.0),
              // E-posta text field'ı
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-posta',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              // Şifre text field'ı
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              // Giriş yap butonu
              ElevatedButton(
                child: Text('Giriş Yap'),
                onPressed: () {
                  signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                  // Giriş işlemi için kodlar buraya eklenecek
                },
              ),
              // Kayıt ol butonu
              TextButton(
                child: Text('Kayıt Ol'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Future<User?> signInWithEmailAndPassword(
    String email, String password) async {
  try {
    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}
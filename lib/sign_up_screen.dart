// sign_up_screen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // E-posta doğrulama fonksiyonu
  bool _isValidEmail(String email) {
    return RegExp(r'\S+@\S+\.\S+').hasMatch(email);
  }

  // Şifre doğrulama fonksiyonu
  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  void _registerUser(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      // Form doğrulaması başarılı
      if (!_isValidEmail(_emailController.text)) {
        // E-posta geçersiz, hata göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Geçerli bir e-posta adresi girin.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      if (!_isValidPassword(_passwordController.text)) {
        // Şifre geçersiz, hata göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Şifre en az 6 karakter olmalıdır.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // Kullanıcı başarıyla kaydedildi, başarılı pop-up göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kayıt başarılı!'),
            backgroundColor: Colors.green,
          ),
        );
        // Giriş sayfasına yönlendirme
        Navigator.of(context).pushReplacementNamed('/login');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // Şifre güçsüz pop-up göster
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Şifre çok zayıf.'),
              backgroundColor: Colors.orange,
            ),
          );
        } else if (e.code == 'email-already-in-use') {
          // E-posta zaten kullanımda pop-up göster
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('E-posta adresi zaten kullanımda.'),
              backgroundColor: Colors.orange,
            ),
          );
        } else {
          // Diğer hatalar için genel hata pop-up göster
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.message ?? 'Kayıt başarısız, lütfen tekrar deneyin.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Form doğrulaması başarısız, hata göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen tüm alanları doğru doldurun.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıt Ol'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'İsim',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'İsim alanı boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(
                    labelText: 'Soyisim',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Soyisim alanı boş bırakılamaz';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'E-posta alanı boş bırakılamaz';
                    }
                    if (!_isValidEmail(value!)) {
                      return 'Geçerli bir e-posta adresi girin.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Şifre alanı boş bırakılamaz';
                    }
                    if (!_isValidPassword(value!)) {
                      return 'Şifre en az 6 karakter olmalıdır.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Şifreyi Onayla',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Şifreyi onaylama alanı boş bırakılamaz';
                    }
                    if (_passwordController.text != value) {
                      return 'Şifreler eşleşmiyor';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  child: Text('Kayıt Ol'),
                  onPressed: () => _registerUser(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

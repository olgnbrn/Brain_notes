import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage('https://via.placeholder.com/150'), // Gerçek bir resim URL'si kullanın.
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Kullanıcı Adı', // Gerçek bir kullanıcı adı kullanın.
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Kullanıcı hakkında kısa bir açıklama veya biyografi.', // Kullanıcı hakkında bilgi ekleyin.
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            // Ekstra bilgiler veya düğmeler ekleyebilirsiniz.
          ],
        ),
      ),
    );
  }
}

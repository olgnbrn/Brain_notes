import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;
  String? imageUrl;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _websiteController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _loadUserLocalData();
  }

  Future<void> _loadUserProfile() async {
    try {
      imageUrl = await FirebaseStorage.instance.ref('userProfiles/${user?.uid}/profile.jpg').getDownloadURL();
    } catch (e) {
      imageUrl = null;
    }
    setState(() {});
  }

  Future<void> _updateProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final ref = FirebaseStorage.instance.ref('userProfiles/${user?.uid}/profile.jpg');
      await ref.putFile(File(pickedFile.path));
      _loadUserProfile();
    }
  }

  Future<String> getUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        String firstName = userDoc.data()?['firstName'] ?? '';
        String lastName = userDoc.data()?['lastName'] ?? '';
        return '$firstName $lastName'.trim();
      } catch (e) {
        // Hata durumunda kullanıcıya uygun bir mesaj göster
        print('Kullanıcı bilgileri çekilemedi: $e');
        return 'Kullanıcı Bilgisi Yok';
      }
    } else {
      return 'Kullanıcı Girişi Yapılmamış';
    }
  }


  Future<void> _loadUserLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    _addressController.text = prefs.getString('address') ?? '';
    _phoneController.text = prefs.getString('phone') ?? '';
    _usernameController.text = prefs.getString('username') ?? '';
    _websiteController.text = prefs.getString('website') ?? '';
    _aboutController.text = prefs.getString('about') ?? '';
  }

  Future<void> _saveUserLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('address', _addressController.text);
    await prefs.setString('phone', _phoneController.text);
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('website', _websiteController.text);
    await prefs.setString('about', _aboutController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40),
              GestureDetector(
                onTap: _updateProfileImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
                  child: imageUrl == null ? Icon(Icons.person, size: 80, color: Colors.grey.shade800) : null,
                ),
              ),
              SizedBox(height: 20),
              FutureBuilder<String>(
                future: getUserName(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Hata: ${snapshot.error}');
                  } else {
                    return Text(
                      snapshot.data?.toUpperCase() ?? '',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 8),
              Text(
                user?.email ?? '',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 24),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Adres',
                  border: OutlineInputBorder(),
                  hintText: 'Adresinizi girin',
                ),
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Telefon Numarası',
                  border: OutlineInputBorder(),
                  hintText: 'Telefon numaranızı girin',
                ),
                keyboardType: TextInputType.phone,
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Kullanıcı Adı',
                  border: OutlineInputBorder(),
                  hintText: 'Kullanıcı adınızı girin',
                ),
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _websiteController,
                decoration: InputDecoration(
                  labelText: 'Web Sitesi',
                  border: OutlineInputBorder(),
                  hintText: 'Web sitenizin URL\'sini girin',
                ),
                keyboardType: TextInputType.url,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _aboutController,
                decoration: InputDecoration(
                  labelText: 'Hakkımda',
                  border: OutlineInputBorder(),
                  hintText: 'Kendiniz hakkında kısa bir açıklama yazın',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text('Bilgileri Kaydet'),
                onPressed: () {
                  _saveUserLocalData();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

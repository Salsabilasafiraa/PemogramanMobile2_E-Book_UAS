import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'add_book_screen.dart';
import 'notifications_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Urutan halaman sesuai urutan tombol di bawah
  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const AddBookScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea memastikan konten tidak tertutup notch atau status bar
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType
            .fixed, // Penting agar lebih dari 3 item tetap rapi
        backgroundColor: const Color(0xFFFFFBE5),
        selectedItemColor: const Color(0xFF8D6E63),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedFontSize: 12, // Mengunci ukuran font agar seragam
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 18, // Sedikit diperkecil agar pas dengan teks
              backgroundColor: Color(0xFF8D6E63),
              child: Icon(Icons.add, color: Colors.white, size: 20),
            ),
            label: 'Tambah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

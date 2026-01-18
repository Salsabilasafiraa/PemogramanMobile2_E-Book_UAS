// lib/screens/notification_screen.dart

import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  // Data dummy notifikasi
  final List<Map<String, dynamic>> notifications = const [
    {
      'title': 'Buku Baru: Senja di Pelabuhan',
      'subtitle':
          'Penulis terkenal Andreahinata baru saja merilis buku terbarunya!',
      'icon': Icons.notifications_active,
      'color': Colors.blue,
      'time': '2 jam yang lalu',
    },
    {
      'title': 'Promo Spesial 50%',
      'subtitle': 'Dapatkan diskon untuk semua buku fiksi ilmiah hari ini!',
      'icon': Icons.local_offer,
      'color': Colors.orange,
      'time': 'Kemarin',
    },
    {
      'title': 'Bab Baru Telah Dirilis',
      'subtitle': 'Lanjutkan membaca bab 5 dari buku "Komet".',
      'icon': Icons.menu_book,
      'color': Colors.green,
      'time': '3 hari yang lalu',
    },
    {
      'title': 'Perubahan Kebijakan Privasi',
      'subtitle': 'Kami telah memperbarui Syarat dan Ketentuan layanan kami.',
      'icon': Icons.info_outline,
      'color': Colors.grey,
      'time': '1 minggu yang lalu',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: Colors.pink, // Warna untuk Notifikasi
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada notifikasi saat ini.',
                style: TextStyle(color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notif = notifications[index];
                return Card(
                  elevation: 0.5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: notif['color'].withOpacity(0.1),
                      child: Icon(notif['icon'], color: notif['color']),
                    ),
                    title: Text(
                      notif['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      notif['subtitle'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      notif['time'],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      // Tambahkan navigasi atau aksi saat notifikasi diklik
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Notifikasi "${notif['title']}" diklik.',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

// lib/screens/profile_screen.dart

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy akun pengguna
    const String userName = 'Safira Salsabila ';
    const String userEmail = 'salsabilasafira691@email.com';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 20.0),
            child: Text(
              'PROFIL AKUN', // Judul diganti
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ),

          // Bagian Informasi Profil
          Center(
            child: Column(
              children: [
                // Avatar Pengguna
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[800],
                  child: const Icon(
                    Icons.person,
                    size: 70,
                    color: Colors.white,
                  ),
                  // Jika Anda punya gambar profil, ganti dengan
                  // backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                const SizedBox(height: 15),
                // Nama Pengguna
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Email
                Text(
                  userEmail,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Bagian Menu Aksi/Pengaturan (Menggantikan Deskripsi Buku)
          const Text(
            'Pengaturan Akun',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // ListTile untuk Pengaturan
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.grey),
            title: const Text('Pengaturan Aplikasi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigasi ke halaman pengaturan
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.grey),
            title: const Text('Riwayat Bacaan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigasi ke riwayat
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.grey),
            title: const Text('Bantuan & Dukungan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigasi ke bantuan
            },
          ),

          const Divider(height: 30),

          // Tombol Aksi Utama (Ganti Pengguna Akun / Logout)
          Row(
            children: [
              // Tombol Ganti Pengguna Akun
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Logika untuk beralih atau menambahkan akun
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Beralih ke halaman Ganti Pengguna.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.switch_account),
                  label: const Text('Ganti Pengguna Akun'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.grey.shade800),
                    foregroundColor: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Tombol Logout
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Logika untuk Logout
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Anda telah Logout.')),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// lib/screens/author_profile_screen.dart

import 'package:flutter/material.dart';

class AuthorProfileScreen extends StatelessWidget {
  final String authorName;
  final String authorImage;

  const AuthorProfileScreen({
    super.key,
    required this.authorName,
    required this.authorImage,
  });

  // --- Data Dummy Khusus untuk Screen Ini ---
  // Anda harus mendefinisikan data ini (atau mengambil dari API)
  final int booksCount = 12; // Contoh: jumlah postingan/buku
  final String followersCount = '125K'; // Contoh: jumlah pengikut
  final String followingCount = '120'; // Contoh: jumlah diikuti

  // Contoh daftar buku yang diterbitkan penulis ini
  final List<String> publishedBookCovers = const [
    'aldebaran.jpeg',
    'komet.jpeg',
    'matahari.jpeg',
    'hana.jpeg',
    'moon.jpeg',
    'toolate.jpeg', // Asumsi cover ini ada
    'aldebaran.jpeg',
    'komet.jpeg',
    'matahari.jpeg',
  ];
  // ------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(authorName), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER PROFIL (FOTO, NAMA, STATISTIK)
                  Row(
                    children: [
                      // Avatar Penulis
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage(
                          'assets/images/$authorImage',
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Statistik (Buku, Pengikut, Mengikuti)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatColumn(
                              booksCount.toString(),
                              'Buku Diterbitkan',
                            ),
                            _buildStatColumn(followersCount, 'Pengikut'),
                            _buildStatColumn(followingCount, 'Mengikuti'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),
                  // NAMA & BIO
                  Text(
                    authorName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Text(
                    'Penulis populer dengan karya-karya best seller.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 20),
                  // TOMBOL AKSI
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Aksi Mengikuti
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black26),
                          ),
                          child: const Text(
                            'Mengikuti',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Aksi Kirim Pesan / Kunjungi Situs Web
                          },
                          child: const Text('Kunjungi Situs Web'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // GARIS PEMISAH
            const Divider(),

            // GRID BUKU YANG DITERBITKAN
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Karya-Karya Penulis',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            // GridView untuk menampilkan buku dalam format kotak (Gallery)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 kolom per baris
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                childAspectRatio: 0.65, // Rasio lebar banding tinggi cover buku
              ),
              itemCount: publishedBookCovers.length,
              itemBuilder: (context, index) {
                final String coverAsset = publishedBookCovers[index];
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      'assets/images/$coverAsset',
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget pembantu untuk kolom statistik
  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}

// lib/screens/book_details_screen.dart

import 'package:flutter/material.dart';
import 'reader_screen.dart';

// Fungsi Utilitas Warna
Color _getDominantColor(String coverAsset) {
  // Menggunakan lowercase agar pengecekan lebih akurat
  final path = coverAsset.toLowerCase();

  if (path.contains('aldebaran')) {
    return Colors.lightGreen.shade700;
  } else if (path.contains('hana')) {
    return Colors.greenAccent.shade700;
  } else if (path.contains('komet')) {
    return Colors.amber.shade700;
  } else if (path.contains('matahari')) {
    return Colors.orange.shade700;
  } else if (path.contains('moon') || path.contains('toolate')) {
    return Colors.blueAccent.shade700;
  }
  return Colors.grey.shade700;
}

class BookDetailsScreen extends StatelessWidget {
  final String title;
  final String coverAsset;

  const BookDetailsScreen({
    super.key,
    required this.title,
    required this.coverAsset,
  });

  @override
  Widget build(BuildContext context) {
    final Color dominantColor = _getDominantColor(coverAsset);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: dominantColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Detail Buku:', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 10),

                // PERBAIKAN DI SINI:
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    coverAsset, // Langsung panggil variabelnya, jangan pakai tanda kutip
                    height: 300,
                    width: 200,
                    fit: BoxFit.cover,
                    // Tambahkan errorBuilder agar jika gambar gagal, aplikasi tidak crash
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 300,
                        width: 200,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image, size: 50),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 10),
                const Text(
                  'Anda akan mulai membaca buku ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (title.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReaderScreen(title: title),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.menu_book),
                    label: const Text('Mulai Membaca'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: dominantColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/screens/reader_screen.dart

import 'package:flutter/material.dart';

class ReaderScreen extends StatelessWidget {
  final String title;

  const ReaderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.brown.shade700,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.menu_open, size: 50, color: Colors.brown),
              const SizedBox(height: 20),
              Text(
                'Anda sedang membaca buku "$title"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Ini adalah simulasi tampilan membaca buku. Di sini Anda dapat menampilkan konten buku (teks, gambar) dan kontrol navigasi.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

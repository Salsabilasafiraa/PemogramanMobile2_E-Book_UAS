// lib/screens/explore_screen.dart

import 'package:flutter/material.dart';

// Definisi Model Data Buku Dummy (agar mudah difilter)
class Book {
  final String title;
  final String category;
  final String coverAsset;

  Book({required this.title, required this.category, required this.coverAsset});
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _searchText = '';
  String _selectedCategory = '';

  // Data Dummy LENGKAP untuk pencarian
  final List<Book> allBooks = [
    Book(
      title: 'Aldebaran',
      category: 'Fiksi Ilmiah',
      coverAsset: 'aldebaran.jpeg',
    ),
    Book(title: 'Hana Tara Haja', category: 'Romansa', coverAsset: 'hana.jpeg'),
    Book(title: 'Komet', category: 'Fantasy', coverAsset: 'komet.jpeg'),
    Book(
      title: 'Matahari Minor',
      category: 'Fiksi Ilmiah',
      coverAsset: 'matahari.jpeg',
    ),
    Book(title: 'Moon', category: 'Fantasy', coverAsset: 'moon.jpeg'),
    Book(title: 'Too Late', category: 'Romansa', coverAsset: 'toolate.jpeg'),
    // Tambahkan lebih banyak data dummy jika diperlukan
  ];

  final List<String> categories = [
    'Fiksi Ilmiah',
    'Romansa',
    'Fantasy',
    'Thriller',
  ];

  // Fungsi utama untuk memfilter buku
  List<Book> get filteredBooks {
    List<Book> filtered = allBooks;

    // Filter berdasarkan teks pencarian
    if (_searchText.isNotEmpty) {
      filtered = filtered
          .where(
            (book) =>
                book.title.toLowerCase().contains(_searchText.toLowerCase()),
          )
          .toList();
    }

    // Filter berdasarkan kategori yang dipilih
    if (_selectedCategory.isNotEmpty) {
      filtered = filtered
          .where((book) => book.category == _selectedCategory)
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Buku'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Search Bar
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchText = value;
                    _selectedCategory = ''; // Reset kategori saat mengetik
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Cari Judul, Penulis, atau ISBN...',
                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                  suffixIcon: _searchText.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _searchText = '';
                            });
                          },
                        )
                      : null,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFEFEFEF),
                ),
              ),
            ),

            // Tampilkan hasil pencarian/filter jika ada
            if (_searchText.isNotEmpty || _selectedCategory.isNotEmpty)
              _buildFilterResults(),

            // Tampilkan Kategori jika tidak ada filter aktif
            if (_searchText.isEmpty && _selectedCategory.isEmpty)
              _buildCategoryGrid(),
          ],
        ),
      ),
    );
  }

  // Widget untuk menampilkan hasil buku setelah difilter
  Widget _buildFilterResults() {
    final results = filteredBooks;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _selectedCategory.isNotEmpty
              ? 'Buku dalam Kategori: $_selectedCategory'
              : 'Hasil Pencarian (${results.length} ditemukan):',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 10),

        results.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text('Tidak ada buku yang ditemukan.'),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Tampilkan 3 buku per baris
                  childAspectRatio: 0.6, // Rasio untuk cover buku
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final book = results[index];
                  // Anda bisa bungkus dengan GestureDetector untuk navigasi ke BookDetailsScreen
                  return Column(
                    children: [
                      Image.asset(
                        'assets/images/${book.coverAsset}',
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        book.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
        const SizedBox(height: 30),
        // Tampilkan tombol reset filter
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _searchText = '';
                _selectedCategory = '';
              });
            },
            child: const Text('Reset Filter'),
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan Grid Kategori
  Widget _buildCategoryGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Kategori Populer',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                // FUNGSI: Klik kategori untuk filter
                setState(() {
                  _selectedCategory = category;
                  _searchText = ''; // Reset pencarian teks
                });
              },
              child: Card(
                color: Colors.teal.shade50,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.teal.shade100, width: 1),
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.teal.shade800,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

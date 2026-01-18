import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Wajib untuk State Management
import 'package:ebook_safira/screens/book_details_screen.dart';
import 'package:ebook_safira/screens/author_profile_screen.dart';
import '../providers/book_provider.dart'; // Import Provider yang kita buat sebelumnya

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Mengambil data dari Supabase via Provider saat layar pertama kali dimuat
    // listen: false wajib di dalam initState
    Future.microtask(
      () => Provider.of<BookProvider>(context, listen: false).fetchBooks(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mengamati perubahan data pada BookProvider
    final bookProvider = context.watch<BookProvider>();

    return Scaffold(
      body: RefreshIndicator(
        // Fitur tarik ke bawah untuk refresh data (Opsional tapi bagus untuk nilai)
        onRefresh: () => bookProvider.fetchBooks(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'HOME',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // 1. Popular Authors (Tetap Statis tidak apa-apa sebagai variasi)
              const Text(
                'Popular Authors',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildAuthorList(),

              const SizedBox(height: 30),

              // 2. New Books (Dinamis dari Supabase via Provider)
              const Text(
                'New Books (Supabase)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              // Menampilkan Loading jika data sedang diambil
              bookProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : bookProvider.books.isEmpty
                  ? const Text("Tidak ada data buku.")
                  : SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: bookProvider.books.length,
                        itemBuilder: (context, index) {
                          final book = bookProvider.books[index];
                          return _buildBookCard(context, book);
                        },
                      ),
                    ),

              const SizedBox(height: 30),

              // 3. Recommended Books (Bisa menggunakan data yang sama)
              const Text(
                'Recommended Books',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildRecommendedList(bookProvider),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper untuk Author
  Widget _buildAuthorList() {
    final List<Map<String, String>> authors = [
      {'name': 'Raditya Dika', 'image': 'assets/images/radityadika.jpeg'},
      {'name': 'Valerie', 'image': 'assets/images/valerie.jpeg'},
      {'name': 'Ika Natassa', 'image': 'assets/images/ikanatassa.jpeg'},
      {'name': 'Andrea Hinata', 'image': 'assets/images/andreahinata.jpeg'},
    ];

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: authors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AuthorProfileScreen(
                    authorName: authors[index]['name']!,
                    authorImage: authors[index]['image']!,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(authors[index]['image']!),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    authors[index]['name']!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Widget Helper untuk Card Buku (Data dari Model)
  Widget _buildBookCard(BuildContext context, dynamic book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(
              title: book.title,
              coverAsset: book.imageUrl ?? '',
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                book.imageUrl ?? 'https://via.placeholder.com/150',
                width: 150,
                height: 205,
                fit: BoxFit.cover,
                // Fallback jika gambar URL gagal dimuat
                errorBuilder: (context, error, stackTrace) =>
                    Container(width: 150, height: 205, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              book.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              book.author,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Helper untuk Recommended List
  Widget _buildRecommendedList(BookProvider provider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.books.length,
      itemBuilder: (context, index) {
        final book = provider.books[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.network(
              book.imageUrl ?? 'https://via.placeholder.com/60',
              width: 60,
              height: 90,
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            book.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(book.author),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailsScreen(
                  title: book.title,
                  coverAsset: book.imageUrl ?? '',
                ),
              ),
            );
          },
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ebook_safira/screens/book_details_screen.dart';
import 'package:ebook_safira/screens/author_profile_screen.dart';
import 'package:ebook_safira/screens/edit_book_screen.dart';
import '../providers/book_provider.dart';
import '../models/book_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Mengambil data awal dari Supabase
    Future.microtask(
      () => Provider.of<BookProvider>(context, listen: false).fetchBooks(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showDeleteDialog(
    BuildContext context,
    BookProvider provider,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Buku?"),
        content: const Text("Apakah Anda yakin ingin menghapus buku ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () async {
              await provider.deleteBook(id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();
    final books = bookProvider.books;

    return Scaffold(
      // FAB SUDAH DIHAPUS DARI SINI KARENA SUDAH PINDAH KE MAIN_SCREEN
      body: RefreshIndicator(
        onRefresh: () => bookProvider.fetchBooks(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ), // Tambahan jarak atas agar tidak terlalu mepet
              const Text(
                'HOME',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 15),

              // Search Bar (Tetap di sini sebagai identitas Home)
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  bookProvider.searchBooks(value);
                },
                decoration: InputDecoration(
                  hintText: "Search a book in the library",
                  prefixIcon: const Icon(Icons.search, color: Colors.brown),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            bookProvider.searchBooks('');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
              const SizedBox(height: 25),

              const Text(
                'Popular Authors',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildAuthorList(),
              const SizedBox(height: 30),

              const Text(
                'New Books (Supabase)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              if (bookProvider.isLoading)
                const Center(
                  child: CircularProgressIndicator(color: Colors.brown),
                )
              else if (books.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("Buku tidak ditemukan."),
                  ),
                )
              else
                SizedBox(
                  height: 280,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return _buildBookCard(context, books[index]);
                    },
                  ),
                ),

              const SizedBox(height: 30),
              const Text(
                'Recommended Books',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              if (!bookProvider.isLoading)
                _buildRecommendedList(bookProvider, books),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER: AUTHOR LIST ---
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

  // --- WIDGET HELPER: BOOK CARD (HORIZONTAL) ---
  Widget _buildBookCard(BuildContext context, Book book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookDetailsScreen(
              title: book.title,
              coverAsset: book.imageUrl ?? 'assets/images/bintang.jpg',
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
              child: Image.asset(
                book.imageUrl ?? 'assets/images/bintang.jpg',
                width: 150,
                height: 205,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 150,
                  height: 205,
                  color: Colors.grey[300],
                  child: const Icon(Icons.book, size: 50, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 150,
              child: Text(
                book.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
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

  // --- WIDGET HELPER: RECOMMENDED LIST (VERTICAL) ---
  Widget _buildRecommendedList(BookProvider provider, List<Book> books) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Image.asset(
              book.imageUrl ?? 'assets/images/bintang.jpg',
              width: 60,
              height: 90,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(width: 60, height: 90, color: Colors.grey[300]),
            ),
          ),
          title: Text(
            book.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(book.author),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditBookScreen(book: book),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteDialog(context, provider, book.id),
              ),
            ],
          ),
        );
      },
    );
  }
}

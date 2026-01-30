import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/book_model.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Book> _filteredBooks = [];
  bool _isLoading = false;
  bool _isSearching = false;

  // Getter untuk data buku dan status loading
  List<Book> get books => _isSearching ? _filteredBooks : _books;
  bool get isLoading => _isLoading;

  // --- FUNGSI SEARCH ---
  void searchBooks(String query) {
    if (query.isEmpty) {
      _isSearching = false;
      _filteredBooks = [];
    } else {
      _isSearching = true;
      _filteredBooks = _books.where((book) {
        final titleLower = book.title.toLowerCase();
        final authorLower = book.author.toLowerCase();
        final searchLower = query.toLowerCase();
        return titleLower.contains(searchLower) ||
            authorLower.contains(searchLower);
      }).toList();
    }
    notifyListeners();
  }

  // --- FUNGSI LOGIN ---
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await Supabase.instance.client
          .from('pengguna')
          .select()
          .eq('username', username)
          .eq('password', password)
          .maybeSingle();
      return response != null;
    } catch (e) {
      debugPrint("Error Login: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- FUNGSI LOGOUT ---
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      // Membersihkan data lokal agar aplikasi kembali bersih
      _books = [];
      _filteredBooks = [];
      _isSearching = false;
      debugPrint("Logout berhasil: Data lokal dibersihkan.");
    } catch (e) {
      debugPrint("Error Logout: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- 1. READ DATA ---
  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await Supabase.instance.client
          .from('list_book')
          .select();
      final List data = response as List;
      _books = data.map((b) => Book.fromJson(b)).toList();
      _isSearching = false;
    } catch (e) {
      debugPrint("Error fetching: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- 2. CREATE DATA ---
  Future<void> addBook(String judul, String penulis, String deskripsi) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Supabase.instance.client.from('list_book').insert({
        'judul_buku': judul,
        'penulis': penulis,
        'deskripsi': deskripsi,
        'gambar_cover': 'assets/images/bintang.jpg',
      });
      await fetchBooks(); // Refresh data setelah tambah
    } catch (e) {
      debugPrint("Error adding: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- 3. UPDATE DATA ---
  Future<void> updateBook(
    String id,
    String judul,
    String penulis,
    String deskripsi,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Supabase.instance.client
          .from('list_book')
          .update({
            'judul_buku': judul,
            'penulis': penulis,
            'deskripsi': deskripsi,
          })
          .eq('id', id);
      await fetchBooks(); // Refresh data setelah update
    } catch (e) {
      debugPrint("Error updating: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- 4. DELETE DATA ---
  Future<void> deleteBook(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await Supabase.instance.client.from('list_book').delete().eq('id', id);
      await fetchBooks(); // Refresh data setelah hapus
    } catch (e) {
      debugPrint("Error deleting: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

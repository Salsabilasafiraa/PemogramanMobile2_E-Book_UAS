import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/book_model.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  // Fungsi untuk mengambil data dari Supabase (Poin 3 & 4 tugas)
  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      // PERBAIKAN: Ganti 'books' menjadi 'list_book' sesuai tabel di Supabase-mu
      final response = await Supabase.instance.client
          .from('list_book')
          .select();

      final List data = response as List;

      // Mapping data menggunakan model yang sudah diperbaiki sebelumnya
      _books = data.map((b) => Book.fromJson(b)).toList();

      print(
        "Data berhasil diambil: ${_books.length} buku ditemukan",
      ); // Untuk cek di terminal
    } catch (e) {
      print("Error fetching books: $e");
    }

    _isLoading = false;
    notifyListeners();
  }
}

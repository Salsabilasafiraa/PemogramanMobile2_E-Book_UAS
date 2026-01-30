class Book {
  final String id;
  final String title;
  final String author;
  final String? imageUrl;
  final String? description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.imageUrl,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      // Mengonversi ID ke String agar aman jika di database bertipe int8
      id: json['id'].toString(),

      // Menggunakan nama kolom sesuai screenshot Supabase kamu
      title: json['judul_buku'] ?? 'No Title',
      author: json['penulis'] ?? 'Unknown Author',

      // Jika kolom gambar_cover kosong, kita beri null agar bisa dihandle errorBuilder
      imageUrl: json['gambar_cover'],

      // Pastikan nama key 'deskripsi' sesuai dengan nama kolom di tabel Supabase
      description: json['deskripsi'] ?? 'Tidak ada deskripsi untuk buku ini.',
    );
  }
}

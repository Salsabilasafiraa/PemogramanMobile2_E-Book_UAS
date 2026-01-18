class Book {
  final String id;
  final String title;
  final String author;
  final String? imageUrl;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.imageUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      // 'id', 'judul_buku', dll adalah NAMA KOLOM di Supabase kamu
      id: json['id'].toString(),
      title: json['judul_buku'] ?? 'No Title',
      author: json['penulis'] ?? 'Unknown',
      imageUrl: json['gambar_cover'],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController penulisController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  @override
  void dispose() {
    judulController.dispose();
    penulisController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  // Fungsi untuk membersihkan form setelah input
  void _clearForm() {
    judulController.clear();
    penulisController.clear();
    deskripsiController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = context.watch<BookProvider>();

    return Scaffold(
      // 1. Hilangkan AppBar jika kamu ingin tampilan bersih di tab,
      // atau biarkan tanpa tombol back (automaticallyImplyLeading: false)
      appBar: AppBar(
        title: const Text("Tambah Novel Baru"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        automaticallyImplyLeading:
            false, // Menghilangkan tombol back karena ini Tab
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: judulController,
              decoration: const InputDecoration(
                labelText: "Judul Novel",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book, color: Colors.brown),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: penulisController,
              decoration: const InputDecoration(
                labelText: "Nama Penulis",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person, color: Colors.brown),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: deskripsiController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: bookProvider.isLoading
                    ? null
                    : () async {
                        if (judulController.text.isNotEmpty &&
                            penulisController.text.isNotEmpty) {
                          try {
                            await Provider.of<BookProvider>(
                              context,
                              listen: false,
                            ).addBook(
                              judulController.text,
                              penulisController.text,
                              deskripsiController.text,
                            );

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Buku berhasil disimpan!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              // 2. Jangan pakai Navigator.pop(context) jika di Tab.
                              // Lebih baik bersihkan form agar user bisa input lagi.
                              _clearForm();
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Gagal menyimpan: $e")),
                              );
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Judul dan Penulis wajib diisi!"),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                child: bookProvider.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Simpan ke Supabase",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

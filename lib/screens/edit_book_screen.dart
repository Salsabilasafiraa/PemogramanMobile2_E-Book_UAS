import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';
import '../models/book_model.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;
  const EditBookScreen({super.key, required this.book});

  @override
  State<EditBookScreen> createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late TextEditingController judulController;
  late TextEditingController penulisController;
  late TextEditingController deskripsiController;

  @override
  void initState() {
    super.initState();
    // Mengambil data dari widget.book yang dikirim saat navigasi
    judulController = TextEditingController(text: widget.book.title);
    penulisController = TextEditingController(text: widget.book.author);
    // Menggunakan .description sesuai dengan model yang baru diperbaiki
    deskripsiController = TextEditingController(
      text: widget.book.description ?? "",
    );
  }

  @override
  void dispose() {
    judulController.dispose();
    penulisController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan watch agar UI bisa menampilkan loading spinner saat proses update
    final provider = context.watch<BookProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Novel"),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: judulController,
                decoration: const InputDecoration(
                  labelText: "Judul Novel",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: penulisController,
                decoration: const InputDecoration(
                  labelText: "Nama Penulis",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: deskripsiController,
                maxLines: 5, // Lebih luas untuk menulis deskripsi
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
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
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          // Memanggil fungsi update di provider
                          await provider.updateBook(
                            widget.book.id,
                            judulController.text,
                            penulisController.text,
                            deskripsiController.text,
                          );

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Data berhasil diperbarui!"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                  child: provider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Update Data",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

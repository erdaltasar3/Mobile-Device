import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kutuphane_otomasyon/pages/kitap_ekleme_sayfasi.dart';
import 'package:kutuphane_otomasyon/services/firestore.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // firestore
  FirestoreService firestoreService1 = FirestoreService();
  // text controller
  final TextEditingController textController = TextEditingController();

  void editBook(String docID) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KitapEkle(editingDocID: docID)),
    );
  }

  void openBookBox() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Erdal Taşar Kütüphane Yönetimi"),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KitapEkle()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService1.getBooksStream(),
        builder: (context, snapshot) {
          // if we have data, get all the docs
          if (snapshot.hasData) {
            List bookList = snapshot.data!.docs;

            // display as a list
            return ListView.builder(
              itemCount: bookList.length,
              itemBuilder: (context, index) {
                // get each individual doc
                DocumentSnapshot document = bookList[index];
                String docID = document.id;

                // get book from each doc
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                String bookText = data["book"];
                String yazarAdi = data["yazar"];
                String sayfaSayisi = data["sayfaSayisi"];

                return Card(
                  child: ListTile(
                    title: Text(bookText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => editBook(docID),
                          icon: const Icon(Icons.settings),
                        ),
                        IconButton(
                          onPressed: () => firestoreService1.deleteBook(docID),
                          icon: const Icon(Icons.delete),
                        )
                      ],
                    ),
                    subtitle:
                        Text("yazar : $yazarAdi, sayfa sayisi $sayfaSayisi"),
                  ),
                );

                // display as a list tile
              },
            );
          }

          // if there is not data
          else {
            return const Text("no books...");
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 100,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.book),
                  color: Colors.purpleAccent,
                ),
                const Text("Kitaplar")
              ],
            ),
            Column(
              children: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
                const Text("Satin Al")
              ],
            ),
            Column(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
                const Text("Ayarlar")
              ],
            ),
          ],
        ),
      ),
    );
  }
}

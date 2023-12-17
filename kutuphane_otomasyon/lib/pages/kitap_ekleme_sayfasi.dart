import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kutuphane_otomasyon/services/firestore.dart';

class KitapEkle extends StatefulWidget {
  final String? editingDocID;

  const KitapEkle({Key? key, this.editingDocID}) : super(key: key);

  @override
  State<KitapEkle> createState() => _KitapEkleState();
}

class _KitapEkleState extends State<KitapEkle> {
  FirestoreService firestoreService = FirestoreService();

  final TextEditingController kitapAdiText = TextEditingController();
  final TextEditingController yayineviText = TextEditingController();
  final TextEditingController yazarText = TextEditingController();
  final TextEditingController kategoriText = TextEditingController();
  final TextEditingController sayfaSayisiText = TextEditingController();
  final TextEditingController basimYiliText = TextEditingController();

  String veri = "Roman";
  bool isChecked = false;
  List<String> categories = [
    'Roman',
    'Tarih',
    'Edebiyat',
    'Şiir',
    'Ansiklopedi',
  ];

  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    if (widget.editingDocID != null) {
      loadBookData();
    }
  }

  void loadBookData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("books")
        .doc(widget.editingDocID)
        .get();

    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    setState(() {
      kitapAdiText.text = data["book"];
      yayineviText.text = data["yayinEvi"];
      yazarText.text = data["yazar"];
      veri = data["kategori"];
      sayfaSayisiText.text = data["sayfaSayisi"];
      basimYiliText.text = data["basimYili"];
      isChecked = data["isChecked"] ?? false;
    });
  }

  void updateBook(String docID) {
    firestoreService.updateBook(
      docID,
      kitapAdiText.text,
      yayineviText.text,
      yazarText.text,
      veri,
      sayfaSayisiText.text,
      basimYiliText.text,
      isChecked,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Kitap Ekle"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: kitapAdiText,
                    decoration: const InputDecoration(
                      hintText: "Kitap adi",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: yayineviText,
                    decoration: const InputDecoration(
                      hintText: "Yayinevi",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: yazarText,
                    decoration: const InputDecoration(
                      hintText: "Yazarlar",
                    ),
                  ),
                ),
                DropdownButtonFormField(
                  value: 'Roman',
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      veri = value.toString();
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Kategori Seçin',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: sayfaSayisiText,
                    decoration: const InputDecoration(
                      labelText: "Sayfa Sayisi",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: basimYiliText,
                    decoration: const InputDecoration(
                      labelText: "Basim Yili",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    children: [
                      const Text("Listede yayinlanacak mi"),
                      Checkbox(
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, right: 300),
                  child: ElevatedButton(
                    onPressed: () {
                      if (isChecked) {
                        if (widget.editingDocID != null) {
                          updateBook(widget.editingDocID!);
                        } else {
                          firestoreService.addBook(
                            kitapAdiText.text,
                            yayineviText.text,
                            yazarText.text,
                            veri,
                            sayfaSayisiText.text,
                            basimYiliText.text,
                          );
                        }

                        // clear text controllers
                        kitapAdiText.clear();
                        yayineviText.clear();
                        yazarText.clear();
                        kategoriText.clear();
                        sayfaSayisiText.clear();
                        basimYiliText.clear();

                        // close page
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text("Kaydet"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

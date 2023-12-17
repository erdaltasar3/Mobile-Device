import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
// kitap koleksiyonunu al
  final CollectionReference books =
      FirebaseFirestore.instance.collection("books");

// CREATE : yeni bir kitap ekle
  Future<void> addBook(
    String bookName,
    String yayinEvi,
    String yazar,
    String kategori,
    String sayfaSayisi,
    String basimYili,
  ) {
    return books.add(
      {
        "book": bookName,
        "yayinEvi": yayinEvi,
        "yazar": yazar,
        "kategori": kategori,
        "sayfaSayisi": sayfaSayisi,
        "basimYili": basimYili,
        "timestamp": Timestamp.now(),
      },
    );
  }

// READ: veritabanından kitap bilgilerini al

  Stream<QuerySnapshot> getBooksStream() {
    final booksStream =
        books.orderBy("timestamp", descending: true).snapshots();
    return booksStream;
  }

// GÜNCELLEME: id verilen kitapları güncelleyin
  Future<void> updateBook(
    String docID,
    String bookName,
    String yayinEvi,
    String yazar,
    String kategori,
    String sayfaSayisi,
    String basimYili,
    bool isChecked,
  ) {
    return books.doc(docID).update(
      {
        "book": bookName,
        "yayinEvi": yayinEvi,
        "yazar": yazar,
        "kategori": kategori,
        "sayfaSayisi": sayfaSayisi,
        "basimYili": basimYili,
        "isChecked": isChecked,
        "timestamp": FieldValue.serverTimestamp(),
      },
    );
  }

// DELETE: id verilen kitapları silin
  Future<void> deleteBook(String docID) {
    return books.doc(docID).delete();
  }
}

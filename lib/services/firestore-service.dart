import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/model/record.dart';
import 'package:flutter_firebase_auth/services/service.dart';

class FirestoreService implements Service {
  final Firestore _firestore = Firestore.instance;

  String _rootCollection = 'babynames';

  Stream<QuerySnapshot> getSnapshots(String collection) {
    return _firestore.collection(collection).snapshots();
  }

  updateSnapshot(DocumentReference reference) async {
    // use transactions when you're sure users might change a document at the same time
    // to avoid inconsistent data
    _firestore.runTransaction((transaction) async {
      final newSnapshot = await transaction.get(reference);
      final record = Record.fromSnapshot(newSnapshot);

      await transaction.update(reference, {'votes': record.votes + 1});
    });
  }

  Future<void> addBabyName(String babyName) {
    return _firestore
        .collection(_rootCollection)
        .document(babyName.toLowerCase())
        .setData({'name': babyName, 'votes': 0});
  }

  Future<void> deleteRecord(DocumentReference reference) async {
    _firestore.runTransaction((transaction) async {
      final newSnapshot = await transaction.get(reference);
      final record = Record.fromSnapshot(newSnapshot);

      await transaction.delete(reference);
    });
  }

  Future<void> updateBabyName(DocumentReference ref, String babyName) async {
    _firestore.runTransaction((transaction) async {
      final newSnapshot = await transaction.get(ref);
      final record = Record.fromSnapshot(newSnapshot);

      await transaction.update(ref, {'name': babyName});
    });
  }
}

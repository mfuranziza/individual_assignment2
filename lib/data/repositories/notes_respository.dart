import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:individual_assignment2/data/models/note_model.dart';
import 'package:individual_assignment2/domain/entities/note.dart';
import 'package:uuid/uuid.dart';

class NotesRepository {
  final FirebaseFirestore _firestore;
  final Uuid _uuid = const Uuid();

  NotesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Note>> fetchNotes(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('notes')
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => NoteModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch notes: ${e.toString()}');
    }
  }

  Future<void> addNote(String text, String userId) async {
    try {
      final noteId = _uuid.v4();
      final now = DateTime.now();
      final note = NoteModel(
        id: noteId,
        text: text,
        createdAt: now,
        updatedAt: now,
        userId: userId,
      );

      await _firestore.collection('notes').doc(noteId).set(note.toFirestore());
    } catch (e) {
      throw Exception('Failed to add note: ${e.toString()}');
    }
  }

  Future<void> updateNote(String id, String text) async {
    try {
      await _firestore.collection('notes').doc(id).update({
        'text': text,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update note: ${e.toString()}');
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await _firestore.collection('notes').doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete note: ${e.toString()}');
    }
  }
}

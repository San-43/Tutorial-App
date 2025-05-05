import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserFirestoreService {
  static final UserFirestoreService _instance = UserFirestoreService._internal();
  factory UserFirestoreService() => _instance;
  UserFirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save user to Firestore after registration
  Future<void> createUser({
    required String uid,
    required String name,
    required String email,
    required String urlPhoto,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'urlPhoto': urlPhoto,
      'quiz': false,
      'progress': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update the quiz and progress fields for the currently logged-in user
  Future<void> updateProgressAndQuiz({
    required int progress,
    required bool quiz,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'progress': progress,
      'quiz': quiz,
    });
  }

  /// Update only the urlPhoto field
  Future<void> updateUrlPhoto({
    required String urlPhoto,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'urlPhoto': urlPhoto,
    });
  }

  /// Increment progress value by a specific amount
  Future<void> incrementProgress(int amount) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'progress': FieldValue.increment(amount),
    });
  }

  /// Retrieve the current user's progress (defaults to 0 if not set)
  Future<int> getProgress() async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return 0;

    final data = doc.data();
    return (data?['progress'] as int?) ?? 0;
  }

  /// Retrieve the current user's quiz completion status (defaults to false if not set)
  Future<bool> getQuiz() async {
    final user = _auth.currentUser;
    if (user == null) return false;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return false;

    final data = doc.data();
    return (data?['quiz'] as bool?) ?? false;
  }
}

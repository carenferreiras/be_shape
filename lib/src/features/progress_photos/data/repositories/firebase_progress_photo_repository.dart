// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../features.dart';

class FirebaseProgressPhotoRepository implements ProgressPhotoRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  FirebaseProgressPhotoRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _auth = auth ?? FirebaseAuth.instance;

  @override
  Future<void> addProgressPhoto(ProgressPhoto photo) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Create a new document reference with auto-generated ID
      final docRef = _firestore.collection('progress_photos').doc();
      
      // Update the photo with the new ID and ensure userId is set
      final updatedPhoto = photo.copyWith(
        id: docRef.id,
        userId: userId,
      );
      
      // Save to Firestore
      await docRef.set(updatedPhoto.toJson());
    } catch (e) {
      print('Error adding progress photo: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteProgressPhoto(String id) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final doc = await _firestore.collection('progress_photos').doc(id).get();
      if (doc.exists) {
        final photo = ProgressPhoto.fromJson(doc.data()!);
        // Verify ownership
        if (photo.userId != userId) {
          throw Exception('Not authorized to delete this photo');
        }
        
        // Delete photo from storage
        if (photo.photoUrl.isNotEmpty) {
          await _storage.refFromURL(photo.photoUrl).delete();
        }
        // Delete document from Firestore
        await _firestore.collection('progress_photos').doc(id).delete();
      }
    } catch (e) {
      print('Error deleting progress photo: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProgressPhoto>> getProgressPhotosByDate(DateTime date) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await _firestore
          .collection('progress_photos')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('date', isLessThan: endOfDay.toIso8601String())
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ProgressPhoto.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting progress photos by date: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProgressPhoto>> getProgressPhotosByDateRange(
      DateTime start, DateTime end) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final snapshot = await _firestore
          .collection('progress_photos')
          .where('userId', isEqualTo: userId)
          .where('date', isGreaterThanOrEqualTo: start.toIso8601String())
          .where('date', isLessThan: end.toIso8601String())
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ProgressPhoto.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting progress photos by date range: $e');
      rethrow;
    }
  }

  @override
  Future<List<ProgressPhoto>> getProgressPhotosByType(String type) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final snapshot = await _firestore
          .collection('progress_photos')
          .where('userId', isEqualTo: userId)
          .where('type', isEqualTo: type)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ProgressPhoto.fromJson(data);
      }).toList();
    } catch (e) {
      print('Error getting progress photos by type: $e');
      if (e is FirebaseException && e.code == 'failed-precondition') {
        print('Missing index. Create the following index in Firebase Console:');
        print('Collection: progress_photos');
        print('Fields to index:');
        print('- userId (Ascending)');
        print('- type (Ascending)');
        print('- date (Descending)');
      }
      rethrow;
    }
  }

  @override
  Future<String> uploadPhoto(String filePath) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final file = File(filePath);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('progress_photos/$userId/$fileName');
      
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading photo: $e');
      rethrow;
    }
  }
}
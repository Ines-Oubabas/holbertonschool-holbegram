import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../models/post.dart';
import '../../auth/methods/user_storage.dart';

class PostStorage {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String caption,
    String uid,
    String username,
    String profImage,
    Uint8List image,
  ) async {
    String res = 'Some error occurred';

    try {
      final String postUrl = await StorageMethods().uploadImageToStorage(
        true,
        'posts',
        image,
      );

      final String postId = const Uuid().v1();

      Post post = Post(
        caption: caption,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: postUrl,
        profImage: profImage,
      );

      await _firestore.collection('posts').doc(postId).set(post.toJson());

      res = 'ok';
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> savePost(String uid, String postId, List saved) async {
    try {
      if (saved.contains(postId)) {
        await _firestore.collection('users').doc(uid).update({
          'saved': FieldValue.arrayRemove([postId]),
        });
      } else {
        await _firestore.collection('users').doc(uid).update({
          'saved': FieldValue.arrayUnion([postId]),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePost(String postId, String publicId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      rethrow;
    }
  }
}
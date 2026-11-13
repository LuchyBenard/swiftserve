import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// Uploads media to Firebase Storage.
///
/// When Firebase is not configured (tests/offline preview) the local file path
/// is returned unchanged so existing `Image.file` previews keep working.
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  FirebaseStorage? _storageInstance;

  FirebaseStorage get _storage => _storageInstance ??= FirebaseStorage.instance;

  bool get isReady => Firebase.apps.isNotEmpty;

  Future<String> uploadFile(
    File file, {
    required String folder,
    String? contentType,
  }) async {
    if (!isReady) return file.path;

    try {
      final fileName =
          '${DateTime.now().microsecondsSinceEpoch}_${file.uri.pathSegments.last}';
      final ref = _storage.ref().child(folder).child(fileName);
      final task = await ref.putFile(
        file,
        SettableMetadata(contentType: contentType),
      );
      return await task.ref.getDownloadURL();
    } catch (_) {
      // Keep the UI functional if storage is misconfigured.
      return file.path;
    }
  }

  Future<String> uploadBytes(
    Uint8List bytes, {
    required String folder,
    required String fileName,
    String? contentType,
  }) async {
    if (!isReady) return '';

    try {
      final ref = _storage.ref().child(folder).child(fileName);
      final task = await ref.putData(
        bytes,
        SettableMetadata(contentType: contentType),
      );
      return await task.ref.getDownloadURL();
    } catch (_) {
      return '';
    }
  }

  Future<void> deleteByUrl(String downloadUrl) async {
    if (!isReady) return;
    try {
      await _storage.refFromURL(downloadUrl).delete();
    } catch (_) {}
  }
}

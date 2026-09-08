import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class StorageService {
  Future<Directory> _photosDir() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docsDir.path, 'profile_photos'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<String> uploadProfilePhoto(String uid, File file) async {
    final dir = await _photosDir();
    final destPath = p.join(dir.path, '$uid.jpg');
    final saved = await file.copy(destPath);
    return saved.path;
  }

  Future<void> deleteProfilePhoto(String uid) async {
    final dir = await _photosDir();
    final file = File(p.join(dir.path, '$uid.jpg'));
    if (await file.exists()) {
      await file.delete();
    }
  }
}

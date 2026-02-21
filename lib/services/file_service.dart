import 'dart:io';
import 'package:instagram_clone/services/prefs.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FileService {
  static final _storage = SupabaseClient(
    'https://gdgouxislhxtvilncrkk.supabase.co',
    "sb_secret_731bkOX3lJ8MMnYGSaQ5AA_1-iAw22d",
  ).storage;
  static const _folderUser = "user_images";
  static const _folderPost = "post_images";
  static const _bucketName = "images"; // 🔁 Replace with your bucket name

  static Future<String> uploadUserImage(File image) async {
    final String uid = (await Prefs.loadUserId())!;
    final String imgPath =
        "$_folderUser/${uid}_${DateTime.now().toIso8601String()}";

    await _storage
        .from(_bucketName)
        .upload(imgPath, image, fileOptions: const FileOptions(upsert: true));

    final String downloadUrl = _storage.from(_bucketName).getPublicUrl(imgPath);

    print(downloadUrl);
    return downloadUrl;
  }

  static Future<String> uploadPostImage(File image) async {
    final String uid = (await Prefs.loadUserId())!;
    final String imgPath =
        "$_folderPost/${uid}_${DateTime.now().millisecondsSinceEpoch}";

    await _storage
        .from(_bucketName)
        .upload(imgPath, image, fileOptions: const FileOptions(upsert: false));

    final String downloadUrl = _storage.from(_bucketName).getPublicUrl(imgPath);

    print(downloadUrl);
    return downloadUrl;
  }
}

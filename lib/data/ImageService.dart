import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageService {
  static Future<String> uploadImage(File imageFile, String imageName) async {
    try {
      String storagePath = 'images/$imageName';

      // Upload the file to Firebase Storage at the specified path
      await firebase_storage.FirebaseStorage.instance
          .ref(storagePath)
          .putFile(imageFile);

      // Retrieve the download URL for the uploaded image
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref(storagePath)
          .getDownloadURL();

      // Return the download URL
      return downloadURL;
    } catch (e) {
      print(e); // Consider better error handling for production code
      throw Exception("Error uploading image: $e");
    }
  }
}

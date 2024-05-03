import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';

class ImageDecoration extends StatelessWidget {
  final String imagePath;
  // Define the path for the default image that will be used if the specified image doesn't exist
  final String defaultImageAssetPath = "images/No_Image.png";

  const ImageDecoration({super.key, required this.imagePath});

  Future<String> _getImageUrl(String imageName) async {
    // First, check if the specified image exists in the local assets
    try {
      // The following line attempts to load the asset and will throw an exception if it doesn't exist
      await rootBundle.load("images/$imageName");
      // If the asset exists, return its path for AssetImage
      return "images/$imageName";
    } catch (_) {
      // If the asset doesn't exist, check Firebase Storage
      try {
        final downloadUrl = await firebase_storage.FirebaseStorage.instance
            .ref('images/$imageName')
            .getDownloadURL();
        // If found in Firebase Storage, return the URL for NetworkImage
        return downloadUrl;
      } catch (_) {
        // If not found in Firebase Storage either, return the default asset path
        return defaultImageAssetPath;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getImageUrl(imagePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          // Determine the type of image source based on what _getImageUrl returned
          // Determine the type of image source based on what _getImageUrl returned
          final imageSource = snapshot.data!;
          ImageProvider<Object> imageProvider;
          if (imageSource.startsWith('http')) {
            imageProvider = NetworkImage(imageSource); // Cast for clarity
          } else {
            imageProvider = AssetImage(imageSource); // Cast for clarity
          }
          return _buildImageContainer(context, imageProvider);

        } else {
          // While waiting or if an error occurs, display the default image
          return _buildImageContainer(context, AssetImage(defaultImageAssetPath));
        }
      },
    );
  }

  Widget _buildImageContainer(BuildContext context, ImageProvider image) {
    return Container(
      height: 200,
      width: 0.8 * MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: image,
        ),
        border: Border.all(width: 6, color: Colors.yellow),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../data/stadium_model.dart';
import '../screens/StadiumDetailScreen.dart';
import 'AppStyles.dart';

class MyRoundedStadiumInfo extends StatelessWidget {
  final Stadium? stadium;
  final String defaultImagePath = "images/No_Image.png"; // Path for the default image

  const MyRoundedStadiumInfo({super.key, required this.stadium});

  Future<String> getImageUrl(String imageName) async {
    try {
      // Assuming imageName contains the file name like 'nawras.jpeg'
      final downloadUrl = await firebase_storage.FirebaseStorage.instance
          .ref('images/$imageName') // images/ directory in your Firebase Storage
          .getDownloadURL();
      return downloadUrl; // This URL is directly usable in NetworkImage
    } catch (e) {
      print("Error getting image URL from Firebase: $e");
      return defaultImagePath; // Return default image path if Firebase fetch fails
    }
  }

  @override
  Widget build(BuildContext context) {
    String assetPath = "images/${stadium?.stadiumData?.imagePath ?? defaultImagePath}";

    return GestureDetector(
      onTap: () {
        if (stadium != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StadiumDetailScreen(stadium: stadium!),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          height: 475,
          width: 0.75 * MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.lime,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: FutureBuilder<String>(
                  future: getImageUrl(stadium?.stadiumData?.imagePath ?? ''),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    // Initialize an ImageProvider, explicitly typed as ImageProvider<Object>
                    ImageProvider<Object> imageProvider;

                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      // Determine whether to use AssetImage or NetworkImage based on the snapshot data
                      imageProvider = snapshot.data == defaultImagePath
                          ? AssetImage(snapshot.data!) as ImageProvider<Object> // Explicitly cast to ImageProvider<Object>
                          : NetworkImage(snapshot.data!) as ImageProvider<Object>; // Explicitly cast to ImageProvider<Object>
                    } else {
                      // Fallback to a local asset (or default image) if the snapshot doesn't contain valid data
                      imageProvider = AssetImage(assetPath) as ImageProvider<Object>; // Explicitly cast to ImageProvider<Object>
                    }

                    // Container for displaying the image
                    return Container(
                      height: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.yellow,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: imageProvider, // Use the determined ImageProvider
                        ),
                      ),
                    );
                  },
                ),
              ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Stack(
                    children: [
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.amberAccent,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name:",
                                    style: AppStyles.headlineStyle1,
                                  ),
                                  Text(
                                    "Players:",
                                    style: AppStyles.headlineStyle1,
                                  ),
                                  Text(
                                    "Price:",
                                    style: AppStyles.headlineStyle1,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    stadium!.stadiumData!.name.toString(),
                                    style: AppStyles.headlineStyle1,
                                  ),
                                  Text(
                                    stadium!.stadiumData!.playersNumber.toString(),
                                    style: AppStyles.headlineStyle1,
                                  ),
                                  Text(
                                    stadium!.stadiumData!.ticketPrice.toString(),
                                    style: AppStyles.headlineStyle1,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    // );
  }

  goToDetail(BuildContext context) {
    if (stadium != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StadiumDetailScreen(stadium: stadium!),
        ),
      );
    }
  }
}

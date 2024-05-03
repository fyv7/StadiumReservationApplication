import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'stadium_model.dart';

class DatabaseHelper {
  static Future<void> deleteStadium(String key) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    await databaseReference.child("Studioms").child(key).remove();
  }

  static Future<void> updateStadiumData(
      String key, StadiumData stadiumData, BuildContext context) async {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    await databaseReference
        .child("Studioms")
        .child(key)
        .update(stadiumData.toJson());
  }

  static Future<void> saveDataItem(StadiumData stadiumData) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    return databaseReference
        .child('Studioms')
        .push()
        .set(stadiumData.toJson())
        .then((value) => print("Stadium data saved successfully!"))
        .catchError((error) => print("Failed to save Stadium data: $error"));
  }

  static Future<void> addNewStadium(StadiumData stadiumData) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    String stadiumNameKey = stadiumData.name?.trim() ?? "Unnamed_Stadium";
    return databaseReference
        .child('Studioms')
        .child(stadiumNameKey)
        .set(stadiumData.toJson())
        .then((value) => print("stadium $stadiumNameKey created successfully!"))
        .catchError((error) => print("Failed to create stadium data: $error"));
  }

  static void readFirebaseRealtimeDBMain(
      Function(List<Stadium>) stadiumListCallback) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
    databaseReference.child("Studioms").onValue.listen((stadiumDataJson) {
      if (stadiumDataJson.snapshot.exists) {
        StadiumData stadiumData;
        Stadium stadium;
        List<Stadium> stadiumList = [];
        stadiumDataJson.snapshot.children.forEach((element) {
          stadiumData = StadiumData.fromJson(element.value as Map);
          stadium = Stadium(element.key, stadiumData);
          stadiumList.add(stadium);
        });
        stadiumListCallback(stadiumList);
      } else {
        print("The data snapshot does not exist!");
      }
    });
  }

  static void createFirebaseRealtimeDBWithUniqueIDs(
      String mainNodeName, List<Map<String, dynamic>> stadiumList) {
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref(mainNodeName);

    if (stadiumList.isNotEmpty) {
      stadiumList.forEach((stadium) {
        String stadiumName = stadium['name'];
        databaseReference
            .child(stadiumName) // Use the unique name as the key
            .set(stadium)
            .then((value) => print("$stadiumName data successfully saved!"))
            .catchError((error) => print("Failed to write message: $error"));
      });
    } else {
      print("stadium list is empty!");
    }
  }
}

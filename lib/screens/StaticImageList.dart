import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shareable/ImageDecoration.dart';
class StaticImageList extends StatelessWidget {
  const StaticImageList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ImageDecoration(imagePath: "alhoson.jpeg"),
              SizedBox(height: 20),
              ImageDecoration(imagePath: "aljabal.jpeg"),
              SizedBox(height: 20),
              ImageDecoration(imagePath: "alnor.jpeg"),
              SizedBox(height: 20),
              ImageDecoration(imagePath: "alnosor.jpeg"),
              SizedBox(height: 20),
              ImageDecoration(imagePath: "shabab.jpeg"),
              SizedBox(height: 20),
              ImageDecoration(imagePath: "nawras.jpeg"),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../data/DatabaseHelper.dart';

import '../data/stadium_model.dart';
import '../shareable/MyRoundedStadiumInfo.dart';

class MyDynamicImageListScreen extends StatefulWidget {
  const MyDynamicImageListScreen({super.key});

  @override
  State<MyDynamicImageListScreen> createState() =>
      _MyDynamicImageListScreenState();
}

class _MyDynamicImageListScreenState extends State<MyDynamicImageListScreen> {
  List<Stadium> stadiumList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseHelper.readFirebaseRealtimeDBMain((stadiumList) {
      setState(() {
        this.stadiumList = stadiumList;
        print(this.stadiumList.first.stadiumData?.name);
        print(this.stadiumList);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        //padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: ListView(
          children: [
            SingleChildScrollView(
             scrollDirection: Axis.vertical,
             //child: Row(
              child: Column(
                children: [
                  //const Gap(20),
                  const SizedBox(height: 20,),
                  for (int i = 0; i < stadiumList.length; i++) ...{
                    MyRoundedStadiumInfo(stadium: stadiumList[i]),
                   // const Gap(20),
                    const SizedBox(height: 20,),
                  }
                ],
              ),
            ),
          ],
        ),
      )),

    );
  }
}

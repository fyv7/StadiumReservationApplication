import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../data/DatabaseHelper.dart';
import '../data/stadium_model.dart';
import '../main.dart';
import '../shareable/AppStyles.dart';
import '../shareable/Helper.dart';
import '../shareable/ImageDecoration.dart';
import 'StadiumCreationUpdateScreen.dart';
import 'MapScreen.dart';

class StadiumDetailScreen extends StatefulWidget {
  final Stadium stadium;

  const StadiumDetailScreen({super.key, required this.stadium});

  @override
  State<StadiumDetailScreen> createState() => _StadiumDetailScreenState();
}

class _StadiumDetailScreenState extends State<StadiumDetailScreen> {
  int _ticketQuantity = 1;
  double _ticketPrice = 0, _runningCost = 0;

  @override
  Widget build(BuildContext context) {
    _ticketPrice = widget.stadium.stadiumData?.ticketPrice ?? 0.0;
    _runningCost = _ticketQuantity * _ticketPrice;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.stadium.stadiumData?.name ?? 'Stadium Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Displaying the local image
            widget.stadium.stadiumData?.imagePath != null
                ? ImageDecoration(
                    imagePath: widget.stadium.stadiumData!.imagePath!)
                : const SizedBox(height: 200, child: Placeholder()),

            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Name: ",
                  style: AppStyles.headlineStyle1,
                ),
                Text(
                  widget.stadium.stadiumData?.name ?? 'N/A',
                  style: AppStyles.headlineStyle2,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Place: ${widget.stadium.stadiumData?.place ?? 'N/A'}',
              style: AppStyles.headlineStyle2,
            ),
            Text(
              'Players No#: ${widget.stadium.stadiumData?.playersNumber ?? 'N/A'}',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown),
            ),
            Text(
              'Ticket Price: \$${widget.stadium.stadiumData?.ticketPrice?.toStringAsFixed(2) ?? 'N/A'}',
              style: AppStyles.headlineStyle2,
            ),
            const SizedBox(height: 20),
            Text(
              'Select Ticket Quantity:',
              style: AppStyles.headlineStyle2,
            ),
            Slider(
              value: _ticketQuantity.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: _ticketQuantity.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _ticketQuantity = value.toInt();
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Total Cost: OMR ${_runningCost.toStringAsFixed(2)}',
              style: AppStyles.headlineStyle1,
            ),
            const SizedBox(height: 20),

            // Add RatingBar here
            RatingBar.builder(
              initialRating: widget.stadium.stadiumData?.starRating ?? 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                widget.stadium.stadiumData?.starRating = rating;
                DatabaseHelper.updateStadiumData(
                    widget.stadium.key!, widget.stadium.stadiumData!, context);
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _showNotification, icon: const Icon(Icons.notification_add),),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: _sendSMS, icon: const Icon(Icons.sms_outlined)),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: _sendEmail,
                    icon: const Icon(Icons.email_outlined)),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: _displayMap,
                    icon: const Icon(Icons.map_outlined))
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: updateStadium, child: const Text("Update")),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _deleteStadium();
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: const Row(
                mainAxisSize: MainAxisSize.min, // Use min size for the Row
                children: [
                  Icon(Icons.delete), // Delete icon
                  SizedBox(width: 8), // Space between icon and text
                  Text('Delete Stadium'), // Button text
                ],
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.home),
                  const SizedBox(width: 8),
                  Text("Back to Main", style: AppStyles.headlineStyle2,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _deleteStadium() {
    if (widget.stadium.key != null && widget.stadium.stadiumData?.name != null) {
      String stadiumName = widget.stadium.stadiumData!.name!;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content:
                Text('Are you sure you want to delete the stadium $stadiumName?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
              TextButton(
                onPressed: (){
                  DatabaseHelper.deleteStadium(widget.stadium.key!);
                  Navigator.of(context).pop(); // Close the dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$stadiumName stadium deleted')),
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage(initialIndex: 1)),
                        (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Delete'),
              ),
            ],
          );
        },
      );
    }
  }

  _showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('ID', 'Booking',
        channelDescription: 'book a ticket',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Purchase Confirmation',
        'Thank you for buying $_ticketQuantity tickets for a total of OMR ${_runningCost.toStringAsFixed(2)}',
        platformChannelSpecifics,
        payload: 'item x');
  }

  _sendSMS() {
    Helper.sendSMS(
        "0096892344419",
        "I would like to book a visit to the"
            " ${widget.stadium.stadiumData!.name} stadium.",
        context);
  }

  void _sendEmail() {
    Helper.sendEmail(
        "s128121@student.squ.edu.om",
        "Booking Request for ${widget.stadium.stadiumData!.name} stadium",
        "Hello,\n\nI would like to book a visit to the "
            "${widget.stadium.stadiumData!.name} stadium.\n\nThank you.",
        context);
  }

  void _displayMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MapScreen(
            stadium: widget.stadium,
          )),
    );
  }

  void updateStadium() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>  StadiumCreationUpdateScreen(isUpdate: true, stadium: widget.stadium,),
      ),
    );
  }
}

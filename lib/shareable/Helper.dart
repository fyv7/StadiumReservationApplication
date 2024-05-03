import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper{
  static Future<void> sendEmail(String emailAddress, String subject, String body, BuildContext context) async {
    final String encodedSubject = Uri.encodeComponent(subject);
    final String encodedBody = Uri.encodeComponent(body);
    final String mailtoUrl = "mailto:$emailAddress?subject=$encodedSubject&body=$encodedBody";
    if (await canLaunchUrl(Uri.parse(mailtoUrl))) {
      await launchUrl(Uri.parse(mailtoUrl));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to send email. Please check your device's capabilities."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  static Future<void> sendSMS(
      String phoneNumber, String message, BuildContext context) async {
      String smsUrl = "sms:$phoneNumber?body=$message";
      if (await canLaunch(smsUrl)) {
        await launch(smsUrl);
      } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              "Failed to send SMS. Please check your device's capabilities."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
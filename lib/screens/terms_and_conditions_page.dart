import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: const SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms and Conditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              '1. Acceptance of Terms',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'By accessing and using the Turf Booking App, you agree to be bound by these Terms and Conditions. If you do not agree with any part of these terms, please do not use the application.',
            ),
            SizedBox(height: 20),
            Text(
              '2. Booking Rules',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '• Bookings must be made at least 2 hours in advance\n'
              '• Cancellations must be made 24 hours before the scheduled time\n'
              '• Payment is required at the time of booking\n'
              '• Users must arrive 15 minutes before their scheduled time',
            ),
            SizedBox(height: 20),
            Text(
              '3. User Responsibilities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Users are responsible for:\n'
              '• Maintaining accurate profile information\n'
              '• Following facility rules and regulations\n'
              '• Reporting any issues or damages\n'
              '• Ensuring proper conduct during usage',
            ),
          ],
        ),
      ),
    );
  }
}

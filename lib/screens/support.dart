import 'package:flutter/material.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How can we help you?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Contact Us'),
                subtitle: const Text('+1 (555) 123-4567'),
                onTap: () {
                  // Add phone call functionality
                },
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email Support'),
                subtitle: const Text('support@turfbooking.com'),
                onTap: () {
                  // Add email functionality
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'FAQ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              title: const Text('How do I book a turf?'),
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'To book a turf, simply select your preferred date and time slot, choose the turf, and proceed with the payment. You will receive a confirmation email once the booking is complete.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('What is the cancellation policy?'),
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Cancellations must be made at least 24 hours before the scheduled time to receive a full refund. Late cancellations may be subject to charges.',
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('How do I report an issue?'),
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'You can report issues through the app by going to your booking history and selecting "Report Issue" or by contacting our support team directly.',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

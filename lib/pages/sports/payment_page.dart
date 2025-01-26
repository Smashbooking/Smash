import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';
import 'package:intl/intl.dart';

class PaymentPage extends StatefulWidget {
  // final String bookingId;
  // final double totalPrice;
  final Map<String, dynamic> bookingDetails;
  const PaymentPage({super.key, required this.bookingDetails});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  String? _bookingId;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clear all event listeners
    super.dispose();
  }

  Future<String> createBooking() async {
    try {
      final bookingId =
          FirebaseFirestore.instance.collection('bookings').doc().id;

      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .set({
        'bookingId': bookingId,
        'userId': widget.bookingDetails['userId'],
        'venueId': widget.bookingDetails['venueId'],
        'venueName': widget.bookingDetails['venueName'],
        'sportId': widget.bookingDetails['sportId'],
        'date': Timestamp.fromDate(widget.bookingDetails['date']),
        'startTime': widget.bookingDetails['startTime'],
        'endTime': widget.bookingDetails['endTime'],
        'duration': widget.bookingDetails['duration'],
        'totalPrice': widget.bookingDetails['totalPrice'],
        'status': 'confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return bookingId;
    } catch (error) {
      log("Error creating booking: $error");
      throw error;
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      // Create booking after successful payment
      final bookingId = await createBooking();
      _bookingId = bookingId;

      // Store payment details
      await storePaymentDetails(
        userId: widget.bookingDetails['userId'],
        bookingId: bookingId,
        paymentId: response.paymentId!,
        amount: widget.bookingDetails['totalPrice'],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment successful!")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Booking Confirmed')),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ConfirmedBookingCard(
                  bookingId: bookingId,
                  paymentId: response.paymentId!,
                ),
              ),
            ),
          ),
        );
      }
    } catch (error) {
      log("Error in payment success handler: $error");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error processing booking: $error")),
        );
      }
    }
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_wjnOwkRSV0FoB3', // Replace with your Razorpay API Key
      'amount': (widget.bookingDetails['totalPrice'] * 100)
          .toInt(), // Amount in paisa
      'name': 'Turf Booking App',
      'description': 'Payment for Booking',
      'prefill': {
        'contact': '1234567890',
        'email': 'user@example.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      log("Error opening Razorpay: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error opening payment gateway: $e")),
      );
    }
  }

  // void _handlePaymentSuccess(PaymentSuccessResponse response) async {
  //   log("Payment successful: ${response.paymentId}");
  //   await storePaymentDetails(
  //     userId:
  //         FirebaseAuth.instance.currentUser!.uid, // Replace with actual user ID
  //     bookingId: widget.bookingDetails['bookingId'],
  //     paymentId: response.paymentId!,
  //     amount: widget.bookingDetails['totalPrice'],
  //   );
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Payment successful!")),
  //   );
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Scaffold(
  //         appBar: AppBar(title: const Text('Booking Confirmed')),
  //         body: Padding(
  //           padding: const EdgeInsets.all(16.0),
  //           child: ConfirmedBookingCard(
  //             bookingId: widget.bookingId,
  //             paymentId: response.paymentId!,
  //           ),
  //         ),
  //       ),
  //     ),
  //   ); // Navigate back after success
  // }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("Payment failed: ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("External wallet selected: ${response.walletName}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("External wallet selected: ${response.walletName}")),
    );
  }

  Future<void> storePaymentDetails({
    required String userId,
    required String bookingId,
    required String paymentId,
    required double amount,
  }) async {
    try {
      final paymentDocId =
          FirebaseFirestore.instance.collection('payments').doc().id;

      await FirebaseFirestore.instance
          .collection('payments')
          .doc(paymentDocId)
          .set({
        'userId': userId,
        'bookingId': bookingId,
        'paymentId': paymentId,
        'amount': amount,
        'status': "Paid",
        'method': "Razorpay",
        'createdAt': FieldValue.serverTimestamp(),
      });

      log("Payment details saved with ID: $paymentDocId");
    } catch (error) {
      log("Error saving payment details: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving payment details: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Payment Summary",
            ),
            const Divider(),
            Text("Booking ID: ${_bookingId}"),
            Text("Total Amount: ₹${widget.bookingDetails['totalPrice']}"),
            const Spacer(),
            ElevatedButton(
              onPressed: openCheckout,
              child: const Text("Pay with Razorpay"),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmedBookingCard extends StatelessWidget {
  final String bookingId;
  final String paymentId;

  const ConfirmedBookingCard({
    super.key,
    required this.bookingId,
    required this.paymentId,
  });

  Future<Map<String, dynamic>> _getBookingDetails() async {
    try {
      // Get booking details
      final bookingDoc = await FirebaseFirestore.instance
          .collection('bookings')
          .where('bookingId', isEqualTo: bookingId)
          .get();

      if (bookingDoc.docs.isEmpty) {
        throw 'Booking not found';
      }

      final bookingData = bookingDoc.docs.first.data();

      // Get venue details
      final venueDoc = await FirebaseFirestore.instance
          .collection('venues')
          .doc(bookingData['venueId'])
          .get();

      // Get payment details
      final paymentDoc = await FirebaseFirestore.instance
          .collection('payments')
          .where('paymentId', isEqualTo: paymentId)
          .get();

      return {
        'booking': bookingData,
        'venue': venueDoc.data() ?? {},
        'payment':
            paymentDoc.docs.isNotEmpty ? paymentDoc.docs.first.data() : {},
      };
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getBookingDetails(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error loading booking: ${snapshot.error}'),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final bookingData = snapshot.data!['booking'];
        final venueData = snapshot.data!['venue'];
        final paymentData = snapshot.data!['payment'];
        final timestamp = bookingData['date'] as Timestamp;
        final date = timestamp.toDate();

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Booking Confirmed',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      venueData['venueName'] ?? 'Venue Name',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      Icons.calendar_today,
                      'Date',
                      DateFormat('EEEE, dd MMM yyyy').format(date),
                    ),
                    _buildInfoRow(
                      context,
                      Icons.access_time,
                      'Time',
                      '${bookingData['startTime']} - ${bookingData['endTime']}',
                    ),
                    _buildInfoRow(
                      context,
                      Icons.timer,
                      'Duration',
                      '${bookingData['duration']} hours',
                    ),
                    const Divider(height: 32),
                    _buildInfoRow(
                      context,
                      Icons.confirmation_number,
                      'Booking ID',
                      bookingId,
                    ),
                    _buildInfoRow(
                      context,
                      Icons.payment,
                      'Payment ID',
                      paymentId,
                    ),
                    _buildInfoRow(
                      context,
                      Icons.currency_rupee,
                      'Amount Paid',
                      '₹${paymentData['amount']}',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement share functionality
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement download functionality
                          },
                          icon: const Icon(Icons.download),
                          label: const Text('Download'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// class BookingsListPage extends StatelessWidget {
//   const BookingsListPage({super.key});

//   String getBookingStatus(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return '⏳ Pending';
//       case 'confirmed':
//         return '✅ Confirmed';
//       case 'cancelled':
//         return '❌ Cancelled';
//       case 'completed':
//         return '🏆 Completed';
//       default:
//         return status;
//     }
//   }

//   Color getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Colors.orange;
//       case 'confirmed':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       case 'completed':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final currentUser = FirebaseAuth.instance.currentUser;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Bookings'),
//       ),
//       body: currentUser == null
//           ? const Center(child: Text('Please login to view bookings'))
//           : StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('bookings')
//                   .where('userId', isEqualTo: currentUser.uid)
//                   .orderBy('createdAt', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Text('Error: ${snapshot.error}'),
//                   );
//                 }

//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.sports_cricket, size: 64, color: Colors.grey),
//                         SizedBox(height: 16),
//                         Text(
//                           'No bookings found',
//                           style: TextStyle(fontSize: 18, color: Colors.grey),
//                         ),
//                         Text(
//                           'Book your first game now!',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 return ListView.builder(
//                   padding: const EdgeInsets.all(8),
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     final booking = snapshot.data!.docs[index];
//                     final data = booking.data() as Map<String, dynamic>;
//                     final timestamp = data['date'] as Timestamp;
//                     final date = timestamp.toDate();

//                     return Card(
//                       elevation: 4,
//                       margin: const EdgeInsets.symmetric(
//                           vertical: 8, horizontal: 4),
//                       child: ExpansionTile(
//                         title: Row(
//                           children: [
//                             const Icon(Icons.sports_cricket),
//                             const SizedBox(width: 8),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   DateFormat('EEEE, MMM d, yyyy').format(date),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 Text(
//                                   '${data['startTime']} - ${data['endTime']}',
//                                   style: const TextStyle(fontSize: 14),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         subtitle: Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Chip(
//                                 label: Text(
//                                   getBookingStatus(data['status']),
//                                   style: const TextStyle(color: Colors.white),
//                                 ),
//                                 backgroundColor:
//                                     getStatusColor(data['status']),
//                               ),
//                               Text(
//                                 '₹${data['totalPrice']}',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 const Divider(),
//                                 DetailRow(
//                                   label: 'Booking ID',
//                                   value: data['bookingId'],
//                                 ),
//                                 DetailRow(
//                                   label: 'Duration',
//                                   value: '${data['duration']} hours',
//                                 ),
//                                 DetailRow(
//                                   label: 'Venue ID',
//                                   value: data['venueId'],
//                                 ),
//                                 DetailRow(
//                                   label: 'Sport ID',
//                                   value: data['sportId'],
//                                 ),
//                                 DetailRow(
//                                   label: 'Booked On',
//                                   value: DateFormat('MMM d, yyyy, h:mm a')
//                                       .format((data['createdAt'] as Timestamp)
//                                           .toDate()),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 if (data['status'] == 'pending')
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceEvenly,
//                                     children: [
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           // Implement cancel booking
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                           backgroundColor: Colors.red,
//                                         ),
//                                         child: const Text('Cancel Booking'),
//                                       ),
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           // Implement payment if pending
//                                         },
//                                         child: const Text('Complete Payment'),
//                                       ),
//                                     ],
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }

// class DetailRow extends StatelessWidget {
//   final String label;
//   final String value;

//   const DetailRow({
//     super.key,
//     required this.label,
//     required this.value,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               label,
//               style: const TextStyle(
//                 color: Colors.grey,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//           const Text(': '),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class BookingsListPage extends StatelessWidget {
  const BookingsListPage({super.key});

  Future<String> getVenueName(String venueId) async {
    try {
      final venueDoc = await FirebaseFirestore.instance
          .collection('venues')
          .doc(venueId)
          .get();

      if (venueDoc.exists) {
        final data = venueDoc.data();
        return data?['venue_name'] ?? 'Unknown Venue';
      }
      return 'Unknown Venue';
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: currentUser == null
          ? const Center(child: Text('Please login to view bookings'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('bookings')
                  .where('userId', isEqualTo: currentUser.uid)
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sports_cricket,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No bookings found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final booking = snapshot.data!.docs[index];
                    final data = booking.data() as Map<String, dynamic>;
                    final timestamp = data['date'] as Timestamp;
                    final date = timestamp.toDate();

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Booking ID: ${data['bookingId']}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Text(
                                  DateFormat('dd MMM yyyy').format(date),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            FutureBuilder<String>(
                              future: getVenueName(data['venueId']),
                              builder: (context, venueSnapshot) {
                                return Text(
                                  venueSnapshot.data ?? 'Loading venue...',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${data['startTime']} - ${data['endTime']}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  ' (${data['duration']} hours)',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Booked on: ${DateFormat('dd MMM, hh:mm a').format((data['createdAt'] as Timestamp).toDate())}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

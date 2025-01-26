// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:event_booking_timeline/event_booking_timeline.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class BookingPage extends StatefulWidget {
//   final String venueId;
//   final String sportId;

//   const BookingPage({
//     super.key,
//     required this.venueId,
//     required this.sportId,
//   });

//   @override
//   State<BookingPage> createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   String selectedTime = ""; // Selected time
//   int duration = 1; // Default duration in hours
//   DateTime selectedDate = DateTime.now(); // Selected date
//   double totalPrice = 0.0; // Total price
//   final double convenienceFee = 5.0; // Fixed convenience fee
//   Map<String, dynamic> priceChart = {}; // Price chart from Firestore
//   bool isLoading = true; // Loading state for Firestore data

//   @override
//   void initState() {
//     super.initState();
//     // Set default time to the nearest hour
//     final now = TimeOfDay.now();
//     final nearestHour = now.minute >= 30 ? now.hour + 1 : now.hour;
//     selectedTime = "${nearestHour.toString().padLeft(2, '0')}:00";

//     // Fetch the price chart from Firestore
//     fetchPriceChart();
//   }

//   Future<void> fetchPriceChart() async {
//     try {
//       setState(() => isLoading = true);

//       final snapshot = await FirebaseFirestore.instance
//           .collection('venues')
//           .doc(widget.venueId)
//           .collection('sports')
//           .doc(widget.sportId)
//           .get();

//       if (!snapshot.exists) {
//         throw Exception("Sport details not found.");
//       }

//       final sportData = snapshot.data() as Map<String, dynamic>;
//       final fetchedPriceChart = sportData['price'] as Map<String, dynamic>;

//       log("Fetched Price Chart: $fetchedPriceChart");

//       setState(() {
//         priceChart = fetchedPriceChart;
//         isLoading = false;
//       });
//     } catch (error) {
//       log("Error fetching price chart: $error");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Failed to fetch price chart: $error'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       setState(() => isLoading = false);
//     }
//   }

//   String getDayType() {
//     return (selectedDate.weekday == DateTime.saturday ||
//             selectedDate.weekday == DateTime.sunday)
//         ? "Saturday - Sunday"
//         : "Monday - Friday";
//   }

//   double fetchPriceForTime(String selectedTime) {
//     if (priceChart.isEmpty) return 0.0;

//     final dayType = getDayType();
//     final dayPrices = priceChart[dayType] as Map<String, dynamic>?;

//     if (dayPrices == null) return 0.0;

//     for (String range in dayPrices.keys) {
//       final times = range.split(" to ");
//       final startTime = convertTo24Hour(times[0].trim());
//       final endTime = convertTo24Hour(times[1].trim());

//       if (selectedTime.compareTo(startTime) >= 0 &&
//           selectedTime.compareTo(endTime) < 0) {
//         return double.tryParse(dayPrices[range].toString()) ?? 0.0;
//       }
//     }

//     return 0.0;
//   }

//   String convertTo24Hour(String time12Hour) {
//     final inputFormat = DateFormat("h:mm a");
//     final outputFormat = DateFormat("HH:mm");
//     return outputFormat.format(inputFormat.parse(time12Hour));
//   }

//   void calculateTotalPrice() {
//     if (priceChart.isEmpty) {
//       setState(() => totalPrice = 0.0);
//       return;
//     }

//     final pricePerHour = fetchPriceForTime(selectedTime);
//     setState(() {
//       totalPrice = (pricePerHour * duration) + convenienceFee;
//     });
//   }

//   Future<Map<String, String>> fetchVenueAndSportDetails(
//       String venueId, String sportId) async {
//     try {
//       final venueDoc = await FirebaseFirestore.instance
//           .collection('venues')
//           .doc(venueId)
//           .get();

//       if (!venueDoc.exists) {
//         throw Exception("Venue not found in database.");
//       }

//       final venueData = venueDoc.data() as Map<String, dynamic>;
//       final sportsCollection = FirebaseFirestore.instance
//           .collection('venues')
//           .doc(venueId)
//           .collection('sports');
//       final sportDoc = await sportsCollection.doc(sportId).get();

//       if (!sportDoc.exists) {
//         throw Exception("Sport not found in database.");
//       }

//       final sportData = sportDoc.data() as Map<String, dynamic>;

//       return {
//         "venueName": venueData["name"] ?? venueId,
//         "sportName": sportData["sport_name"] ?? sportId,
//         "venueId": venueId, // IDs as fallback
//         "sportId": sportId,
//       };
//     } catch (error) {
//       throw Exception("Error fetching details: $error");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Book Now"),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text('Venue Name'), //display venue name
//                   // Sport Icon and Name
//                   const Center(
//                     child: Card(
//                       elevation: 4,
//                       child: Padding(
//                         padding: EdgeInsets.all(16.0),
//                         child: Column(
//                           children: [
//                             Icon(Icons.sports_cricket,
//                                 size: 50, color: Colors.red),
//                             SizedBox(height: 8),
//                             Text(
//                               "Cricket",
//                               style: TextStyle(
//                                   fontSize: 22, fontWeight: FontWeight.bold),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const Divider(),

//                   // Horizontal Scrollable Date Cards
//                   Text("Select a Date",
//                       style: Theme.of(context).textTheme.titleMedium),
//                   SizedBox(
//                     height: 80,
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: List.generate(7, (index) {
//                         final date = DateTime.now().add(Duration(days: index));
//                         final isSelected = selectedDate.year == date.year &&
//                             selectedDate.month == date.month &&
//                             selectedDate.day == date.day;
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               selectedDate = date;
//                               calculateTotalPrice();
//                             });
//                           },
//                           child: Card(
//                             elevation: isSelected ? 6 : 2,
//                             color: isSelected ? Colors.red : Colors.white,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 8, horizontal: 16),
//                               child: Column(
//                                 children: [
//                                   Text(DateFormat('EEEE').format(date),
//                                       style: TextStyle(
//                                         color: isSelected
//                                             ? Colors.white
//                                             : Colors.black,
//                                       )),
//                                   Text(DateFormat('dd MMM').format(date),
//                                       style: TextStyle(
//                                         color: isSelected
//                                             ? Colors.white
//                                             : Colors.black,
//                                       )),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ),
//                   const Divider(),

//                   // Time and Duration Selector
//                   Text("Select Time and Duration",
//                       style: Theme.of(context).textTheme.titleMedium),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       // Time Selector
//                       Column(
//                         children: [
//                           const Text("Time"),
//                           ElevatedButton(
//                             onPressed: () async {
//                               final time = await showTimePicker(
//                                 context: context,
//                                 initialTime: TimeOfDay.now(),
//                               );
//                               if (time != null) {
//                                 setState(() {
//                                   selectedTime = time.format(context);
//                                   calculateTotalPrice();
//                                 });
//                               }
//                             },
//                             child: Text(selectedTime),
//                           ),
//                         ],
//                       ),

//                       // Duration Selector
//                       Column(
//                         children: [
//                           const Text("Duration (hrs)"),
//                           Row(
//                             children: [
//                               IconButton(
//                                 onPressed: () {
//                                   if (duration > 1) {
//                                     setState(() {
//                                       duration--;
//                                       calculateTotalPrice();
//                                     });
//                                   }
//                                 },
//                                 icon: const Icon(Icons.remove),
//                               ),
//                               Text("$duration"),
//                               IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     duration++;
//                                     calculateTotalPrice();
//                                   });
//                                 },
//                                 icon: const Icon(Icons.add),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const Divider(),

//                   // Timeline
//                   SizedBox(
//                     width: screenWidth,
//                     height: 150,
//                     child: EventBookingTimeline.withCurrentBookingSlot(
//                       numberOfSubdivision: 5,
//                       widthOfSegment: 100,
//                       widthOfTimeDivisionBar: 3,
//                       moveToFirstAvailableTime: true,
//                       availableColor: Colors.green,
//                       bookedColor: Colors.red,
//                       moveToNextPrevSlot: true,
//                       onError: (error) {
//                         log("Error: $error");
//                       },
//                       onTimeLineEnd: () {
//                         log("TimeLine Ended");
//                       },
//                       blockUntilCurrentTime: true,
//                       durationToBlock: 1,
//                       showCurrentBlockedSlot: true,
//                       currentBlockedColor: Colors.blue,
//                       selectedBarColor: Colors.white,
//                       selectedTextColor: Colors.white,
//                       textColor: Colors.black,
//                       barColor: Colors.black,
//                       addBuffer: false,
//                       booked: [
//                         Booking(startTime: "06:00", endTime: "08:00"),
//                         Booking(startTime: "18:00", endTime: "20:00"),
//                       ],
//                       startTime: "05:00",
//                       endTime: "24:00",
//                       is12HourFormat: true,
//                       onTimeSelected: (String time) {
//                         setState(() {
//                           selectedTime = time;
//                           calculateTotalPrice();
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Book Now Button
//                   ElevatedButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (_) => AlertDialog(
//                           title: const Text("Booking Summary"),
//                           content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text("Sport: Cricket"),
//                               Text(
//                                   "Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}"),
//                               Text("Time: $selectedTime"),
//                               Text("Duration: $duration hrs"),
//                               const Divider(),
//                               Text(
//                                   "Court Price: ₹${totalPrice - convenienceFee}"),
//                               Text("Convenience Fee: ₹$convenienceFee"),
//                               const Divider(),
//                               Text("Total Amount: ₹$totalPrice"),
//                             ],
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: const Text("Close"),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     child: Text("Book Now (₹$totalPrice)"),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

// // ------------------------------------------------------------------------------------------------------

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:event_booking_timeline/event_booking_timeline.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smash/pages/sports/payment_page.dart';

// Providers
final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());
final durationProvider = StateProvider<int>((ref) => 1);
final priceChartProvider = StateProvider<Map<String, dynamic>>((ref) => {});
final totalPriceProvider = StateProvider<double>((ref) => 0.0);
final isLoadingProvider = StateProvider<bool>((ref) => true);
// Helper Functions
String getDayType(DateTime date) {
  final weekday = date.weekday;
  return (weekday == DateTime.saturday || weekday == DateTime.sunday)
      ? "Saturday - Sunday"
      : "Monday - Friday";
}

String convertTo24Hour(String time12Hour) {
  final inputFormat = DateFormat("h:mm a");
  final outputFormat = DateFormat("HH:mm");
  return outputFormat.format(inputFormat.parse(time12Hour));
}

double fetchPriceForTime(
    Map<String, dynamic> priceChart, String selectedTime, String dayType) {
  if (priceChart.isEmpty) {
    log("Price chart is empty.");
    return 0.0;
  }

  final dayPrices = priceChart[dayType] as Map<String, dynamic>?;
  if (dayPrices == null) {
    log("No prices found for day type: $dayType");
    return 0.0;
  }

  for (String range in dayPrices.keys) {
    final times = range.split(" to ");
    final startTime = convertTo24Hour(times[0].trim());
    final endTime = convertTo24Hour(times[1].trim());

    if (selectedTime.compareTo(startTime) >= 0 &&
        selectedTime.compareTo(endTime) < 0) {
      final price = double.tryParse(dayPrices[range].toString()) ?? 0.0;
      log("Matched range: $range with price: $price");
      return price;
    }
  }

  log("No matching time range found for selectedTime: $selectedTime");
  return 0.0;
}

class BookingPage extends ConsumerStatefulWidget {
  final String venueId;
  final String sportId;

  const BookingPage({
    super.key,
    required this.venueId,
    required this.sportId,
  });

  @override
  BookingPageState createState() => BookingPageState();
}

class BookingPageState extends ConsumerState<BookingPage> {
  String selectedTime = '';
  late String venueName;
  @override
  void initState() {
    super.initState();
    fetchVenueName(widget.venueId);
    // Initialize with current hour
    final now = TimeOfDay.now();
    final nearestHour = now.minute >= 30 ? now.hour + 1 : now.hour;
    selectedTime = "${nearestHour.toString().padLeft(2, '0')}:00";

    // Fetch price chart when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPriceChart();
    });
  }

  Future<String> fetchVenueName(String venueId) async {
    try {
      final venueDoc = await FirebaseFirestore.instance
          .collection('venues')
          .doc(venueId)
          .get();

      if (!venueDoc.exists) {
        throw Exception("Venue not found in database.");
      }

      final venueData = venueDoc.data() as Map<String, dynamic>;
      final sportsCollection = FirebaseFirestore.instance
          .collection('venues')
          .doc(venueId)
          .collection('sports');
      // final sportDoc = await sportsCollection.doc(sportId).get();

      // if (!sportDoc.exists) {
      //   throw Exception("Sport not found in database.");
      // }

      // final sportData = sportDoc.data() as Map<String, dynamic>;
      venueName = venueData["venue_name"];
      return venueName;
      // "sportName": sportData["sport_name"] ?? sportId,
    } catch (error) {
      throw Exception("Error fetching details: $error");
    }
  }

  Future<void> fetchPriceChart() async {
    ref.read(isLoadingProvider.notifier).state = true;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('venues')
          .doc(widget.venueId)
          .collection('sports')
          .doc(widget.sportId)
          .get();

      if (!snapshot.exists) {
        throw Exception("Sport details not found in Firestore.");
      }

      final sportData = snapshot.data() as Map<String, dynamic>?;
      if (sportData == null || !sportData.containsKey('price')) {
        throw Exception(
            "Invalid Firestore data structure. 'price' key missing.");
      }

      final fetchedPriceChart = sportData['price'] as Map<String, dynamic>;
      if (fetchedPriceChart.isEmpty) {
        throw Exception("Price chart is empty.");
      }

      ref.read(priceChartProvider.notifier).state = fetchedPriceChart;
      calculateTotalPrice();
    } catch (error) {
      log("Error fetching price chart: $error");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to fetch price chart: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  void calculateTotalPrice() {
    final priceChart = ref.read(priceChartProvider);
    final selectedDate = ref.read(selectedDateProvider);
    final duration = ref.read(durationProvider);

    if (priceChart.isEmpty) {
      log("Price chart is empty. Cannot calculate total price.");
      ref.read(totalPriceProvider.notifier).state = 0.0;
      return;
    }

    final dayType = getDayType(selectedDate);
    final pricePerHour = fetchPriceForTime(priceChart, selectedTime, dayType);

    log("Price per hour: $pricePerHour, Duration: $duration");
    ref.read(totalPriceProvider.notifier).state =
        (pricePerHour * duration) + 5.0;
  }

  Future<String> createBooking(BuildContext context, WidgetRef ref) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      // Generate a booking ID
      final bookingId =
          FirebaseFirestore.instance.collection('bookings').doc().id;

      final selectedDate = ref.read(selectedDateProvider);

      final duration = ref.read(durationProvider);
      final totalPrice = ref.read(totalPriceProvider);

      // Calculate end time
      final startTime = selectedTime.split(':');
      final startHour = int.parse(startTime[0]);
      final startMinute = int.parse(startTime[1]);
      final endDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        startHour,
        startMinute,
      ).add(Duration(hours: duration));

      final endTime =
          "${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}";

      // Create booking document
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .set({
        'bookingId': bookingId,
        'userId': user.uid,
        'venueId': widget.venueId,
        'venueName': venueName,
        'sportId': widget.sportId,
        'date': Timestamp.fromDate(selectedDate),
        'startTime': selectedTime,
        'endTime': endTime,
        'duration': duration,
        'totalPrice': totalPrice,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return bookingId;
    } catch (error) {
      log("Error creating booking: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create booking: $error')),
      );
      throw error;
    }
  }

  String calculateEndTime(String startTime, int duration) {
    final startTimeParts = startTime.split(':');
    final startHour = int.parse(startTimeParts[0]);
    final startMinute = int.parse(startTimeParts[1]);
    final endDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      startHour,
      startMinute,
    ).add(Duration(hours: duration));

    return "${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}";
  }

  // void navigateToPayment(
  //     BuildContext context, String bookingId, double totalPrice) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => PaymentPage(

  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final selectedDate = ref.watch(selectedDateProvider);
    final duration = ref.watch(durationProvider);
    final totalPrice = ref.watch(totalPriceProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Now"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      venueName,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Center(
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.sports_cricket,
                                size: 50, color: Colors.red),
                            SizedBox(height: 8),
                            Text(
                              "Cricket",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Text("Select a Date",
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(7, (index) {
                        final date = DateTime.now().add(Duration(days: index));
                        final isSelected = selectedDate.year == date.year &&
                            selectedDate.month == date.month &&
                            selectedDate.day == date.day;
                        return GestureDetector(
                          onTap: () {
                            ref.read(selectedDateProvider.notifier).state =
                                date;
                            calculateTotalPrice();
                          },
                          child: Card(
                            elevation: isSelected ? 6 : 2,
                            color: isSelected ? Colors.red : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Column(
                                children: [
                                  Text(
                                    DateFormat('EEEE').format(date),
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('dd MMM').format(date),
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const Divider(),
                  Text("Select Time and Duration",
                      style: Theme.of(context).textTheme.titleMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text("Time"),
                          ElevatedButton(
                            onPressed: () async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (time != null) {
                                setState(() {
                                  selectedTime =
                                      convertTo24Hour(time.format(context));
                                });
                                calculateTotalPrice();
                              }
                            },
                            child: Text(selectedTime),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Duration (hrs)"),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (duration > 1) {
                                    ref.read(durationProvider.notifier).state =
                                        duration - 1;
                                    calculateTotalPrice();
                                  }
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Text("$duration"),
                              IconButton(
                                onPressed: () {
                                  ref.read(durationProvider.notifier).state =
                                      duration + 1;
                                  calculateTotalPrice();
                                },
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),
                  SizedBox(
                    width: screenWidth,
                    height: 150,
                    child: EventBookingTimeline.withCurrentBookingSlot(
                      numberOfSubdivision: 5,
                      widthOfSegment: 100,
                      widthOfTimeDivisionBar: 3,
                      moveToFirstAvailableTime: true,
                      availableColor: Colors.green,
                      bookedColor: Colors.red,
                      moveToNextPrevSlot: true,
                      onError: (error) {
                        log("Error: $error");
                      },
                      onTimeLineEnd: () {
                        log("Timeline ended");
                      },
                      blockUntilCurrentTime: true,
                      durationToBlock: 1,
                      showCurrentBlockedSlot: true,
                      currentBlockedColor: Colors.blue,
                      selectedBarColor: Colors.white,
                      selectedTextColor: Colors.white,
                      textColor: Colors.black,
                      barColor: Colors.black,
                      addBuffer: false,
                      booked: [
                        Booking(startTime: "06:00", endTime: "08:00"),
                        Booking(startTime: "18:00", endTime: "20:00"),
                      ],
                      startTime: "05:00",
                      endTime: "24:00",
                      is12HourFormat: true,
                      onTimeSelected: (String time) {
                        setState(() {
                          selectedTime = convertTo24Hour(time);
                        });
                        calculateTotalPrice();
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Booking Summary"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Sport: Cricket"),
                              Text(
                                "Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}",
                              ),
                              Text("Time: $selectedTime"),
                              Text("Duration: $duration hrs"),
                              const Divider(),
                              Text("Court Price: ₹${totalPrice - 5.0}"),
                              const Text("Convenience Fee: ₹5.0"),
                              const Divider(),
                              Text("Total Amount: ₹$totalPrice"),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentPage(
                                      bookingDetails: {
                                        'userId': FirebaseAuth
                                            .instance.currentUser?.uid,
                                        'venueId': widget.venueId,
                                        'venueName': venueName,
                                        'sportId': widget.sportId,
                                        'date': selectedDate,
                                        'startTime': selectedTime,
                                        'endTime': calculateEndTime(
                                            selectedTime, duration),
                                        'duration': duration,
                                        'totalPrice': totalPrice,
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: const Text("Proceed to Payment"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text("Book Now (₹$totalPrice)"),
                  ),
                ],
              ),
            ),
    );
  }
}

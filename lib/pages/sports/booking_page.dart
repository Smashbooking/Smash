// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:event_booking_timeline/event_booking_timeline.dart';
// import 'package:intl/intl.dart';

// class BookingPage extends StatefulWidget {
//   const BookingPage({super.key});

//   @override
//   State<BookingPage> createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   String selectedTime = ""; // Selected time
//   int duration = 1; // Default duration in hours
//   DateTime selectedDate = DateTime.now(); // Selected date
//   double totalPrice = 0.0; // Total price
//   final double convenienceFee = 5.0; // Fixed convenience fee
//   final Map<String, dynamic> priceChart = {
//     "Monday-Friday": {
//       "6:00 AM to 11:00 AM": 500,
//       "11:00 AM to 5:00 PM": 750,
//       "5:00 PM to 12:00 AM": 1000,
//     },
//     "Saturday-Sunday": {
//       "6:00 AM to 11:00 AM": 550,
//       "11:00 AM to 5:00 PM": 850,
//       "5:00 PM to 12:00 AM": 1200,
//     }
//   };

//   @override
//   void initState() {
//     super.initState();
//     // Set default time to current time rounded to nearest hour
//     final now = TimeOfDay.now();
//     final nearestHour = now.minute >= 30 ? now.hour + 1 : now.hour;
//     selectedTime = "${nearestHour.toString().padLeft(2, '0')}:00";
//   }

//   // Fetch day type (Weekday or Weekend)
//   String getDayType() {
//     return (selectedDate.weekday == DateTime.saturday ||
//             selectedDate.weekday == DateTime.sunday)
//         ? "Saturday-Sunday"
//         : "Monday-Friday";
//   }

//   // Calculate price dynamically
//   void calculatePrice() {
//     final dayType = getDayType();
//     final slot = priceChart[dayType].entries.firstWhere(
//           (entry) => selectedTime.startsWith(entry.key.split(" to ")[0]),
//           orElse: () => const MapEntry("", 0),
//         );
//     setState(() {
//       totalPrice = (slot.value ?? 0) * duration + convenienceFee;
//     });
//   }

//   // Generate 7-day cards
//   // List<Widget> generateDateCards() {
//   //   return List.generate(7, (index) {
//   //     final date = DateTime.now().add(Duration(days: index));
//   //     final formattedDate = DateFormat('dd MMM').format(date);
//   //     final dayName = DateFormat('EEEE').format(date);
//   //     return GestureDetector(
//   //       onTap: () {
//   //         setState(() {
//   //           selectedDate = date;
//   //           calculatePrice();
//   //         });
//   //       },
//   //       child: Card(
//   //         color: selectedDate == date ? Colors.blue : Colors.white,
//   //         child: Padding(
//   //           padding: const EdgeInsets.all(8.0),
//   //           child: Column(
//   //             children: [
//   //               Text(dayName, style: const TextStyle(fontSize: 12)),
//   //               Text(formattedDate, style: const TextStyle(fontSize: 14)),
//   //             ],
//   //           ),
//   //         ),
//   //       ),
//   //     );
//   //   });
//   // }
//   // Generate 7-day cards
//   // Generate 7-day cards
//   List<Widget> generateDateCards() {
//     return List.generate(7, (index) {
//       final date = DateTime.now().add(Duration(days: index));
//       final formattedDate = DateFormat('dd MMM').format(date);
//       final dayName = DateFormat('EEEE').format(date);
//       final isSelected = selectedDate.year == date.year &&
//           selectedDate.month == date.month &&
//           selectedDate.day == date.day; // Check if the card is selected

//       return GestureDetector(
//         onTap: () {
//           setState(() {
//             selectedDate = date; // Update the selected date
//             calculatePrice(); // Recalculate price (if needed)
//           });
//         },
//         child: Card(
//           elevation:
//               isSelected ? 6 : 2, // Highlight the selected card with elevation
//           color:
//               isSelected ? Colors.red : Colors.white, // Red for selected card
//           child: Padding(
//             padding:
//                 const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: Column(
//               children: [
//                 Text(
//                   dayName,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight:
//                         isSelected ? FontWeight.bold : FontWeight.normal,
//                     color: isSelected ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 Text(
//                   formattedDate,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight:
//                         isSelected ? FontWeight.bold : FontWeight.normal,
//                     color: isSelected ? Colors.white : Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   String findNextAvailableSlot(String currentTime) {
//     final availableSlots = [
//       "05:00",
//       "06:00",
//       "07:00",
//       "08:00",
//       "09:00",
//       "18:00",
//       "19:00",
//       "20:00"
//     ]; // List of all available time slots

//     // Find the next available time slot after the current time
//     for (String slot in availableSlots) {
//       if (slot.compareTo(currentTime) > 0) {
//         return slot;
//       }
//     }

//     // If no available slot is found, return the first slot of the next day
//     return availableSlots.first;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Book Now"),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Sport Icon and Name
//             Center(
//               child: Card(
//                 elevation: 4,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: const [
//                       Icon(Icons.sports_cricket, size: 50, color: Colors.red),
//                       SizedBox(height: 8),
//                       Text(
//                         "Cricket",
//                         style: TextStyle(
//                             fontSize: 22, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Divider(),

//             // Horizontal Scrollable Date Cards
//             Text(
//               "Select a Date",
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               height: 80,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: generateDateCards(),
//               ),
//             ),
//             const Divider(),

//             // Time and Duration Selector
//             Text(
//               "Select Time and Duration",
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 // Time Selector
//                 Column(
//                   children: [
//                     const Text("Time"),
//                     ElevatedButton(
//                       onPressed: () async {
//                         final time = await showTimePicker(
//                           context: context,
//                           initialTime: TimeOfDay.fromDateTime(
//                               DateTime.now().add(const Duration(minutes: 30))),
//                         );
//                         if (time != null) {
//                           setState(() {
//                             selectedTime = time.format(context);
//                             calculatePrice();
//                           });
//                         }
//                       },
//                       child: Text(selectedTime),
//                     ),
//                   ],
//                 ),

//                 // Duration Selector
//                 Column(
//                   children: [
//                     const Text("Duration (hrs)"),
//                     Row(
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             if (duration > 1) {
//                               setState(() {
//                                 duration--;
//                                 calculatePrice();
//                               });
//                             }
//                           },
//                           icon: const Icon(Icons.remove),
//                         ),
//                         Text("$duration"),
//                         IconButton(
//                           onPressed: () {
//                             setState(() {
//                               duration++;
//                               calculatePrice();
//                             });
//                           },
//                           icon: const Icon(Icons.add),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const Divider(),

//             // Timeline
//             Text(
//               "Time Availability",
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               width: screenWidth,
//               height: 150,
//               child: EventBookingTimeline.withCurrentBookingSlot(
//                 numberOfSubdivision: 2,
//                 widthOfSegment: 100,
//                 widthOfTimeDivisionBar: 3,
//                 moveToFirstAvailableTime: true,
//                 moveToNextPrevSlot: true,
//                 onError: (error) => log("Error: $error"),
//                 onTimeLineEnd: () => log("Timeline Ended"),
//                 blockUntilCurrentTime: true,
//                 durationToBlock: 1,
//                 showCurrentBlockedSlot: true,
//                 currentBlockedColor: Colors.blue,
//                 selectedBarColor: Colors.white,
//                 selectedTextColor: Colors.white,
//                 textColor: Colors.black,
//                 barColor: Colors.grey,
//                 addBuffer: true,
//                 booked: [
//                   Booking(startTime: "06:00", endTime: "08:00"),
//                   Booking(startTime: "18:00", endTime: "20:00"),
//                 ],
//                 startTime: "05:00",
//                 endTime: "24:00",
//                 is12HourFormat: true,
//                 availableColor: Colors.green,
//                 bookedColor: Colors.red,
//                 // onTimeSelected: (String time) {
//                 //   setState(() {
//                 //     selectedTime = time;
//                 //     calculatePrice();
//                 //   });
//                 // },
//                 onTimeSelected: (String time) {
//                   // Check if the selected time is in the "booked" list
//                   bool isUnavailable = [
//                     Booking(startTime: "06:00", endTime: "08:00"),
//                     Booking(startTime: "18:00", endTime: "20:00"),
//                   ].any((booking) {
//                     final start = booking.startTime;
//                     final end = booking.endTime;

//                     return time.compareTo(start) >= 0 &&
//                         time.compareTo(end) < 0;
//                   });

//                   if (isUnavailable) {
//                     // Show Snackbar for unavailable slot
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: const Text("Cannot be booked"),
//                         duration: const Duration(seconds: 2),
//                       ),
//                     );

//                     // Automatically select the next available time slot
//                     String nextAvailableSlot = findNextAvailableSlot(time);
//                     setState(() {
//                       selectedTime = nextAvailableSlot;
//                       calculatePrice();
//                     });
//                   } else {
//                     // Time is available, proceed as usual
//                     setState(() {
//                       selectedTime = time;
//                       calculatePrice();
//                     });
//                   }
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Booking Summary and Button
//             ElevatedButton(
//               onPressed: () {
//                 showDialog(
//                   context: context,
//                   builder: (_) => AlertDialog(
//                     title: const Text("Booking Summary"),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text("Sport: Cricket"),
//                         Text(
//                             "Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}"),
//                         Text("Time: $selectedTime"),
//                         Text("Duration: $duration hrs"),
//                         const Divider(),
//                         Text("Court Price: ₹${totalPrice - convenienceFee}"),
//                         Text("Convenience Fee: ₹$convenienceFee"),
//                         const Divider(),
//                         Text("Total Amount: ₹$totalPrice"),
//                       ],
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text("Close"),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               child: Text("Book Now (₹$totalPrice)"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// -------------------------------------------------------------------------------------------------------------------------------------------
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:event_booking_timeline/event_booking_timeline.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingPage extends StatefulWidget {
  final String venueId;
  final String sportId;

  const BookingPage({
    super.key,
    required this.venueId,
    required this.sportId,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String selectedTime = ""; // Selected time
  int duration = 1; // Default duration in hours
  DateTime selectedDate = DateTime.now(); // Selected date
  double totalPrice = 0.0; // Total price
  final double convenienceFee = 5.0; // Fixed convenience fee
  Map<String, dynamic> priceChart = {}; // Price chart from Firestore
  bool isLoading = true; // Loading state for Firestore data

  @override
  void initState() {
    super.initState();
    // Set default time to the nearest hour
    final now = TimeOfDay.now();
    final nearestHour = now.minute >= 30 ? now.hour + 1 : now.hour;
    selectedTime = "${nearestHour.toString().padLeft(2, '0')}:00";

    // Fetch the price chart from Firestore
    fetchPriceChart();
  }

  Future<void> fetchPriceChart() async {
    try {
      setState(() => isLoading = true);

      final snapshot = await FirebaseFirestore.instance
          .collection('venues')
          .doc(widget.venueId)
          .collection('sports')
          .doc(widget.sportId)
          .get();

      if (!snapshot.exists) {
        throw Exception("Sport details not found.");
      }

      final sportData = snapshot.data() as Map<String, dynamic>;
      final fetchedPriceChart = sportData['price'] as Map<String, dynamic>;

      log("Fetched Price Chart: $fetchedPriceChart");

      setState(() {
        priceChart = fetchedPriceChart;
        isLoading = false;
      });
    } catch (error) {
      log("Error fetching price chart: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to fetch price chart: $error'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() => isLoading = false);
    }
  }

  String getDayType() {
    return (selectedDate.weekday == DateTime.saturday ||
            selectedDate.weekday == DateTime.sunday)
        ? "Saturday - Sunday"
        : "Monday - Friday";
  }

  double fetchPriceForTime(String selectedTime) {
    if (priceChart.isEmpty) return 0.0;

    final dayType = getDayType();
    final dayPrices = priceChart[dayType] as Map<String, dynamic>?;

    if (dayPrices == null) return 0.0;

    for (String range in dayPrices.keys) {
      final times = range.split(" to ");
      final startTime = convertTo24Hour(times[0].trim());
      final endTime = convertTo24Hour(times[1].trim());

      if (selectedTime.compareTo(startTime) >= 0 &&
          selectedTime.compareTo(endTime) < 0) {
        return double.tryParse(dayPrices[range].toString()) ?? 0.0;
      }
    }

    return 0.0;
  }

  String convertTo24Hour(String time12Hour) {
    final inputFormat = DateFormat("h:mm a");
    final outputFormat = DateFormat("HH:mm");
    return outputFormat.format(inputFormat.parse(time12Hour));
  }

  void calculateTotalPrice() {
    if (priceChart.isEmpty) {
      setState(() => totalPrice = 0.0);
      return;
    }

    final pricePerHour = fetchPriceForTime(selectedTime);
    setState(() {
      totalPrice = (pricePerHour * duration) + convenienceFee;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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
                  // Sport Icon and Name
                  Center(
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: const [
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

                  // Horizontal Scrollable Date Cards
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
                            setState(() {
                              selectedDate = date;
                              calculateTotalPrice();
                            });
                          },
                          child: Card(
                            elevation: isSelected ? 6 : 2,
                            color: isSelected ? Colors.red : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Column(
                                children: [
                                  Text(DateFormat('EEEE').format(date),
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  Text(DateFormat('dd MMM').format(date),
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const Divider(),

                  // Time and Duration Selector
                  Text("Select Time and Duration",
                      style: Theme.of(context).textTheme.titleMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Time Selector
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
                                  selectedTime = time.format(context);
                                  calculateTotalPrice();
                                });
                              }
                            },
                            child: Text(selectedTime),
                          ),
                        ],
                      ),

                      // Duration Selector
                      Column(
                        children: [
                          const Text("Duration (hrs)"),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (duration > 1) {
                                    setState(() {
                                      duration--;
                                      calculateTotalPrice();
                                    });
                                  }
                                },
                                icon: const Icon(Icons.remove),
                              ),
                              Text("$duration"),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    duration++;
                                    calculateTotalPrice();
                                  });
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

                  // Timeline
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
                        log("TimeLine Ended");
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
                          selectedTime = time;
                          calculateTotalPrice();
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Book Now Button
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text("Booking Summary"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Sport: Cricket"),
                              Text(
                                  "Date: ${DateFormat('dd MMM yyyy').format(selectedDate)}"),
                              Text("Time: $selectedTime"),
                              Text("Duration: $duration hrs"),
                              const Divider(),
                              Text(
                                  "Court Price: ₹${totalPrice - convenienceFee}"),
                              Text("Convenience Fee: ₹$convenienceFee"),
                              const Divider(),
                              Text("Total Amount: ₹$totalPrice"),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Close"),
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

// ---------------------------------------------------------------------------------------------------------------------------------------
// 2nd logic---------------------------------------------------------------------
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
//     // Set default time to current time rounded to the nearest hour
//     final now = TimeOfDay.now();
//     final nearestHour = now.minute >= 30 ? now.hour + 1 : now.hour;
//     selectedTime = "${nearestHour.toString().padLeft(2, '0')}:00";

//     // Fetch price chart from Firestore
//     fetchPriceChart();
//   }

//   // Fetch price chart from Firestore
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

//       // Log data for debugging
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

//   // Determine if selected day is weekday or weekend
//   String getDayType() {
//     return (selectedDate.weekday == DateTime.saturday ||
//             selectedDate.weekday == DateTime.sunday)
//         ? "Saturday-Sunday"
//         : "Monday-Friday";
//   }

//   // Convert 12-hour to 24-hour format
//   String convertTo24Hour(String time12Hour) {
//     final DateFormat inputFormat = DateFormat("h:mm a");
//     final DateFormat outputFormat = DateFormat("HH:mm");
//     return outputFormat.format(inputFormat.parse(time12Hour));
//   }

//   // Fetch price for selected time and duration
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

//   // Update price dynamically
//   void calculatePrice() {
//     final pricePerHour = fetchPriceForTime(selectedTime);
//     setState(() {
//       totalPrice = (pricePerHour * duration) + convenienceFee;
//     });
//   }

//   // Generate 7-day date cards
//   List<Widget> generateDateCards() {
//     return List.generate(7, (index) {
//       final date = DateTime.now().add(Duration(days: index));
//       final formattedDate = DateFormat('dd MMM').format(date);
//       final dayName = DateFormat('EEEE').format(date);
//       final isSelected = selectedDate.year == date.year &&
//           selectedDate.month == date.month &&
//           selectedDate.day == date.day;

//       return GestureDetector(
//         onTap: () {
//           setState(() {
//             selectedDate = date;
//             calculatePrice();
//           });
//         },
//         child: Card(
//           elevation: isSelected ? 6 : 2,
//           color: isSelected ? Colors.red : Colors.white,
//           child: Padding(
//             padding:
//                 const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: Column(
//               children: [
//                 Text(
//                   dayName,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontWeight:
//                         isSelected ? FontWeight.bold : FontWeight.normal,
//                     color: isSelected ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 Text(
//                   formattedDate,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight:
//                         isSelected ? FontWeight.bold : FontWeight.normal,
//                     color: isSelected ? Colors.white : Colors.black,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     });
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
//                   Center(
//                     child: Card(
//                       elevation: 4,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           children: const [
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
//                   Text(
//                     "Select a Date",
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   SizedBox(
//                     height: 80,
//                     child: ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: generateDateCards(),
//                     ),
//                   ),
//                   const Divider(),

//                   // Time and Duration Selector
//                   Text(
//                     "Select Time and Duration",
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
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
//                                   calculatePrice();
//                                 });
//                               }
//                             },
//                             child: Text(selectedTime),
//                           ),
//                         ],
//                       ),
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
//                                       calculatePrice();
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
//                                     calculatePrice();
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
//                       numberOfSubdivision: 2,
//                       widthOfSegment: 100,
//                       widthOfTimeDivisionBar: 3,
//                       moveToFirstAvailableTime: true,
//                       availableColor: Colors.green,
//                       bookedColor: Colors.white,
//                       moveToNextPrevSlot: true,
//                       onError: (error) => log("Error: $error"),
//                       onTimeLineEnd: () => log("Timeline Ended"),
//                       blockUntilCurrentTime: true,
//                       durationToBlock: 1,
//                       showCurrentBlockedSlot: true,
//                       currentBlockedColor: Colors.blue,
//                       selectedBarColor: Colors.white,
//                       selectedTextColor: Colors.white,
//                       textColor: Colors.black,
//                       barColor: Colors.grey,
//                       addBuffer: true,
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
//                           calculatePrice();
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   ElevatedButton(
//                     onPressed: () {
//                       showDialog(
//                         context: context,
//                         builder: (_) => AlertDialog(
//                           title: const Text("Booking Summary"),
//                           content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                   "Court Price: ₹${totalPrice - convenienceFee}"),
//                               Text("Convenience Fee: ₹$convenienceFee"),
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

// ---------------------------------------------------------------------------------------------------------------------------------------------------------------
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class BookingPage extends StatefulWidget {
//   final String venueId;
//   final String sportId;

//   const BookingPage({Key? key, required this.venueId, required this.sportId})
//       : super(key: key);

//   @override
//   _BookingPageState createState() => _BookingPageState();
// }

// class _BookingPageState extends State<BookingPage> {
//   final List<DateTime> _dates = [];
//   int _selectedDateIndex = 0;
//   String _selectedTime = '';
//   int _selectedDuration = 1; // Default to 1 hour
//   Map<String, dynamic> _slots = {};
//   Map<String, dynamic> _priceChart = {};

//   @override
//   void initState() {
//     super.initState();
//     _initializeDates();
//     _fetchPriceChart();
//     _fetchSlotAvailability();
//   }

//   // Generate dates for 7 days from today
//   void _initializeDates() {
//     final today = DateTime.now();
//     for (int i = 0; i < 7; i++) {
//       _dates.add(today.add(Duration(days: i)));
//     }
//   }

//   // Fetch the price chart for the sport
//   Future<void> _fetchPriceChart() async {
//     try {
//       final sportDoc = await FirebaseFirestore.instance
//           .collection('venues')
//           .doc(widget.venueId)
//           .collection('sports')
//           .doc(widget.sportId)
//           .get();
//       if (sportDoc.exists) {
//         setState(() {
//           _priceChart = sportDoc.data()?['price'] ?? {};
//         });
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error fetching price chart: $error'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   // Fetch slot availability
//   Future<void> _fetchSlotAvailability() async {
//     try {
//       final dateKey =
//           DateFormat('yyyy-MM-dd').format(_dates[_selectedDateIndex]);
//       final slotsDoc = await FirebaseFirestore.instance
//           .collection('venues')
//           .doc(widget.venueId)
//           .collection('sports')
//           .doc(widget.sportId)
//           .collection('bookings')
//           .doc(dateKey)
//           .get();
//       setState(() {
//         _slots = slotsDoc.data() ?? {};
//       });
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error fetching slot availability: $error'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   // Calculate total price
//   int _calculatePrice() {
//     final dayKey = DateFormat('EEEE')
//         .format(_dates[_selectedDateIndex]); // Day of the week
//     final priceForDay = _priceChart[dayKey] ?? {};
//     final price = priceForDay[_selectedTime] ?? 0;
//     return price * _selectedDuration;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Book a Slot'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Date selection
//             SizedBox(
//               height: 100,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: _dates.length,
//                 itemBuilder: (context, index) {
//                   final date = _dates[index];
//                   final formattedDate = DateFormat('MMM dd').format(date);
//                   final day = DateFormat('EEE').format(date);
//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _selectedDateIndex = index;
//                         _fetchSlotAvailability();
//                       });
//                     },
//                     child: Card(
//                       color: index == _selectedDateIndex
//                           ? Colors.blueAccent
//                           : Colors.white,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               day,
//                               style: TextStyle(
//                                 color: index == _selectedDateIndex
//                                     ? Colors.white
//                                     : Colors.black,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               formattedDate,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: index == _selectedDateIndex
//                                     ? Colors.white
//                                     : Colors.black,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Time and duration selection
//             Row(
//               children: [
//                 Expanded(
//                   child: DropdownButton<String>(
//                     isExpanded: true,
//                     value: _selectedTime.isNotEmpty ? _selectedTime : null,
//                     hint: const Text('Select Time'),
//                     items: List.generate(19, (index) {
//                       final time = DateFormat('hh:mm a')
//                           .format(DateTime(0, 0, 0, 5 + index));
//                       return DropdownMenuItem(
//                         value: time,
//                         child: Text(time),
//                       );
//                     }),
//                     onChanged: (value) {
//                       setState(() {
//                         _selectedTime = value ?? '';
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 DropdownButton<int>(
//                   value: _selectedDuration,
//                   items: List.generate(4, (index) {
//                     return DropdownMenuItem(
//                       value: index + 1,
//                       child: Text('${index + 1} hr'),
//                     );
//                   }),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedDuration = value ?? 1;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // Slots availability
//             Expanded(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 4,
//                   childAspectRatio: 1.5,
//                 ),
//                 itemCount: 19,
//                 itemBuilder: (context, index) {
//                   final timeSlot = DateFormat('hh:mm a')
//                       .format(DateTime(0, 0, 0, 5 + index));
//                   final isBooked = _slots[timeSlot] ?? false;

//                   return GestureDetector(
//                     onTap: !isBooked
//                         ? () {
//                             setState(() {
//                               _selectedTime = timeSlot;
//                             });
//                           }
//                         : null,
//                     child: Card(
//                       color: isBooked
//                           ? Colors.redAccent
//                           : (timeSlot == _selectedTime
//                               ? Colors.greenAccent
//                               : Colors.white),
//                       child: Center(
//                         child: Text(
//                           timeSlot,
//                           style: TextStyle(
//                             color: isBooked ? Colors.white : Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),

//             // Total Price
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Total Price: ₹${_calculatePrice()}',
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),

//             // Book Now Button
//             Center(
//               child: ElevatedButton(
//                 onPressed: _selectedTime.isNotEmpty
//                     ? () {
//                         // Handle booking logic
//                       }
//                     : null,
//                 child: const Text('Book Now'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

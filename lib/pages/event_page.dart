import 'package:flutter/material.dart';

class EventPage extends StatelessWidget {
  const EventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Events',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),

            const SizedBox(height: 20.0),

            // Featured Events section
            const Text(
              'Featured Events',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),

            // Horizontal list of featured event cards
            SizedBox(
              height: 250, // Adjust height based on the design needs
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  FeaturedEventCard(
                    eventName: 'Steve Aoki - Electronic Music Festival',
                    venue: 'Bangalore',
                    startDate: '10 February',
                    price: '₹1600',
                    imageUrl: 'assets/event1.jpg',
                  ),
                  FeaturedEventCard(
                    eventName: 'Jazz Festival',
                    venue: 'Mumbai',
                    startDate: '25 March',
                    price: '₹800',
                    imageUrl: 'assets/event2.jpg',
                  ),
                  FeaturedEventCard(
                    eventName: 'Comedy Night',
                    venue: 'Delhi',
                    startDate: '15 April',
                    price: '₹500',
                    imageUrl: 'assets/event3.jpg',
                  ),
                  FeaturedEventCard(
                    eventName: 'Art Exhibition',
                    venue: 'Chennai',
                    startDate: '5 May',
                    price: 'Free',
                    imageUrl: 'assets/event4.jpg',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20.0),

            // More Events section
            const Text(
              'More Events',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),

            // Vertical list of event cards
            Expanded(
              child: ListView(
                children: const [
                  EventCard(
                    eventName: 'Rock Concert',
                    venue: 'Pune',
                    startDate: '12 June',
                    price: '₹1200',
                    imageUrl: 'assets/event5.jpg',
                  ),
                  EventCard(
                    eventName: 'Food Festival',
                    venue: 'Hyderabad',
                    startDate: '23 July',
                    price: '₹300',
                    imageUrl: 'assets/event6.jpg',
                  ),
                  EventCard(
                    eventName: 'Film Screening',
                    venue: 'Kolkata',
                    startDate: '15 August',
                    price: '₹200',
                    imageUrl: 'assets/event7.jpg',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedEventCard extends StatelessWidget {
  final String eventName;
  final String venue;
  final String startDate;
  final String price;
  final String imageUrl;

  const FeaturedEventCard({
    super.key,
    required this.eventName,
    required this.venue,
    required this.startDate,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      margin: const EdgeInsets.only(right: 8.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(venue),
                  Text('Starting from $startDate'),
                  Text(price),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String eventName;
  final String venue;
  final String startDate;
  final String price;
  final String imageUrl;

  const EventCard({
    super.key,
    required this.eventName,
    required this.venue,
    required this.startDate,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eventName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(venue),
                  Text('Starting from $startDate'),
                  Text(price),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

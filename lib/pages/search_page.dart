// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:smash/providers/venue_provider.dart';
// import '../screens/details_page.dart';

// class SearchPage extends ConsumerStatefulWidget {
//   const SearchPage({super.key});

//   @override
//   ConsumerState<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends ConsumerState<SearchPage> {
//   final _searchController = TextEditingController();
//   Timer? _debounce;

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _debounce?.cancel();
//     super.dispose();
//   }

//   void _onSearchChanged(String query) {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       ref.read(venueNotifierProvider.notifier).searchVenues(query);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final venueState = ref.watch(venueNotifierProvider);
//     final searchResults = venueState.searchResults;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         foregroundColor: Colors.white,
//         title: TextField(
//           controller: _searchController,
//           onChanged: _onSearchChanged,
//           style: const TextStyle(color: Colors.white),
//           decoration: const InputDecoration(
//             hintText: 'Search venues...',
//             hintStyle: TextStyle(color: Colors.white70),
//             border: InputBorder.none,
//           ),
//         ),
//         actions: [
//           if (_searchController.text.isNotEmpty)
//             IconButton(
//               icon: const Icon(Icons.clear),
//               onPressed: () {
//                 _searchController.clear();
//                 ref.read(venueNotifierProvider.notifier).clearSearch();
//               },
//             ),
//         ],
//       ),
//       body: venueState.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : venueState.errorMessage != null
//               ? Center(child: Text(venueState.errorMessage!))
//               : searchResults.isEmpty
//                   ? const Center(child: Text('No venues found'))
//                   : ListView.builder(
//                       itemCount: searchResults.length,
//                       itemBuilder: (context, index) {
//                         final venue = searchResults[index];
//                         return ListTile(
//                           leading: venue.displayImage != null
//                               ? Image.network(
//                                   venue.displayImage!,
//                                   width: 50,
//                                   height: 50,
//                                   fit: BoxFit.cover,
//                                 )
//                               : const Icon(Icons.sports),
//                           title: Text(venue.venueName),
//                           subtitle: Text('₹${venue.price}/hour'),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     DetailsPage(venueId: venue.id),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//     );
//   }
// }
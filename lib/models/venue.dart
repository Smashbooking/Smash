import 'package:freezed_annotation/freezed_annotation.dart';

part 'venue.freezed.dart';
part 'venue.g.dart';

@freezed
class Venue with _$Venue {
  const factory Venue({
    required String id,
    required String venueName,
    String? displayImage,
    required String address,
    required String contact,
    required String hours,
    required double price,
    List<String>? amenities,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}

@freezed
class Sport with _$Sport {
  const factory Sport({
    required String id,
    required String sportName,
    required String venueId,
  }) = _Sport;

  factory Sport.fromJson(Map<String, dynamic> json) => _$SportFromJson(json);
}
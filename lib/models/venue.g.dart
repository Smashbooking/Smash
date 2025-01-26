// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VenueImpl _$$VenueImplFromJson(Map<String, dynamic> json) => _$VenueImpl(
      id: json['id'] as String,
      venueName: json['venueName'] as String,
      displayImage: json['displayImage'] as String?,
      address: json['address'] as String,
      contact: json['contact'] as String,
      hours: json['hours'] as String,
      price: (json['price'] as num).toDouble(),
      amenities: (json['amenities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$VenueImplToJson(_$VenueImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'venueName': instance.venueName,
      'displayImage': instance.displayImage,
      'address': instance.address,
      'contact': instance.contact,
      'hours': instance.hours,
      'price': instance.price,
      'amenities': instance.amenities,
    };

_$SportImpl _$$SportImplFromJson(Map<String, dynamic> json) => _$SportImpl(
      id: json['id'] as String,
      sportName: json['sportName'] as String,
      venueId: json['venueId'] as String,
    );

Map<String, dynamic> _$$SportImplToJson(_$SportImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sportName': instance.sportName,
      'venueId': instance.venueId,
    };

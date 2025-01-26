// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'venue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Venue _$VenueFromJson(Map<String, dynamic> json) {
  return _Venue.fromJson(json);
}

/// @nodoc
mixin _$Venue {
  String get id => throw _privateConstructorUsedError;
  String get venueName => throw _privateConstructorUsedError;
  String? get displayImage => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String get contact => throw _privateConstructorUsedError;
  String get hours => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  List<String>? get amenities => throw _privateConstructorUsedError;

  /// Serializes this Venue to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VenueCopyWith<Venue> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VenueCopyWith<$Res> {
  factory $VenueCopyWith(Venue value, $Res Function(Venue) then) =
      _$VenueCopyWithImpl<$Res, Venue>;
  @useResult
  $Res call(
      {String id,
      String venueName,
      String? displayImage,
      String address,
      String contact,
      String hours,
      double price,
      List<String>? amenities});
}

/// @nodoc
class _$VenueCopyWithImpl<$Res, $Val extends Venue>
    implements $VenueCopyWith<$Res> {
  _$VenueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueName = null,
    Object? displayImage = freezed,
    Object? address = null,
    Object? contact = null,
    Object? hours = null,
    Object? price = null,
    Object? amenities = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      venueName: null == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String,
      displayImage: freezed == displayImage
          ? _value.displayImage
          : displayImage // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      contact: null == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as String,
      hours: null == hours
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      amenities: freezed == amenities
          ? _value.amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VenueImplCopyWith<$Res> implements $VenueCopyWith<$Res> {
  factory _$$VenueImplCopyWith(
          _$VenueImpl value, $Res Function(_$VenueImpl) then) =
      __$$VenueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String venueName,
      String? displayImage,
      String address,
      String contact,
      String hours,
      double price,
      List<String>? amenities});
}

/// @nodoc
class __$$VenueImplCopyWithImpl<$Res>
    extends _$VenueCopyWithImpl<$Res, _$VenueImpl>
    implements _$$VenueImplCopyWith<$Res> {
  __$$VenueImplCopyWithImpl(
      _$VenueImpl _value, $Res Function(_$VenueImpl) _then)
      : super(_value, _then);

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? venueName = null,
    Object? displayImage = freezed,
    Object? address = null,
    Object? contact = null,
    Object? hours = null,
    Object? price = null,
    Object? amenities = freezed,
  }) {
    return _then(_$VenueImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      venueName: null == venueName
          ? _value.venueName
          : venueName // ignore: cast_nullable_to_non_nullable
              as String,
      displayImage: freezed == displayImage
          ? _value.displayImage
          : displayImage // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      contact: null == contact
          ? _value.contact
          : contact // ignore: cast_nullable_to_non_nullable
              as String,
      hours: null == hours
          ? _value.hours
          : hours // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      amenities: freezed == amenities
          ? _value._amenities
          : amenities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VenueImpl implements _Venue {
  const _$VenueImpl(
      {required this.id,
      required this.venueName,
      this.displayImage,
      required this.address,
      required this.contact,
      required this.hours,
      required this.price,
      final List<String>? amenities})
      : _amenities = amenities;

  factory _$VenueImpl.fromJson(Map<String, dynamic> json) =>
      _$$VenueImplFromJson(json);

  @override
  final String id;
  @override
  final String venueName;
  @override
  final String? displayImage;
  @override
  final String address;
  @override
  final String contact;
  @override
  final String hours;
  @override
  final double price;
  final List<String>? _amenities;
  @override
  List<String>? get amenities {
    final value = _amenities;
    if (value == null) return null;
    if (_amenities is EqualUnmodifiableListView) return _amenities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Venue(id: $id, venueName: $venueName, displayImage: $displayImage, address: $address, contact: $contact, hours: $hours, price: $price, amenities: $amenities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VenueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.venueName, venueName) ||
                other.venueName == venueName) &&
            (identical(other.displayImage, displayImage) ||
                other.displayImage == displayImage) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.contact, contact) || other.contact == contact) &&
            (identical(other.hours, hours) || other.hours == hours) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality()
                .equals(other._amenities, _amenities));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      venueName,
      displayImage,
      address,
      contact,
      hours,
      price,
      const DeepCollectionEquality().hash(_amenities));

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VenueImplCopyWith<_$VenueImpl> get copyWith =>
      __$$VenueImplCopyWithImpl<_$VenueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VenueImplToJson(
      this,
    );
  }
}

abstract class _Venue implements Venue {
  const factory _Venue(
      {required final String id,
      required final String venueName,
      final String? displayImage,
      required final String address,
      required final String contact,
      required final String hours,
      required final double price,
      final List<String>? amenities}) = _$VenueImpl;

  factory _Venue.fromJson(Map<String, dynamic> json) = _$VenueImpl.fromJson;

  @override
  String get id;
  @override
  String get venueName;
  @override
  String? get displayImage;
  @override
  String get address;
  @override
  String get contact;
  @override
  String get hours;
  @override
  double get price;
  @override
  List<String>? get amenities;

  /// Create a copy of Venue
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VenueImplCopyWith<_$VenueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Sport _$SportFromJson(Map<String, dynamic> json) {
  return _Sport.fromJson(json);
}

/// @nodoc
mixin _$Sport {
  String get id => throw _privateConstructorUsedError;
  String get sportName => throw _privateConstructorUsedError;
  String get venueId => throw _privateConstructorUsedError;

  /// Serializes this Sport to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Sport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SportCopyWith<Sport> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SportCopyWith<$Res> {
  factory $SportCopyWith(Sport value, $Res Function(Sport) then) =
      _$SportCopyWithImpl<$Res, Sport>;
  @useResult
  $Res call({String id, String sportName, String venueId});
}

/// @nodoc
class _$SportCopyWithImpl<$Res, $Val extends Sport>
    implements $SportCopyWith<$Res> {
  _$SportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Sport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sportName = null,
    Object? venueId = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sportName: null == sportName
          ? _value.sportName
          : sportName // ignore: cast_nullable_to_non_nullable
              as String,
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SportImplCopyWith<$Res> implements $SportCopyWith<$Res> {
  factory _$$SportImplCopyWith(
          _$SportImpl value, $Res Function(_$SportImpl) then) =
      __$$SportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String sportName, String venueId});
}

/// @nodoc
class __$$SportImplCopyWithImpl<$Res>
    extends _$SportCopyWithImpl<$Res, _$SportImpl>
    implements _$$SportImplCopyWith<$Res> {
  __$$SportImplCopyWithImpl(
      _$SportImpl _value, $Res Function(_$SportImpl) _then)
      : super(_value, _then);

  /// Create a copy of Sport
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sportName = null,
    Object? venueId = null,
  }) {
    return _then(_$SportImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sportName: null == sportName
          ? _value.sportName
          : sportName // ignore: cast_nullable_to_non_nullable
              as String,
      venueId: null == venueId
          ? _value.venueId
          : venueId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SportImpl implements _Sport {
  const _$SportImpl(
      {required this.id, required this.sportName, required this.venueId});

  factory _$SportImpl.fromJson(Map<String, dynamic> json) =>
      _$$SportImplFromJson(json);

  @override
  final String id;
  @override
  final String sportName;
  @override
  final String venueId;

  @override
  String toString() {
    return 'Sport(id: $id, sportName: $sportName, venueId: $venueId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SportImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sportName, sportName) ||
                other.sportName == sportName) &&
            (identical(other.venueId, venueId) || other.venueId == venueId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, sportName, venueId);

  /// Create a copy of Sport
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SportImplCopyWith<_$SportImpl> get copyWith =>
      __$$SportImplCopyWithImpl<_$SportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SportImplToJson(
      this,
    );
  }
}

abstract class _Sport implements Sport {
  const factory _Sport(
      {required final String id,
      required final String sportName,
      required final String venueId}) = _$SportImpl;

  factory _Sport.fromJson(Map<String, dynamic> json) = _$SportImpl.fromJson;

  @override
  String get id;
  @override
  String get sportName;
  @override
  String get venueId;

  /// Create a copy of Sport
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SportImplCopyWith<_$SportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

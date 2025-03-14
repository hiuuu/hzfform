// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../core/enums.dart';
import 'field_model.dart';

class HZFFormMapPickerModel extends HZFFormFieldModel {
  /// Button text
  final String? buttonText;

  /// Button icon
  final IconData? pickerIcon;

  /// Button color
  final Color? buttonColor;

  /// Picker screen title
  final String? pickerTitle;

  /// Default map center
  final LatLng? defaultCenter;

  /// Default zoom level
  final double? defaultZoom;

  /// Preview map height
  final double? previewHeight;

  /// Preview map zoom level
  final double? previewZoom;

  /// Use lite mode for preview map
  final bool? useLiteMode;

  /// Map type
  final MapType? mapType;

  /// Show user location on map
  final bool? showMyLocation;

  /// Show my location button
  final bool? showMyLocationButton;

  /// Use current location as initial position
  final bool useCurrentLocation;

  /// Enable search functionality
  final bool enableSearch;

  /// Search hint text
  final String? searchHint;

  /// Enable reverse geocoding
  final bool enableReverseGeocoding;

  /// Custom marker icon
  final BitmapDescriptor? customMarkerIcon;

  /// Places client for autocomplete
  final PlacesClient? placesClient;

  /// Callback when location is selected
  final Function(MapLocation)? onLocationSelected;

  HZFFormMapPickerModel({
    required String tag,
    this.buttonText,
    this.pickerIcon,
    this.buttonColor,
    this.pickerTitle,
    this.defaultCenter,
    this.defaultZoom,
    this.previewHeight,
    this.previewZoom,
    this.useLiteMode,
    this.mapType,
    this.showMyLocation,
    this.showMyLocationButton,
    this.useCurrentLocation = true,
    this.enableSearch = true,
    this.searchHint,
    this.enableReverseGeocoding = true,
    this.customMarkerIcon,
    this.placesClient,
    this.onLocationSelected,

    // Parent props
    String? title,
    String? errorMessage,
    String? helpMessage,
    Widget? prefixWidget,
    Widget? postfixWidget,
    bool? required,
    bool? showTitle,
    dynamic value, // MapLocation
    RegExp? validateRegEx,
    int? weight,
    FocusNode? focusNode,
    FocusNode? nextFocusNode,
    VoidCallback? onTap,
    HZFFormFieldStatusEnum? status,
    bool? enableReadOnly,
  }) : super(
          tag: tag,
          type: HZFFormFieldTypeEnum.mapPicker,
          title: title,
          errorMessage: errorMessage,
          helpMessage: helpMessage,
          prefixWidget: prefixWidget,
          postfixWidget: postfixWidget,
          required: required,
          showTitle: showTitle,
          value: value,
          validateRegEx: validateRegEx,
          weight: weight,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
          onTap: onTap,
          status: status,
          enableReadOnly: enableReadOnly,
        );
}

/// Places autocomplete prediction
class AutocompletePrediction {
  final String placeId;
  final String primaryText;
  final String secondaryText;

  AutocompletePrediction({
    required this.placeId,
    required this.primaryText,
    required this.secondaryText,
  });
}

/// Places client interface
abstract class PlacesClient {
  Future<List<AutocompletePrediction>> findAutocompletePredictions(
    String query, {
    String? sessionToken,
  });

  Future<PlaceDetails?> getPlaceDetails(
    String placeId, {
    List<String>? fields,
  });
}

/// Place details model
class PlaceDetails {
  final LatLngBounds? viewport;
  final PlaceGeometry? geometry;
  final String? formattedAddress;

  PlaceDetails({
    this.viewport,
    this.geometry,
    this.formattedAddress,
  });
}

/// Place geometry model
class PlaceGeometry {
  final LatLngLocation location;

  PlaceGeometry({
    required this.location,
  });
}

/// LatLng location model
class LatLngLocation {
  final double lat;
  final double lng;

  LatLngLocation({
    required this.lat,
    required this.lng,
  });
}

/// LatLng bounds model
class LatLngBounds {
  final LatLngLocation northeast;
  final LatLngLocation southwest;

  LatLngBounds({
    required this.northeast,
    required this.southwest,
  });
}

/// Map location model
class MapLocation {
  final double latitude;
  final double longitude;
  final String? address;
  final String? placeId;

  const MapLocation({
    required this.latitude,
    required this.longitude,
    this.address,
    this.placeId,
  });

  MapLocation copyWith({
    double? latitude,
    double? longitude,
    String? address,
    String? placeId,
  }) {
    return MapLocation(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      placeId: placeId ?? this.placeId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'placeId': placeId,
    };
  }

  factory MapLocation.fromJson(Map<String, dynamic> json) {
    return MapLocation(
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      placeId: json['placeId'],
    );
  }
}


/*
USAGE:

// Google Maps Places Client implementation
class GooglePlacesClient implements PlacesClient {
  final String apiKey;
  
  GooglePlacesClient({required this.apiKey});
  
  @override
  Future<List<AutocompletePrediction>> findAutocompletePredictions(
    String query, {String? sessionToken}
  ) async {
    final url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json'
      '?input=$query&key=$apiKey${sessionToken != null ? '&sessiontoken=$sessionToken' : ''}';
    
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    
    if (data['status'] == 'OK') {
      return (data['predictions'] as List).map((prediction) {
        return AutocompletePrediction(
          placeId: prediction['place_id'],
          primaryText: prediction['structured_formatting']['main_text'],
          secondaryText: prediction['structured_formatting']['secondary_text'],
        );
      }).toList();
    }
    
    return [];
  }
  
  @override
  Future<PlaceDetails?> getPlaceDetails(
    String placeId, {List<String>? fields}
  ) async {
    final fieldsParam = fields != null ? '&fields=${fields.join(",")}' : '';
    final url = 'https://maps.googleapis.com/maps/api/place/details/json'
      '?place_id=$placeId$fieldsParam&key=$apiKey';
    
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    
    if (data['status'] == 'OK') {
      final result = data['result'];
      final geometry = result['geometry'];
      
      return PlaceDetails(
        formattedAddress: result['formatted_address'],
        geometry: geometry != null ? PlaceGeometry(
          location: LatLngLocation(
            lat: geometry['location']['lat'],
            lng: geometry['location']['lng'],
          ),
        ) : null,
      );
    }
    
    return null;
  }
}

// Create map picker field
final locationField = HZFFormMapPickerModel(
  tag: 'location',
  title: 'Business Location',
  required: true,
  buttonText: 'Pick Location on Map',
  pickerTitle: 'Set Business Location',
  defaultCenter: const LatLng(37.7749, -122.4194), // San Francisco
  enableSearch: true,
  searchHint: 'Search for address or landmark',
  placesClient: GooglePlacesClient(apiKey: 'YOUR_API_KEY'),
  onLocationSelected: (location) {
    print('Selected: ${location.address}');
  },
);

*/
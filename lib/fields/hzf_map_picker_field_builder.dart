import 'dart:async' show Completer;

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/field_model.dart';
import '../models/map_picker_model.dart';
import '../core/controller.dart';
import 'hzf_field_builder.dart';

class MapPickerFieldBuilder implements FieldBuilder {
  @override
  Widget build(
    HZFFormFieldModel model,
    HZFFormController controller,
    BuildContext context,
  ) {
    final mapModel = model as HZFFormMapPickerModel;

    // Current location value
    final locationValue = mapModel.value as MapLocation?;

    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview map with selected location
          if (locationValue != null) _buildMapPreview(locationValue, mapModel),

          const SizedBox(height: 8),

          // Map picker button
          ElevatedButton.icon(
            onPressed: mapModel.enableReadOnly == true
                ? null
                : () => _showMapPicker(
                    context, mapModel, controller, locationValue),
            icon: Icon(mapModel.pickerIcon ?? Icons.map),
            label: Text(mapModel.buttonText ?? 'Select Location'),
            style: ElevatedButton.styleFrom(
              backgroundColor: mapModel.buttonColor,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),

          // Display selected address
          if (locationValue != null && locationValue.address != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      locationValue.address!,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (!mapModel.enableReadOnly!)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        controller.updateFieldValue(mapModel.tag, null);
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapPreview(MapLocation location, HZFFormMapPickerModel model) {
    return Container(
      height: model.previewHeight ?? 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(location.latitude, location.longitude),
          zoom: model.previewZoom ?? 14,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('selected'),
            position: LatLng(location.latitude, location.longitude),
            icon: model.customMarkerIcon ?? BitmapDescriptor.defaultMarker,
          ),
        },
        zoomControlsEnabled: false,
        mapToolbarEnabled: false,
        myLocationButtonEnabled: false,
        compassEnabled: false,
        rotateGesturesEnabled: false,
        scrollGesturesEnabled: false,
        zoomGesturesEnabled: false,
        tiltGesturesEnabled: false,
        liteModeEnabled: model.useLiteMode ?? true,
      ),
    );
  }

  Future<void> _showMapPicker(
    BuildContext context,
    HZFFormMapPickerModel model,
    HZFFormController controller,
    MapLocation? initialLocation,
  ) async {
    final result = await Navigator.push<MapLocation>(
      context,
      MaterialPageRoute(
        builder: (context) => _MapPickerScreen(
          initialLocation: initialLocation,
          model: model,
        ),
      ),
    );

    if (result != null) {
      controller.updateFieldValue(model.tag, result);
      model.onLocationSelected?.call(result);
    }
  }
}

/// Full-screen map picker screen
class _MapPickerScreen extends StatefulWidget {
  final MapLocation? initialLocation;
  final HZFFormMapPickerModel model;

  const _MapPickerScreen({
    this.initialLocation,
    required this.model,
  });

  @override
  _MapPickerScreenState createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<_MapPickerScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();

  MapLocation? _selectedLocation;
  bool _isSearching = false;
  List<AutocompletePrediction> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;

    // Request current location if enabled and no initial location
    if (widget.model.useCurrentLocation && _selectedLocation == null) {
      _getCurrentLocation();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.pickerTitle ?? 'Select Location'),
        actions: [
          if (_selectedLocation != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, _selectedLocation);
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation != null
                  ? LatLng(
                      _selectedLocation!.latitude, _selectedLocation!.longitude)
                  : widget.model.defaultCenter ?? const LatLng(0, 0),
              zoom: widget.model.defaultZoom ?? 12,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected'),
                      position: LatLng(_selectedLocation!.latitude,
                          _selectedLocation!.longitude),
                      icon: widget.model.customMarkerIcon ??
                          BitmapDescriptor.defaultMarker,
                    ),
                  }
                : {},
            myLocationEnabled: widget.model.showMyLocation ?? true,
            myLocationButtonEnabled: widget.model.showMyLocationButton ?? true,
            mapType: widget.model.mapType ?? MapType.normal,
            onTap: (LatLng position) {
              _handleMapTap(position);
            },
          ),

          // Search bar
          if (widget.model.enableSearch)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  // Search input
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: widget.model.searchHint ?? 'Search location',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchResults.clear();
                                    _isSearching = false;
                                  });
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onChanged: _handleSearchInput,
                    ),
                  ),

                  // Search results
                  if (_isSearching && _searchResults.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final result = _searchResults[index];
                          return ListTile(
                            title: Text(result.primaryText),
                            subtitle: Text(
                              result.secondaryText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            onTap: () => _selectSearchResult(result),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: widget.model.useCurrentLocation
          ? FloatingActionButton(
              onPressed: _getCurrentLocation,
              mini: true,
              child: const Icon(Icons.my_location),
            )
          : null,
    );
  }

  Future<void> _handleMapTap(LatLng position) async {
    setState(() {
      _selectedLocation = MapLocation(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    });

    // Reverse geocode to get address
    if (widget.model.enableReverseGeocoding) {
      final address = await _getAddressFromLatLng(position);
      if (address != null) {
        setState(() {
          _selectedLocation = _selectedLocation!.copyWith(address: address);
        });
      }
    }
  }

  Future<void> _handleSearchInput(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Perform place search
    try {
      final sessionToken = Uuid().v4();
      final predictions =
          await widget.model.placesClient?.findAutocompletePredictions(
        query,
        sessionToken: sessionToken,
      );

      setState(() {
        _searchResults = predictions ?? [];
      });
    } catch (e) {
      debugPrint('Error searching places: $e');
    }
  }

  Future<void> _selectSearchResult(AutocompletePrediction prediction) async {
    try {
      final placeId = prediction.placeId;
      final details = await widget.model.placesClient?.getPlaceDetails(
        placeId,
        fields: ['geometry', 'formatted_address'],
      );

      if (details != null && details.geometry != null) {
        final location = LatLng(
          details.geometry!.location.lat,
          details.geometry!.location.lng,
        );

        setState(() {
          _selectedLocation = MapLocation(
            latitude: location.latitude,
            longitude: location.longitude,
            address: details.formattedAddress,
            placeId: placeId,
          );
          _searchController.text = prediction.primaryText;
          _searchResults.clear();
          _isSearching = false;
        });

        // Move camera to selection
        final mapController = await _controller.future;
        mapController.animateCamera(CameraUpdate.newLatLngZoom(
          location,
          widget.model.defaultZoom ?? 15,
        ));
      }
    } catch (e) {
      debugPrint('Error getting place details: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final location = LatLng(position.latitude, position.longitude);

      setState(() {
        _selectedLocation = MapLocation(
          latitude: location.latitude,
          longitude: location.longitude,
        );
      });

      // Get address from coordinates
      if (widget.model.enableReverseGeocoding) {
        final address = await _getAddressFromLatLng(location);
        if (address != null) {
          setState(() {
            _selectedLocation = _selectedLocation!.copyWith(address: address);
          });
        }
      }

      // Move camera to current location
      final mapController = await _controller.future;
      mapController.animateCamera(CameraUpdate.newLatLngZoom(
        location,
        widget.model.defaultZoom ?? 15,
      ));
    } catch (e) {
      debugPrint('Error getting current location: $e');
    }
  }

  Future<String?> _getAddressFromLatLng(LatLng position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final components = [
          place.street,
          place.locality,
          place.administrativeArea,
          place.postalCode,
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        return components;
      }
    } catch (e) {
      debugPrint('Error reverse geocoding: $e');
    }
    return null;
  }
}

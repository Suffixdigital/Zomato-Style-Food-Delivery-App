import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressListScreen extends ConsumerStatefulWidget {
  const AddressListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AddressListScreenState();
}

class AddressListScreenState extends ConsumerState<AddressListScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? centerLatLng;
  String? address;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  /// Get current GPS location
  Future<void> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      centerLatLng = LatLng(position.latitude, position.longitude);
    });

    await getAddressFromLatLng(centerLatLng!);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(centerLatLng!, 16));
  }

  /// Get human-readable address from coordinates
  Future<void> getAddressFromLatLng(LatLng latLng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

      Placemark place = placemarks.first;
      setState(() {
        address = "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      setState(() => address = "Unable to get address");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          centerLatLng == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                alignment: Alignment.center,
                children: [
                  /// Google Map
                  GoogleMap(
                    initialCameraPosition: CameraPosition(target: centerLatLng!, zoom: 16),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },

                    /// update location as camera moves
                    onCameraMove: (position) {
                      centerLatLng = position.target;
                    },

                    /// when user stops moving camera
                    onCameraIdle: () async {
                      if (centerLatLng != null) {
                        await getAddressFromLatLng(centerLatLng!);
                      }
                    },
                  ),

                  /// Fixed Pin in Center (Uber style)
                  const Icon(Icons.location_pin, size: 50, color: Colors.red),

                  /// Address Overlay
                  if (address != null)
                    Positioned(
                      bottom: 100,
                      left: 16,
                      right: 16,
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(address!, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                ],
              ),

      /// Proceed Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (centerLatLng != null && address != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text("Proceeding with: $address\nLat: ${centerLatLng!.latitude}, Lng: ${centerLatLng!.longitude}")));
            }
          },
          child: const Text("Proceed"),
        ),
      ),
    );
  }
}

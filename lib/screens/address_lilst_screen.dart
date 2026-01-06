import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressListScreen extends ConsumerStatefulWidget {
  const AddressListScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AddressListScreenState();
}

class AddressListScreenState extends ConsumerState<AddressListScreen> {
  // final Completer<GoogleMapController> _controller = Completer();
  // LatLng? centerLatLng;
  String? address;

  @override
  void initState() {
    super.initState();
    // getCurrentLocation();
  }

  /// Get current GPS location
  /*Future<void> getCurrentLocation() async {
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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

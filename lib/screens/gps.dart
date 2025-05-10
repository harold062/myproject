import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart'; // Import this to format the time
import 'package:geocoding/geocoding.dart'; // Import geocoding package

class GPSDemo extends StatefulWidget {
  @override
  _GPSDemoState createState() => _GPSDemoState();
}

class _GPSDemoState extends State<GPSDemo> {
  String _location = 'Press the button to get location';
  String _time = ''; // To hold the time when location is fetched

  // Function to get the location and time
  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _location = 'Location services are disabled.';
        _time = '';
      });
      return;
    }

    // Check permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _location = 'Location permissions are denied';
          _time = '';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _location = 'Location permissions are permanently denied';
        _time = '';
      });
      return;
    }

    try {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get the current time
      String formattedTime = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());
      String address = 'Unknown';
      String nearestKnown = ''; // To hold the nearest address

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        // Try to find a suitable placemark
        for (var place in placemarks) {
          final composedAddress =
              '${place.name?.isNotEmpty == true ? place.name! + ', ' : ''}'
              '${place.locality?.isNotEmpty == true ? place.locality! + ', ' : ''}'
              '${place.administrativeArea?.isNotEmpty == true ? place.administrativeArea! + ', ' : ''}'
              '${place.country ?? ''}';

          // If the main address is unknown and we find any address, store it as nearestKnown
          if (address == 'Unknown' && composedAddress.trim().isNotEmpty) {
            nearestKnown = composedAddress;
          }

          // If we find a detailed address, use it as the main address
          if (place.name?.isNotEmpty == true &&
              place.locality?.isNotEmpty == true &&
              place.administrativeArea?.isNotEmpty == true) {
            address = composedAddress;
            break;
          }
        }
      } catch (e) {
        // address remains 'Unknown'
      }

      // Prepare the display text
      String displayText =
          'Address: $address\n'
          'Lat: ${position.latitude}, Lon: ${position.longitude}\n'
          'Time: $formattedTime';

      if (address == 'Unknown' && nearestKnown.isNotEmpty) {
        displayText += '\nNearest address known: $nearestKnown';
      }

      setState(() {
        _location = displayText;
        _time = ''; // We already include the time in _location
      });
    } catch (e) {
      setState(() {
        _location = 'Failed to get location: $e';
        _time = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GPS Location")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _location, // Location displayed here
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              _time, // Time displayed here (if needed)
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        child: Icon(Icons.location_on),
      ),
    );
  }
}

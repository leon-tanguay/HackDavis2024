import 'package:geocoding/geocoding.dart';

class Restaurant {
  String name;
  String address;
  int id;
  double? latitude; // Nullable latitude
  double? longitude; // Nullable longitude

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
  }) {
    _fetchCoordinates();
  }

  // Method to fetch GPS coordinates based on the address
  Future<void> _fetchCoordinates() async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        latitude = locations[0].latitude;
        longitude = locations[0].longitude;
      }

    } catch (e) {
      print("Error fetching coordinates: $e");
    }
  }
}
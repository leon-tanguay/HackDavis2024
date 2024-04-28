import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import 'package:namer_app/widgets/location.dart';
import 'package:namer_app/widgets/fakeData.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/coupon.dart';
import '../widgets/coupon_db_helper.dart';

const styleUrl = "https://tiles.stadiamaps.com/tiles/stamen_toner_lite/{z}/{x}/{y}{r}.png";
const apiKey = "3a0643a5-bac4-4bac-8257-8d213113c928";  // TODO: Replace this with your own API key. Sign up for free at https://client.stadiamaps.com/signup/

class MapScreen extends StatelessWidget {  

  List<Marker> getMarkers() {
    //List<Coupon> couponList = CouponDatabaseHelper.getCoupons();
    return List<Marker>.from(FakeData.fakeLocations.map((e) => Marker(point: lat_lng.LatLng(e.latitude, e.longitude), 
    child:Icon(
          Icons.location_pin,
          color: Colors.red,
          size: 30.0,
    ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: lat_lng.LatLng(38.5449, -121.7405),
              initialZoom: 12.3,
              keepAlive: true 
            ),
            children: [
              TileLayer(
                  urlTemplate:
                  "$styleUrl?api_key={api_key}",
                  additionalOptions: {
                    "api_key": apiKey
                  },
                  minZoom: 6,
	                maxZoom: 20,
              ),
              MarkerLayer(
                markers: getMarkers()
              ),
              RichAttributionWidget(attributions: [
                TextSourceAttribution("Stadia Maps",
                    onTap: () => launchUrl(Uri.parse("https://stadiamaps.com/")),
                    prependCopyright: true),
                TextSourceAttribution("OpenMapTiles",
                    onTap: () =>
                        launchUrl(Uri.parse("https://openmaptiles.org/")),
                    prependCopyright: true),
                TextSourceAttribution("OpenStreetMap",
                    onTap: () => launchUrl(
                        Uri.parse("https://www.openstreetmap.org/copyright")),
                    prependCopyright: true),
              ]),
            ],
          ),  
        ],
      ),
    );
  }
}


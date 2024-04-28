import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as lat_lng;
import 'package:url_launcher/url_launcher.dart';

const styleUrl = "https://tiles.stadiamaps.com/tiles/stamen_toner_lite/{z}/{x}/{y}{r}.png";
const apiKey = "3a0643a5-bac4-4bac-8257-8d213113c928";  // TODO: Replace this with your own API key. Sign up for free at https://client.stadiamaps.com/signup/

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: lat_lng.LatLng(38.5449, -121.7405),
              initialZoom: 12.0,
              keepAlive: true 
            ),
            children: [
              TileLayer(
                  urlTemplate:
                  "$styleUrl?api_key={api_key}",
                  additionalOptions: {
                    "api_key": apiKey
                  },
                  minZoom: 0,
	                maxZoom: 20,
              ),
              MarkerLayerOptions(
                markers: _buildMarkers(),
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


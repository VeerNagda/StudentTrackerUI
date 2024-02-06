import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:latlong2/latlong.dart';
import '../utils/Constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController _mapController;
  late List<Marker> _markers = [];
  late List<LatLng> _polyPoints = [];
  TextEditingController controller = TextEditingController();
  late bool isWeb;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation();
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        isWeb = false;
      } else {
        isWeb = true;
      }
    } catch (e) {
      isWeb = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FlutterMap(
          options: MapOptions(
            center: const LatLng(19.107579, 72.837509),
            zoom: 17,
            onLongPress: (position, latLong) {
              _markers.add(Marker(
                point: latLong,
                child: const Icon(Icons.location_on),
              ));
              _polyPoints.add(latLong);
              setState(() {
                _markers = _markers;
                _polyPoints = _polyPoints;
              });
            },
          ),
          mapController: _mapController,
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
              tileProvider: CancellableNetworkTileProvider(),
            ),
            RichAttributionWidget(
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                      Uri.parse('https://openstreetmap.org/copyright')),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: saveVenue,
                      child: const Icon(Icons.save_alt),
                    ),
                    ElevatedButton(
                      onPressed: _getUserLocation,
                      child: const Icon(Icons.navigation),
                    ),
                  ],
                ),
              ),
            ),
            CurrentLocationLayer(
              positionStream: const LocationMarkerDataStreamFactory()
                  .fromGeolocatorPositionStream(
                stream: Geolocator.getPositionStream(
                  locationSettings: const LocationSettings(
                    accuracy: LocationAccuracy.high,
                    distanceFilter: 50,
                    timeLimit: Duration(seconds: 30),
                  ),
                ),
              ),
            ),
            MarkerLayer(
              markers: _markers,
            ),
            PolygonLayer(
              polygons: [
                Polygon(
                  points: _polyPoints,
                  color: Colors.blueGrey.shade200.withOpacity(0.5),
                  isFilled: true,
                  isDotted: true,
                ),
              ],
            ),
            Card(
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(width: 1, color: Colors.grey),
              ),
              clipBehavior: Clip.antiAlias,
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxWidth: 300, maxHeight: 49.4),
                child: Scaffold(
                  body: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        placesAutoCompleteTextField(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  placesAutoCompleteTextField() {
    return Container(
      alignment: Alignment.topLeft,
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
        googleAPIKey: apiKey,
        inputDecoration: const InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: const ["in", "fr"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          if (kDebugMode) {
            print(prediction.lng);
          }

          double latitude = double.parse(prediction.lat ?? '0.0');
          double longitude = double.parse(prediction.lng ?? '0.0');
          _mapController.move(LatLng(latitude, longitude), 17);
        },
        itemClick: (Prediction prediction) {
          controller.text = prediction.description ?? "";
          controller.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
        },
        seperatedBuilder: const Divider(),
        containerHorizontalPadding: 10,

        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          return Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(
                width: 7,
              ),
              Expanded(child: Text(prediction.description ?? ""))
            ],
          );
        },

        isCrossBtnShown: true,
        boxDecoration: const BoxDecoration(
          color: Colors.transparent,
        ),

        // default 600 ms ,
      ),
    );
  }

  void _getUserLocation() async {
    try {
      var position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 50,
          timeLimit: Duration(seconds: 20),
        ),
      );
      _mapController.move(LatLng(position.latitude, position.longitude), 17);
    } catch (e) {
      if (e is TimeoutException) {
        if (!isWeb) {
          var position = await GeolocatorPlatform.instance
              .getLastKnownPosition(forceLocationManager: true);
          if (position?.latitude != null) {
            _mapController.move(
                LatLng(position!.latitude, position.longitude), 17);
          }
        }
      }
    }
  }

  saveVenue() {
    //TODO implement code for sending to server.
  }

  Future<void> placeAutoComplete(String query) async {
    Uri uri =
        Uri.https("maps.googleapis.com", "maps/api/place/autocomplete/json", {
      "input": query,
      "key": apiKey,
    });
    //TODO
    const int respose = 100;
    if (respose != null) {
      if (kDebugMode) {
        print(respose);
      }
    }
  }
}

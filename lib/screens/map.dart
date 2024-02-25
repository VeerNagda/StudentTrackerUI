import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:latlong2/latlong.dart';
import 'package:ui/models/venue/venue_request_model.dart';
import 'package:ui/services/api_service.dart';
import 'package:ui/utils/constants.dart';
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
  late final VenueRequestModel _venueRequestModel;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation();
    _venueRequestModel = VenueRequestModel();
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> showDataAlert(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) {
        final TextEditingController venueId = TextEditingController();
        final TextEditingController venueName = TextEditingController();
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Text(
            "Save Venue",
            style: TextStyle(fontSize: 24.0),
          ),
          content: Form(
            key: _formKey,
            child: SizedBox(
              height: 250,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Save Venue",
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: venueId,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Venue Id',
                          labelText: 'ID',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: venueName,
                        validator: (value) {
                          return value!.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Venue Name',
                          labelText: 'Name',
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _venueRequestModel.id = venueId.text;
                            _venueRequestModel.name = venueName.text;
                            APIService.doPostInsert(
                              context: context,
                              data: _venueRequestModel.toJson(),
                              path: "/admin/save-venue",
                            ).then((value) => {
                              if (value == 201 && mounted)
                                {
                                  _polyPoints = [],
                                  _markers = [],
                                  context.pop()
                                }
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(),
                        child: const Text(
                          "Submit",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FlutterMap(
          options: MapOptions(
            initialCenter: const LatLng(19.107579, 72.837509),
            initialZoom: 17,
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
                  onTap: () => launchUrl(Uri.parse(
                      'https://openstreetmap.org/copyright')),
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
                    FloatingActionButton(
                      onPressed: _clearSelectedPoints,
                      tooltip: 'Clear Selected Points',
                      child: const Text("Clear"),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: () async {
                        _polyPoints.add(_polyPoints[0]);
                        _venueRequestModel.coordinates = _polyPoints;
                        await showDataAlert(context);
                      },
                      child: const Text("Save"),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
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
                const BoxConstraints(maxWidth: 450, maxHeight: 49.4),
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
    return Center(
      child: Container(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: controller,
                googleAPIKey: Constants.apiKey,
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
              ),
            ),
          ],
        ),
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

  void _clearSelectedPoints() {
    setState(() {
      _markers.clear();
      _polyPoints.clear();
    });
  }
}

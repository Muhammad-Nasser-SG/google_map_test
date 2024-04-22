import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap_test/location_model.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<LocationModel> searchedList = [];
  Future<void> fetchData(String text) async {
    searchedList = [];
    var response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&types=geocode&key=AIzaSyCN5X4ZkTy2VeqLot5k-moydtSH1u2ZggM'));
    if (response.statusCode == 200) {
      jsonDecode(response.body)['predictions'].forEach((element) {
        searchedList.add(LocationModel.fromJson(element));
      });
      setState(() {});
    } else {
      throw Exception('Failed to load album');
    }
  }

  PlaceDetails? chosenPlace;
  Future<void> fetchPlaceDetails(String id) async {
    searchedList = [];
    var response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&key=AIzaSyCN5X4ZkTy2VeqLot5k-moydtSH1u2ZggM'));
    if (response.statusCode == 200) {
      chosenPlace = PlaceDetails.fromJson(jsonDecode(response.body));
      initialMarkerPosition = LatLng(
        chosenPlace!.result.geometry.location.lat,
        chosenPlace!.result.geometry.location.lng,
      );
      setState(() {});
      _onMapTapped(initialMarkerPosition);
    } else {
      throw Exception('Failed to load album');
    }
  }

  Stream<Position>? myPosition;

  Future<void> checkGeoLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    print("permission name: ${permission.name}");
  }

  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(30.033333, 31.233334),
    zoom: 17,
  );
  LatLng initialMarkerPosition = const LatLng(30.033333, 31.233334);

  late GoogleMapController googleMapController;

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  void _onMapTapped(LatLng latLng) {
    setState(() {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: latLng, zoom: 18),
        ),
      );

      initialMarkerPosition = latLng;
    });
    print('Map tapped: $latLng');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkGeoLocationPermission().then((value) async {
      var g = await Geolocator.getCurrentPosition();
      myPosition = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.best,
            timeLimit: Duration(seconds: 1),
            distanceFilter: 0),
      );
      myPosition?.listen((event) {
        setState(() {
          initialMarkerPosition = LatLng(event.latitude, event.longitude);
        });
      });
      _onMapTapped(LatLng(g.latitude, g.longitude));
    });
  }

  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: StreamBuilder<Position>(
        stream: myPosition,
        initialData: Position(
          longitude: initialMarkerPosition.longitude,
          latitude: initialMarkerPosition.latitude,
          timestamp: DateTime.now(),
          accuracy: 1,
          altitude: 1,
          altitudeAccuracy: 1,
          heading: 1,
          headingAccuracy: 1,
          speed: 1,
          speedAccuracy: 1,
        ),
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: initialCameraPosition,
                onTap: _onMapTapped,
                onMapCreated: _onMapCreated,
                buildingsEnabled: false,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                myLocationEnabled: true,
                trafficEnabled: true,
                markers: {
                  Marker(
                    markerId: const MarkerId("1"),
                    position: initialMarkerPosition,
                  ),
                },
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    SearchBar(
                        controller: searchController,
                        onSubmitted: (value) {
                          fetchData(value);
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    ...List.generate(
                      searchedList.length > 5 ? 5 : searchedList.length,
                      (index) => InkWell(
                        onTap: () {
                          fetchPlaceDetails(searchedList[index].placeId);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10),
                          width: double.maxFinite,
                          padding: const EdgeInsets.all(10),
                          color: Colors.white,
                          child: Text(searchedList[index].description ?? ''),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

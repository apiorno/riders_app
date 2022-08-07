import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:riders_app/globals.dart';
import 'package:riders_app/helpers/repository_helper.dart';
import 'package:riders_app/helpers/request_helper.dart';
import 'package:riders_app/home/search_places_screen.dart';
import 'package:riders_app/info_handler/app_info.dart';
import 'package:riders_app/widgets/my_drawer.dart';
import 'package:riders_app/widgets/progress_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _completerController = Completer();
  GoogleMapController? newGoogleMapController;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  double searchContainerHeight = 220;

  Position? userCurrentPosition;
  var geolocator = Geolocator();

  LocationPermission? _locationPermission;

  double bottomPaddingOfMap = 0;

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polylines = {};

  Set<Marker> markers = {};
  Set<Circle> circles = {};

  void checkIfPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  void locateUserPosition() async {
    userCurrentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);
    var cameraPosition = CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    final readableAddress =
        await RepositoryHelper.searchAddressForGeographicCoordinates(
            userCurrentPosition!, context);
  }

  @override
  void initState() {
    super.initState();
    checkIfPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: MyDrawer(
        email: currentRider!.email,
        name: currentRider!.name,
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            initialCameraPosition: _kGooglePlex,
            polylines: polylines,
            markers: markers,
            circles: circles,
            onMapCreated: (controller) {
              _completerController.complete(controller);
              newGoogleMapController = controller;
              _setGoogleMapDarkMode();
              setState(() {
                bottomPaddingOfMap = 240;
              });
              locateUserPosition();
            },
          ),
          Positioned(
            top: 36,
            left: 22,
            child: GestureDetector(
              onTap: () => sKey.currentState!.openDrawer(),
              child: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.menu,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: AnimatedSize(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 120),
                child: Container(
                  height: searchContainerHeight,
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 18),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.add_location_alt_outlined,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'From',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                Text(
                                  Provider.of<AppInfo>(context)
                                          .userPickUpLocation
                                          ?.locationName ??
                                      'Your current location',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final isSuccessfulResult = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SearchPlacesScreen()));
                            if (isSuccessfulResult) {
                              await _drawPolylineFromOriginToDestination();
                            }
                          },
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add_location_alt_outlined,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'To',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  Text(
                                    Provider.of<AppInfo>(context)
                                            .userPickUpLocation
                                            ?.locationName ??
                                        'Dropoff Location',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 14),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color.fromARGB(255, 226, 220, 220),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                          child: const Text(
                            'Request a ridde',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Future<void> _drawPolylineFromOriginToDestination() async {
    final appInfo = Provider.of<AppInfo>(context, listen: false);
    final originPosition = LatLng(appInfo.userPickUpLocation!.locationLatitude!,
        appInfo.userPickUpLocation!.locationLongitude!);
    final destinationPosition = LatLng(
        appInfo.userDropOffAddress!.locationLatitude!,
        appInfo.userDropOffAddress!.locationLongitude!);

    showDialog(
        context: context,
        builder: (context) => const ProgressDialog(
              message: 'Please wait!',
            ));
    final directionDetailsInfo =
        await RepositoryHelper.obtainOriginToDestinationDirectionDetails(
            originPosition, destinationPosition);
    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPpointsResult =
        pPoints.decodePolyline(directionDetailsInfo.ePoints!);
    polylineCoordinates = decodedPpointsResult
        .map((PointLatLng pointLatLng) =>
            LatLng(pointLatLng.latitude, pointLatLng.longitude))
        .toList();

    setState(() {
      final polyline = Polyline(
          polylineId: const PolylineId('Poly'),
          color: Colors.purpleAccent,
          jointType: JointType.round,
          points: polylineCoordinates,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true);
      polylines.add(polyline);
    });
    LatLngBounds bounds;
    if (originPosition.latitude > destinationPosition.latitude &&
        originPosition.longitude > destinationPosition.longitude) {
      bounds = LatLngBounds(
          southwest: destinationPosition, northeast: originPosition);
    } else if (originPosition.latitude > destinationPosition.latitude) {
      bounds = LatLngBounds(
          southwest:
              LatLng(originPosition.latitude, destinationPosition.longitude),
          northeast:
              LatLng(destinationPosition.latitude, originPosition.longitude));
    } else if (originPosition.longitude > destinationPosition.longitude) {
      bounds = LatLngBounds(
          southwest:
              LatLng(destinationPosition.latitude, originPosition.longitude),
          northeast:
              LatLng(originPosition.latitude, destinationPosition.longitude));
    } else {
      bounds = LatLngBounds(
          southwest: originPosition, northeast: destinationPosition);
    }
    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(bounds, 65));
    final originMarker = Marker(
        markerId: const MarkerId('originID'),
        infoWindow: InfoWindow(
            title: appInfo.userPickUpLocation!.locationName, snippet: 'Origin'),
        position: destinationPosition,
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow));
    final destiantionMarker = Marker(
        markerId: const MarkerId('destinationID'),
        infoWindow: InfoWindow(
            title: appInfo.userDropOffAddress!.locationName,
            snippet: 'Destination'),
        position: destinationPosition,
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange));

    final originCircle = Circle(
        circleId: const CircleId('originID'),
        fillColor: Colors.green,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
        center: originPosition);

    final destinationCircle = Circle(
        circleId: const CircleId('destinationID'),
        fillColor: Colors.red,
        radius: 12,
        strokeWidth: 3,
        strokeColor: Colors.white,
        center: destinationPosition);

    setState(() {
      markers.add(originMarker);
      markers.add(destiantionMarker);
      circles.add(originCircle);
      circles.add(destinationCircle);
    });
  }

  Future<void> _setGoogleMapDarkMode() {
    return newGoogleMapController!.setMapStyle('''
                  [
                    {
                      "elementType": "geometry",
                      "stylers": [
                        {
                          "color": "#242f3e"
                        }
                      ]
                    },
                    {
                      "elementType": "labels.text.fill",
                      "stylers": [
                        {
                          "color": "#746855"
                        }
                      ]
                    },
                    {
                      "elementType": "labels.text.stroke",
                      "stylers": [
                        {
                          "color": "#242f3e"
                        }
                      ]
                    },
                    {
                      "featureType": "administrative.locality",
                      "elementType": "labels.text.fill",
                      "stylers": [
                        {
                          "color": "#d59563"
                        }
                      ]
                    },
                    {
                      "featureType": "poi",
                      "elementType": "labels.text.fill",
                      "stylers": [
                        {
                          "color": "#d59563"
                        }
                      ]
                    },
                    {
                      "featureType": "poi.park",
                      "elementType": "geometry",
                      "stylers": [
                        {
                          "color": "#263c3f"
                        }
                      ]
                    },
                    {
                      "featureType": "poi.park",
                      "elementType": "labels.text.fill",
                      "stylers": [
                        {
                          "color": "#6b9a76"
                        }
                      ]
                    },
                    {
                      "featureType": "road",
                      "elementType": "geometry",
                      "stylers": [
                        {
                          "color": "#38414e"
                        }
                      ]
                    },
                    {
                      "featureType": "road",
                      "elementType": "geometry.stroke",
                      "stylers": [
                        {
                          "color": "#212a37"
                        }
                      ]
                    },
                    {
                      "featureType": "road",
                      "elementType": "labels.text.fill",
                      "stylers": [
                        {
                          "color": "#9ca5b3"
                        }
                      ]
                    },
                    {
                      "featureType": "road.highway",
                      "elementType": "geometry",
                      "stylers": [
                        {
                          "color": "#746855"
                        }
                      ]
                    },
                    {
                      "featureType": "road.highway",
                      "elementType": "geometry.stroke",
                      "stylers": [
                        {
                          "color": "#1f2835"
                        }
                      ]
                    },
                    {
                      "featureType": "road.highway",
                      "elementType": "labels.text.fill",
                      "stylers": [
                        {
                          "color": "#f3d19c"
                        }
                      ]
                    },
                    {
                      "featureType": "transit",
                      "elementType": "geometry",
                      "stylers": [
                        {
                          "color": "#2f3948"
                        }
                      ]
                    },
                    {
                      "featureType": "transit.station",
                      "elementType": "labels.text.fill",
                      "stylers": [
                        {
                          "color": "#d59563"
                        }
                      ]
                    },
                    {
                      "featureType": "water",
                      "elementType": "geometry",
                      "stylers": [
                        {
                          "color": "#17263c"
                        }
                      ]
                    },
                    {
                      "featureType": "water",
                      "elementType": "labels.text.fill",
                      "stylers": [
                        {
                          "color": "#515c6d"
                        }
                      ]
                    },
                    {
                      "featureType": "water",
                      "elementType": "labels.text.stroke",
                      "stylers": [
                        {
                          "color": "#17263c"
                        }
                      ]
                    }
                  ]
              ''');
  }
}

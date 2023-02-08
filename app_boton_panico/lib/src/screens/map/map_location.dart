import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_boton_panico/src/components/photo.dart';
import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/methods/permissions.dart';
import 'package:app_boton_panico/src/models/person.dart';
import 'package:app_boton_panico/src/models/user.dart';
import 'package:app_boton_panico/src/providers/socket_provider.dart';
import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:app_boton_panico/src/utils/app_layout.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:math' show cos, sqrt, asin;

class LocationMap extends StatefulWidget {
  const LocationMap({Key key, this.person}) : super(key: key);
  final Person person;
  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  User user;
  IO.Socket socket;
  Position _currentPosition;
  Map<MarkerId, Marker> _markers;
  Completer<GoogleMapController> _controllerMap = Completer();
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Marker sourcePosition, destinantionPosition;
  List<LatLng> polylineCoordinates = [];
  //LatLng destination = LatLng(0.3368, -78.1237);
/*   static CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 15.0); */

  @override
  void initState() {
    super.initState();
    _markers = <MarkerId, Marker>{};
    _markers.clear();
    addMarkers();
    _getCurrentPosition();
    //getPolyPoints();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// _getCurrentPosition() is a function that gets the current position of the user and sets the state of
  /// the current position to the position of the user
  ///
  /// Returns:
  ///   A Future<void>
  Future<void> _getCurrentPosition() async {
    final hasPermission = await Permissions.handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  /// I'm trying to get the location of the user and update the map with the new location
  ///
  /// Args:
  ///   context: The context of the widget.
  ///   user (User): The user who is currently logged in.
  void initSocket(context, User user) async {
    try {
      final socketProvider =
          Provider.of<SocketProvider>(context, listen: false);
      socketProvider.connect(user);

      socketProvider.onLocation(
        widget.person.id,
        (data) async {
          //var dataRecive = jsonDecode(data);
          //log(data);
          log(widget.person.id);
          Map latlng = data["position"];
          final GoogleMapController controller = await _controllerMap.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(latlng["lat"], latlng["lng"]),
                zoom: 16,
              ),
            ),
          );
          var image = await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(),
            "assets/image/alarm.png",
          );
          destinantionPosition = Marker(
            markerId: MarkerId("destination"),
            //icon: image,
            position: LatLng(
              latlng["lat"],
              latlng["lng"],
            ),
          );
          if (mounted) {
            setState(() {
              _markers[MarkerId("destination")] = destinantionPosition;
            });
          }
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void addMarkers() {
    sourcePosition = Marker(
      markerId: MarkerId("source"),
      position: LatLng(0.326190, 0.326190),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );
    _markers[MarkerId("source")] = sourcePosition;
  }

  /// It takes a destination as a parameter, then it uses the PolylinePoints class to get the route
  /// between the current location and the destination, then it adds the route to the polylineCoordinates
  /// list
  ///
  /// Args:
  ///   destination (LatLng): LatLng

  void getPolyPoints(LatLng destination) async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        Environments.apiGoogle,
        PointLatLng(0.326190, -78.174692),
        PointLatLng(destination.latitude, destination.longitude),
      );
      polylineCoordinates.clear();
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          setState(() {
            polylineCoordinates.add(LatLng(point.latitude, point.longitude));
          });
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).userData["user"];
    initSocket(context, user);
    final Size size = AppLayout.getSize(context);
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.person.firstName)),
      extendBody: true,
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: const CameraPosition(
              target: LatLng(-1.273798, -78.645353),
              zoom: 10,
            ),
            mapType: MapType.normal,
            polylines: {
              Polyline(
                  polylineId: PolylineId("route"),
                  points: polylineCoordinates,
                  color: Colors.blue,
                  width: 6),
            },
            onMapCreated: (GoogleMapController controller) {
              _controllerMap.complete(controller);
            },
            markers: Set<Marker>.of(_markers.values),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                direction: Axis.vertical,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromARGB(139, 255, 255, 255)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Distancia",
                                  style: Styles.textStyleBotttomTitle,
                                ),
                                Text("2KM"),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Tiempo",
                                  style: Styles.textStyleBotttomTitle,
                                ),
                                Text("1H"),
                              ],
                            ),
                          ]),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(26.0),
          topRight: Radius.circular(26.0),
        ),
        child: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: UIComponents.photo(size, widget.person),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Recibiendo ubicación en tiempo real",
                    style: Styles.textStyleBotttomTitle,
                  ),
                  Text("${widget.person.firstName} ${widget.person.lastName}"),
                  Text(
                    "Estado: En peligro",
                    style: Styles.textState,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

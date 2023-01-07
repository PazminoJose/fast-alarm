import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class LocationMap extends StatefulWidget {
  const LocationMap({Key key}) : super(key: key);

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  IO.Socket socket;
  Map<MarkerId, Marker> _markers;
  Completer<GoogleMapController> _controllerMap = Completer();

  static const CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(0.8148998285180321, -77.7182745106789), zoom: 15.0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _markers = <MarkerId, Marker>{};
    _markers.clear();
    initSocket();
  }

  Future<void> initSocket() async {
    try {
      socket = IO.io("http://${Environments.url}/", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });
      log(socket.io.uri);
      socket.connect();
      socket.on(
        "position-change",
        (data) => ((data) async {
          var latlng = jsonDecode(data);
          final GoogleMapController controller = await _controllerMap.future;
          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(latlng["lat"], latlng["lng"]),
                zoom: 18,
              ),
            ),
          );
          var image = await BitmapDescriptor.fromAssetImage(
            ImageConfiguration(),
            "assets/image/alarm.png",
          );
          Marker marker = Marker(
            markerId: MarkerId("ID"),
            icon: image,
            position: LatLng(
              latlng["lat"],
              latlng["lng"],
            ),
          );
          setState(() {
            _markers[MarkerId("ID")] = marker;
          });
        }),
      );
    } catch (e) {
      log(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: _initialCameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {
          _controllerMap.complete(controller);
        },
        markers: Set<Marker>.of(_markers.values),
      ),
    );
  }
}

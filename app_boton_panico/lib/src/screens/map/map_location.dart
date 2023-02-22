import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:app_boton_panico/src/components/photo.dart';
import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/methods/permissions.dart';
import 'package:app_boton_panico/src/models/person.dart';
import 'package:app_boton_panico/src/models/user.dart';
import 'package:app_boton_panico/src/providers/socket_provider.dart';
import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:app_boton_panico/src/services/user_services.dart';
import 'package:app_boton_panico/src/utils/app_layout.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:custom_marker/marker_icon.dart';
import 'package:location/location.dart' as LC;

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
  int count = 0;
  LC.Location location = LC.Location();
  StreamSubscription<LC.LocationData> locationSubscription;
  BitmapDescriptor imagenMarker;

  //LatLng destination = LatLng(0.3368, -78.1237);
/*   static CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude), zoom: 15.0); */

  @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).userData["user"];
    _markers = <MarkerId, Marker>{};
    _markers.clear();
    startListeningPosition();
  }

  @override
  void dispose() {
    super.dispose();
    cancelSendLocation();
  }

  void startListeningPosition() async {
    bool hasPermisions = await Permissions.handleLocationPermission(context);
    if (!hasPermisions) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Conceda los permisos para ver su ubicación')));
      }
    } else {
      BitmapDescriptor imgSource = await getImagesMap(user.person.urlImage);
      location.changeNotificationOptions(
          channelName: "channel",
          subtitle: "Se esta obteniendo tu ubicación.",
          description: "desc",
          title: "Vivo Vivo está accediendo a su ubicación",
          color: Colors.green);
      locationSubscription =
          location.onLocationChanged.listen((LC.LocationData position) {
        changeSourcePosition(position, imgSource);
      });
    }
  }

  void cancelSendLocation() async {
    await locationSubscription.cancel();
    location.enableBackgroundMode(enable: false);
  }

  void changeSourcePosition(
      LC.LocationData position, BitmapDescriptor imgSource) {
    sourcePosition = Marker(
      markerId: MarkerId("source"),
      icon: imgSource,
      position: LatLng(
        position.latitude,
        position.longitude,
      ),
    );

    if (mounted) {
      setState(() {
        _markers[const MarkerId("source")] = sourcePosition;
      });
    }
  }

  void changeDestinationPosition(
      Map latlng, BitmapDescriptor imgDestination) async {
    if (count <= 0) {
      final GoogleMapController controller = await _controllerMap.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(latlng["lat"], latlng["lng"]),
            zoom: 15,
          ),
        ),
      );
      if (mounted) {
        setState(() {
          count++;
        });
      }
    }

    destinantionPosition = Marker(
      markerId: MarkerId("destination"),
      icon: imgDestination,
      position: LatLng(
        latlng["lat"],
        latlng["lng"],
      ),
    );
    if (mounted) {
      setState(() {
        _markers[const MarkerId("destination")] = destinantionPosition;
      });
    }
  }

  void initSocket(context, User user) async {
    try {
      final socketProvider =
          Provider.of<SocketProvider>(context, listen: false);
      socketProvider.connect(user.person.id);
      BitmapDescriptor imgDestination =
          await getImagesMap(widget.person.urlImage);
      socketProvider.onLocation(
        widget.person.id,
        (data) async {
          Map latlng = data["position"];
          changeDestinationPosition(latlng, imgDestination);
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<BitmapDescriptor> getImagesMap(urlImage) async {
    try {
      BitmapDescriptor imgMarker = await MarkerIcon.downloadResizePictureCircle(
          "https://${Environments.getImage}/$urlImage");
      return imgMarker;
    } catch (e) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
    }
  }

  /// It takes a destination as a parameter, then it uses the PolylinePoints class to get the route
  /// between the current location and the destination, then it adds the route to the polylineCoordinates
  /// list
  ///
  /// Args:
  ///   destination (LatLng): LatLng

  void getPolyPoints(LatLng destination) async {
    await dotenv.load(fileName: ".env");

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        dotenv.env['API_KEY_GOOGLE'],
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
            onMapCreated: (GoogleMapController controller) {
              _controllerMap.complete(controller);
            },
            markers: Set<Marker>.of(_markers.values),
          ),
          /*         Row(
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
   */
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

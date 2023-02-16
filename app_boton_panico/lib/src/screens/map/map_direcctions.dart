
import 'package:app_boton_panico/src/methods/permissions.dart';
import 'package:app_boton_panico/src/models/person.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

typedef OnDirecctionSelected = Function(LatLng direcctionSelected);

class SearchPlaces extends StatefulWidget {
  const SearchPlaces({
    Key key,
  }) : super(key: key);
  @override
  State<SearchPlaces> createState() => _SearchPlacesState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlacesState extends State<SearchPlaces> {
  LatLng direction;
  Set<Marker> markersList = {};
  Position _currentPosition;
  GoogleMapController googleMapController;
  static const CameraPosition _initialCameraPosition = CameraPosition(
      target: LatLng(0.8148998285180321, -77.7182745106789), zoom: 15.0);
  final Mode _mode = Mode.overlay;
  Person personArguments;
  String _currentAddress;

  @override
  Widget build(BuildContext context) {
    personArguments = ModalRoute.of(context).settings.arguments as Person;

    return Scaffold(
      extendBodyBehindAppBar: true,
      key: homeScaffoldKey,
      appBar: AppBar(
        backgroundColor: Styles.tranparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon:const  Icon(
            Icons.chevron_left_rounded,
            color: Colors.black,
            size: 40,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Styles.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Ubique su domicilio",
              style: Styles.textStyleBody.copyWith(color: Styles.black),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GoogleMap(
              zoomControlsEnabled: true,
              initialCameraPosition: _initialCameraPosition,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: markersList,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                googleMapController = controller;
              },
              onTap: (argument) {
                print(argument.latitude);
                displayPredictionOnTap(argument, homeScaffoldKey.currentState);
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  heroTag: "btn1",
                  onPressed: _handlePressButton,
                  label: const Text("Buscar dirección"),
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
          ),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: (() async {
              await _getAddressFromLatLng(direction);
              personArguments.address = _currentAddress;
              Navigator.of(context).pushReplacementNamed("/secondRegisterPage",
                  arguments: personArguments);
            }),
            backgroundColor: Colors.green,
            child: const Icon(Icons.check_rounded),
          ),
        ],
      ),
    );
  }

  /// _getAddressFromLatLng() takes a LatLng object as an argument, and returns a Future<void> that calls
  /// the placemarkFromCoordinates() function from the geolocator package, which takes a latitude and
  /// longitude as arguments, and returns a Future<List<Placemark>> that calls the then() function, which
  /// takes a List<Placemark> as an argument, and returns a Future<void> that sets the _currentAddress
  /// variable to a string that contains the street name and number of the address that corresponds to the
  /// latitude and longitude that was passed to the placemarkFromCoordinates() function
  ///
  /// Args:
  ///   position (LatLng): The current position of the user.
  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      await placemarkFromCoordinates(position.latitude, position.longitude)
          .then((List<Placemark> placemarks) {
        _currentAddress = '${placemarks[1].street}, ${placemarks[2].street}';
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      print(e);
    }
  }

  /// _getCurrentPosition() is a function that gets the current position of the user and returns it as a
  /// Position object
  ///
  /// Returns:
  ///   A Future<void>
  Future<void> _getCurrentPosition() async {
    final hasPermission = await Permissions.handleLocationPermission(context);
    if (!hasPermission) return;
    _currentPosition = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high)
        .then((Position position) => position)
        .catchError((e) {
      print(e);
    });
  }

  Future<void> _handlePressButton() async {
    await dotenv.load(fileName: ".env");

    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: dotenv.env['API_KEY_GOOGLE'],
        onError: onError,
        mode: _mode,
        language: 'en',
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: 'Search',
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white))),
        components: [
          Component(Component.country, "ec"),
          Component(Component.country, "ecu")
        ]);

    displayPrediction(p, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage,
        contentType: ContentType.failure,
      ),
    ));

    // homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  /// It takes a Prediction object and a ScaffoldState object as parameters, then it uses the Prediction
  /// object to get the latitude and longitude of the place, then it adds a marker to the map and animates
  /// the camera to the marker
  ///
  /// Args:
  ///   p (Prediction): Prediction
  ///   currentState (ScaffoldState): The current state of the scaffold.
  Future<void> displayPrediction(
      Prediction p, ScaffoldState currentState) async {
    await dotenv.load(fileName: ".env");

    if (p != null) {
      GoogleMapsPlaces places = GoogleMapsPlaces(
          apiKey: dotenv.env['API_KEY_GOOGLE'],
          apiHeaders: await const GoogleApiHeaders().getHeaders());

      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(p.placeId);

      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      setState(() {
        print(lat);
        markersList.clear();
        markersList.add(Marker(
          markerId: const MarkerId("0"),
          position: LatLng(lat, lng),
        ));
        direction = LatLng(lat, lng);
      });

      googleMapController
          .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
    }
  }

  /// It takes a LatLng object and a ScaffoldState object as parameters, and then it displays a marker on
  /// the map at the location of the LatLng object
  ///
  /// Args:
  ///   latLng (LatLng): The latitude and longitude of the location you want to display on the map.
  ///   currentState (ScaffoldState): The current state of the scaffold.

  Future<void> displayPredictionOnTap(
      LatLng latLng, ScaffoldState currentState) async {
    if (latLng != null) {
      final lat = latLng.latitude;
      final lng = latLng.longitude;

      setState(() {
        markersList.clear();
        markersList.add(Marker(
          markerId: const MarkerId("0"),
          position: LatLng(lat, lng),
        ));
        direction = LatLng(lat, lng);
      });

      googleMapController
          .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 18.0));
    }
  }
}

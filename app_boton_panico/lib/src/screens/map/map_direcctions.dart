import 'dart:developer';

import 'package:app_boton_panico/src/models/person.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
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

const kGoogleApiKey = 'AIzaSyCfK3Fp-ScPOOhLGtTki7nejALoQXZs96o';
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          icon: Icon(
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
                  label: Text("Buscar dirección"),
                  icon: Icon(Icons.search),
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
            child: Icon(Icons.check_rounded),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    try {
      await placemarkFromCoordinates(position.latitude, position.longitude)
          .then((List<Placemark> placemarks) {
        _currentAddress = '${placemarks[1].street}, ${placemarks[2].street}';
      }).catchError((e) {
        print(e);
      });
    } catch (e) {
      log(e);
    }
  }

  Future<bool> _handleLocationPermission(context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Los servicos de localización estan deshabilitados, Por favor habilite lo servicios')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Permisos de loxalización han sido denegados.')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Los permisos de localización están permanentemente denegados, no podemos solicitar permisos.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _currentPosition = position;
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> _handlePressButton() async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
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

  Future<void> displayPrediction(
      Prediction p, ScaffoldState currentState) async {
    if (p != null) {
      GoogleMapsPlaces places = GoogleMapsPlaces(
          apiKey: kGoogleApiKey,
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

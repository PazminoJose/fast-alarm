import 'package:app_boton_panico/src/models/user_alert.dart';
import 'package:app_boton_panico/src/screens/alerts/components/card_alert.dart';
import 'package:app_boton_panico/src/services/alerts_services.dart';
import 'package:flutter/material.dart';

import '../../utils/app_styles.dart';

/// It's a StatelessWidget that receives a list of UserAlerts and displays them in a ListView.builder
class Alerts extends StatefulWidget {
  const Alerts({Key key, this.personId}) : super(key: key);
  final String personId;

  @override
  State<Alerts> createState() => _AlertsState();
}

class _AlertsState extends State<Alerts> {
  AlertsServices serviceAlert = AlertsServices();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
            leading: Container(),
            centerTitle: true,
            title: const Text('Alertas Recibidas')),
        body: SafeArea(
            bottom: false,
            child: FutureBuilder<List<UserAlert>>(
                future: serviceAlert.getUsersAlertsByPerson(widget.personId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data.isNotEmpty
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              final user = snapshot.data[index];
                              return CardAlert(
                                userAlert: user,
                              );
                            },
                          )
                        : const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                "No esta agregado en ningun circulo de confianza",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Styles.primaryColor,
                      ),
                    );
                  }
                })),
      ),
    );
  }
}

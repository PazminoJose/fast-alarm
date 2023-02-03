import 'package:app_boton_panico/src/models/alarm.dart';
import 'package:app_boton_panico/src/models/person.dart';
import 'package:app_boton_panico/src/models/user_alert.dart';
import 'package:app_boton_panico/src/screens/alerts/components/card_alert.dart';
import 'package:flutter/material.dart';
import 'package:app_boton_panico/src/services/notification_services.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// It's a StatelessWidget that receives a list of UserAlerts and displays them in a ListView.builder
class Alerts extends StatelessWidget {
  Alerts({Key key, this.usersAlerts}) : super(key: key);
  final List<UserAlert> usersAlerts;
  final df = DateFormat('dd/MM/yyyy hh:mm');

  @override
  Widget build(BuildContext context) {
    var serviceNotification = NotificationServices();

    return Material(
      child: Scaffold(
        appBar: AppBar(
            leading: Container(),
            centerTitle: true,
            title: Text('Alertas Recibidas')),
        body: SafeArea(
            bottom: false,
            child: ListView.builder(
              itemCount: usersAlerts.length,
              itemBuilder: (context, index) {
                final user = usersAlerts[index];
                return CardAlert(
                  userAlert: user,
                );
              },
            )),
      ),
    );
  }
}

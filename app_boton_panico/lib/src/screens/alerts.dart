import 'package:app_boton_panico/src/models/entities.dart';
import 'package:flutter/material.dart';
import 'package:app_boton_panico/src/services/notification_services.dart';
import 'package:intl/intl.dart';

class Alerts extends StatelessWidget {
  Alerts({Key key, this.user}) : super(key: key);
  final String user;
  final df = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    var serviceNotification = NotificationServices();

    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Alertas")),
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Center(
              child: FutureBuilder<List<Alert>>(
                future: serviceNotification.getAlertsByUser(user),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        //TODO:Direccion de la alerta
                        return ListTile(
                          title: Text(snapshot.data[index].message),
                          trailing: Text(snapshot.data[index].state),
                          subtitle:
                              Text(df.format(snapshot.data[index].createdAt)),
                        );
                      },
                    );
                  } else {
                    //TODO:Comprobar cuadno lista este vacia
                    return Text("No existen alertas enviadas");
                  }
                },
              ),
            ),
          ],
        ));
  }
}

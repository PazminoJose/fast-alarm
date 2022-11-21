import 'package:app_boton_panico/src/models/entities.dart';
import 'package:flutter/material.dart';
import 'package:app_boton_panico/src/services/notification_services.dart';
import 'package:intl/intl.dart';

class Alerts extends StatelessWidget {
  Alerts({Key key, this.user}) : super(key: key);
  final String user;
  final df = DateFormat('dd/MM/yyyy hh:mm');

  @override
  Widget build(BuildContext context) {
    var serviceNotification = NotificationServices();

    return Container(
      decoration: const BoxDecoration(
          color: Color.fromRGBO(56, 56, 76, 1),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        children: [
          AppBar(
            backgroundColor: Colors.red,
            automaticallyImplyLeading: false,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            title: const Center(
              child: Text("Alertas Enviadas"),
            ),
          ),
          Center(
            child: FutureBuilder<List<Alert>>(
              future: serviceNotification.getAlertsByUser(user),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            //TODO:Direccion de la alerta
                            return Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Card(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                child: ListTile(
                                  //textColor: Colors.white,
                                  title: Text(snapshot.data[index].message),
                                  subtitle: Text(
                                      "Fecha: ${df.format(snapshot.data[index].createdAt)}"),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              "No existen alertas enviadas",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        height: 20,
                      ),
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

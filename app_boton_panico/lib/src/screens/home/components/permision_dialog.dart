import 'package:app_boton_panico/src/methods/permissions.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_styles.dart';

class PermisionLocation extends StatelessWidget {
  PermisionLocation({Key key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Uso de su Ubicación"),
                    const Image(image: AssetImage("assets/image/location.png")),
                    const Text(
                        'Al presionar "SOS" esta aplicación recoge datos de tu ubicación para informar a tu grupo de confianza que estas en peligro y brinde apoyo en donde sea que te encuentres. Incluso cuando la app este cerrada o no este en uso mientras estés en emergencia.'),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Styles.secondaryColor),
                            onPressed: (() {
                              Navigator.of(context).pop();
                            }),
                            child: const Text("Cancelar"),
                          ),
                          ElevatedButton(
                            child: const Text("Aceptar"),
                            onPressed: () => _requestPermisions(context),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _requestPermisions(BuildContext context) {
    Permissions.handleLocationPermission(context);
    Navigator.of(context).pop();
  }
}

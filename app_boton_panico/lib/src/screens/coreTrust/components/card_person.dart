import 'package:app_boton_panico/src/components/photo.dart';
import 'package:app_boton_panico/src/utils/app_layout.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';
import '../../../models/user.dart';

/// Is a card component with view alerts for user
class CardPerson extends StatelessWidget {
  const CardPerson({Key key, this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    final Size size = AppLayout.getSize(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
      ),
      child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 3,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [UIComponents.photo(size, user.person)],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${user.person.firstName} ${user.person.lastName}",
                            style: Styles.textStyleTitle.copyWith(fontSize: 15),
                          ),
                          Text(
                            "Telefono: ${user.person.phone}",
                            style: Styles.textLabel,
                          ),
                          Text("Cedula: ${user.person.idCard}"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

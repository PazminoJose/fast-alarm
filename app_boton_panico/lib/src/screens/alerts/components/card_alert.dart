import 'package:app_boton_panico/src/models/person.dart';
import 'package:app_boton_panico/src/models/user_alert.dart';
import 'package:app_boton_panico/src/screens/map/map_location.dart';
import 'package:app_boton_panico/src/utils/app_layout.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class CardAlert extends StatelessWidget {
  const CardAlert({Key key, this.userAlert}) : super(key: key);
  final UserAlert userAlert;

  @override
  Widget build(BuildContext context) {
    final Size size = AppLayout.getSize(context);
    String state = (userAlert.state == "danger") ? "En peligro" : "Seguro";
    Color colorState =
        (userAlert.state == "danger") ? Styles.redText : Styles.green;

    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
      ),
      child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Colors.greenAccent,
            ),
            borderRadius: BorderRadius.circular(20.0), //<-- SEE HERE
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
                      children: [photo(size, userAlert.user.person)],
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "${userAlert.user.person.firstName} ${userAlert.user.person.lastName}"),
                          Text(
                            "Estado: $state",
                            style: Styles.textState.copyWith(color: colorState),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        (userAlert.state == "danger")
                            ? RippleAnimation(
                                repeat: true,
                                color: colorState,
                                minRadius: 40,
                                ripplesCount: 2,
                                child: ClipOval(
                                  child: Container(
                                    width: size.width * 0.12,
                                    height: size.width * 0.12,
                                    color: colorState,
                                  ),
                                ),
                              )
                            : ClipOval(
                                child: Container(
                                  width: size.width * 0.12,
                                  height: size.width * 0.12,
                                  color: colorState,
                                ),
                              ),
                      ],
                    )
                  ],
                ),
                Divider(
                  height: 2,
                  color: Styles.gray,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LocationMap(
                                      person: userAlert.user.person,
                                    )));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Seguir Ubicación",
                            style: Styles.textButtonTrackLocation,
                          ),
                          Gap(10),
                          (userAlert.state == "danger")
                              ? RotatedBox(
                                  //turns: AlwaysStoppedAnimation(45 / 360),
                                  quarterTurns: 1,
                                  child: Icon(
                                    Icons.navigation_rounded,
                                    color: colorState,
                                  ),
                                )
                              : null
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}

Widget photo(Size size, Person person) => Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
      child: ClipOval(
        child: CachedNetworkImage(
          width: size.width * 0.2,
          height: size.width * 0.2,
          fit: BoxFit.cover,
          imageUrl:
              "https://wl-genial.cf.tsp.li/resize/728x/jpg/f6e/ef6/b5b68253409b796f61f6ecd1f1.jpg",
          errorWidget: (context, url, error) => Icon(Icons.error_outline),
          placeholder: (context, url) => CircularProgressIndicator(),
        ),
      ),
    );

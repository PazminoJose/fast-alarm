import 'package:app_boton_panico/src/screens/coreTrust/components/card_person.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/family_group_services.dart';

/// It's a StatelessWidget that receives a list of UserAlerts and displays them in a ListView.builder
class FamilyGroup extends StatefulWidget {
  const FamilyGroup({Key key, this.userId}) : super(key: key);
  final String userId;

  @override
  State<FamilyGroup> createState() => _FamilyGroupState();
}

class _FamilyGroupState extends State<FamilyGroup> {
 FamilyGroupServices familyGroupServices = FamilyGroupServices();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
            leading: Container(),
            centerTitle: true,
            title: const Text('Núcleo de Confianza')),
        body: SafeArea(
            bottom: false,
            child: FutureBuilder<List<User>>(
                future: familyGroupServices.getfamilyGropuByUser(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data.isNotEmpty
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              final user = snapshot.data[index];
                              return CardPerson(
                                user: user,
                              );
                            },
                          )
                        : const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                "No tiene agregado ningun ncleo de confianza",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                  } else {
                    return  Center(
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

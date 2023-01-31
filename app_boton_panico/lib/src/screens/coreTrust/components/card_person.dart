import 'package:app_boton_panico/src/models/person.dart';
import 'package:flutter/material.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({Key key, this.person}) : super(key: key);
  final Person person;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(child: Column(),),
    );
  }
}

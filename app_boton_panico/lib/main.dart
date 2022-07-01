import 'package:app_boton_panico/screens/my_home_page.dart';
import 'package:app_boton_panico/screens/second_page.dart';
import 'package:flutter/material.dart';

//id=ee435e81-1546-40fe-9cd7-af3cbf1f5688
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      //home: MyHomePage()
      initialRoute: "/",
      routes: {
        "/": (BuildContext context) => MyHomePage(),
        "/second": (BuildContext context) => SecondPage()
      },
    );
  }
}

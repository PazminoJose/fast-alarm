import 'package:app_boton_panico/screens/my_home_page.dart';
import 'package:app_boton_panico/screens/login_page.dart';
import 'package:app_boton_panico/screens/second_page.dart';
import 'package:flutter/material.dart';

//id=ee435e81-1546-40fe-9cd7-af3cbf1f5688
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      //home: MyHomePage()
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: const Color.fromRGBO(56, 56, 76, 1),
          secondary: Colors.blueGrey[800],
        ),
      ),
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        // ignore: missing_return
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (settings.name) {
            case "/":
              return loguin_page();
              break;
            case "/homePage":
              // ignore: prefer_const_constructors
              return MyHomePage();
              break;
            default:
              loguin_page();
          }
        });
      },
    );
  }
}

import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:app_boton_panico/src/screens/login_page.dart';
import 'package:app_boton_panico/src/screens/my_home_page.dart';
import 'package:app_boton_panico/src/screens/register_page.dart';
import 'package:app_boton_panico/src/screens/rememberPass_page.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//id=ee435e81-1546-40fe-9cd7-af3cbf1f5688
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        //home: MyHomePage()
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
              primary: Styles.primaryColor, secondary: Styles.secondaryColor),
        ),
        initialRoute: "/",
        onGenerateRoute: (RouteSettings settings) {
          // ignore: missing_return
          return MaterialPageRoute(builder: (BuildContext context) {
            switch (settings.name) {
              case "/":
                return LoginPage();
                break;
              case "/homePage":
                // ignore: prefer_const_constructors
                return MyHomePage();
                break;
              case "/register":
                // ignore: prefer_const_constructors
                return RegisterPage();
                break;
              case "/rememberPassword":
                return RememberPassPage();
                break;
              default:
                LoginPage();
            }
          });
        },
      ),
    );
  }
}

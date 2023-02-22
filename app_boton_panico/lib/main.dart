import 'package:app_boton_panico/src/providers/socket_provider.dart';
import 'package:app_boton_panico/src/providers/user_provider.dart';
import 'package:app_boton_panico/src/screens/login/login_page.dart';
import 'package:app_boton_panico/src/screens/map/map_direcctions.dart';
import 'package:app_boton_panico/src/screens/home/my_home_page.dart';
import 'package:app_boton_panico/src/screens/map/map_location.dart';
import 'package:app_boton_panico/src/screens/register/register_page.dart';
import 'package:app_boton_panico/src/screens/register/second_register_page.dart';
import 'package:app_boton_panico/src/screens/rememberPass_page.dart';
import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

/// `runApp` is a function that takes a widget and displays it on the screen
void main() {
  runApp(
    Phoenix(
      child: const MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    final ThemeData theme = ThemeData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider(create: (_) => SocketProvider())
      ],
      child: MaterialApp(
        /* localizationsDelegates: <LocalizationsDelegate<Object>>[
          globa
        ], */
        //supportedLocales: const [Locale("es", "EC")],
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
          return MaterialPageRoute(
              // ignore: missing_return
              builder: (BuildContext context) {
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
                  case "/secondRegisterPage":
                    return const SecondRegisterPage();
                    break;
                  case "/rememberPassword":
                    return const RememberPassPage();
                    break;
                  case "/mapMarker":
                    return const SearchPlaces();
                    break;
                  case "/mapLocation":
                    return const LocationMap();
                    break;
                  default:
                    LoginPage();
                }
              },
              settings: settings);
        },
      ),
    );
  }
}

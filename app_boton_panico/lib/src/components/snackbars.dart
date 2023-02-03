import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

/// A class that contains all the snackbars that I use in my app.
class MySnackBars {
  /// failure

  /// It returns a SnackBar widget.
  /// 
  /// Args:
  ///   message (String): The message you want to display
  ///   title (String): The title of the snackbar
  static failureSnackBar(String message, String title) => SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: ContentType.failure,
          isDesktop: false,
          xlarge: false,
        ),
      );

  /// help
  /// A static variable that is a SnackBar widget.
  static var helpSnackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Hi There!',
      message:
          'You need to use this package in the app to uplift your Snackbar Experinece!',
      contentType: ContentType.help,
      isDesktop: false,
      xlarge: false,
    ),
  );

  /// success
  /// A static variable that is a SnackBar widget.
  static var successSnackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Enviado!',
      message:
          'Se envio alerta a todos los dispositivos.\nPor favor espere por ayuda!',
      contentType: ContentType.success,
      isDesktop: false,
      xlarge: false,
    ),
  );


  /// It returns a SnackBar widget.
  /// 
  /// Args:
  ///   message (String): The message you want to display.
  ///   title (String): The title of the snackbar.
  static successSaveSnackBar(String message, String title) => SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: ContentType.success,
          isDesktop: false,
          xlarge: false,
        ),
      );

  /// warning
  /// A static variable that is a SnackBar widget.
  static var warningSnackBar = SnackBar(
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Warning!',
      message: 'You Have a warning for this message.\nPlease read carefully!',
      contentType: ContentType.warning,
      isDesktop: false,
      xlarge: false,
    ),
  );

 /// It returns a SnackBar widget.
 /// 
 /// Args:
 ///   message (String): The message you want to display in the snackbar.
 ///   icon (IconData): The icon you want to display on the left side of the snackbar.
 ///   color (Color): The background color of the snackbar.
  static simpleSnackbar(String message, IconData icon, Color color) => SnackBar(
        elevation: 15,
        /* shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))), */
        backgroundColor: color,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(message),
            ),
          ],
        ),
      );
}

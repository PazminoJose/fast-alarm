import 'package:app_boton_panico/src/global/enviroment.dart';
import 'package:app_boton_panico/src/models/person.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UIComponents {
  /// It returns a widget that displays a photo of a person.
  /// 
  /// Args:
  ///   size (Size): Size of the screen
  ///   person (Person): The person object that contains the data for the person.
  static Widget photo(Size size, Person person) => Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
        child: ClipOval(
          child: CachedNetworkImage(
            width: size.width * 0.2,
            height: size.width * 0.2,
            fit: BoxFit.cover,
            imageUrl:
                "http://${Environments.getImage}/${person.urlImage}",
            errorWidget: (context, url, error) => const Icon(Icons.error_outline),
            placeholder: (context, url) => const CircularProgressIndicator(),
          ),
        ),
      );
}

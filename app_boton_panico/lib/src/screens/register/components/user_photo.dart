import 'dart:io';

import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../components/snackbars.dart';

typedef OnImageSelected = Function(XFile imageFile);

class UserPhoto extends StatelessWidget {
  final XFile imageFile;
  final OnImageSelected onImageSelected;
  const UserPhoto({@required this.imageFile, @required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const SizedBox(width: 200, height: 130),
        Positioned(
            top: 0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(backgroundColor: Styles.primaryColor, radius: 65),
                CircleAvatar(
                    backgroundColor: Styles.primaryColor,
                    backgroundImage: imageFile != null
                        ? FileImage(File(imageFile.path))
                        : const AssetImage("assets/image/user.png"),
                    radius: 62)
              ],
            )),
        Positioned(
            top: 50,
            left: 150,
            child: InkWell(
              onTap: () {
                showMaterialModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20))),
                    builder: (context) {
                      return Material(
                          child: SafeArea(
                        top: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: const Text('Cámara'),
                              leading: const Icon(Icons.camera_alt_outlined),
                              onTap: () {
                                _pickImage(context, ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: const Text('Galería'),
                              leading: const Icon(Icons.image),
                              onTap: () {
                                _pickImage(context, ImageSource.gallery);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ));
                    });
              },
              child: Chip(
                  backgroundColor: Styles.secondaryColor,
                  label: Icon(
                    Icons.edit,
                    color: Styles.white,
                  )),
            ))
      ],
    );
  }

  Future _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final image = await picker.pickImage(source: source, imageQuality: 25);
      if (image == null) return;
      onImageSelected(image);
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(MySnackBars.simpleSnackbar(
          "No se obtuvo, la imagen intente de nuevo", Icons.dangerous, Styles.red));
      print("Failed to pick image $e");
      return;
    }
  }
}

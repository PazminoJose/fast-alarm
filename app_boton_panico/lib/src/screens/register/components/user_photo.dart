import 'dart:io';

import 'package:app_boton_panico/src/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class UserPhoto extends StatefulWidget {
  const UserPhoto({Key key}) : super(key: key);

  @override
  State<UserPhoto> createState() => _UserPhotoState();
}

class _UserPhotoState extends State<UserPhoto> {
  File image;

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
                    backgroundImage: image != null
                        ? FileImage(image)
                        : const AssetImage("assets/image/person.png"),
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
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                              title: Text('Cámara'),
                              leading: Icon(Icons.camera_alt_outlined),
                              onTap: () {
                                _pickImage(context, ImageSource.camera);
                                Navigator.of(context).pop();
                              },
                            ),
                            ListTile(
                              title: Text('Galeria'),
                              leading: Icon(Icons.image),
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
      print(source.toString());
      final ImagePicker _picker = ImagePicker();
      switch (source.toString()) {
        case "ImageSource.camera":
          final image = await _picker.pickImage(source: source);
          if (image == null) return;
          final imagTemp = File(image.path);
          setState(() {
            this.image = imagTemp;
          });
          break;
        case "ImageSource.gallery":
          final image = await _picker.pickImage(source: source);
          if (image == null) return;
          final imagTemp = File(image.path);
          setState(() {
            this.image = imagTemp;
          });
          break;
        default:
      }
    } on PlatformException catch (e) {
      print("Failed to pick image $e");
    }
  }
}

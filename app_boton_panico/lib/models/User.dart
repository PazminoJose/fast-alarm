import 'dart:ffi';

import 'package:data_classes/data_classes.dart';

@GenerateDataClass(generateCopyWith: true)
class MutableNotificacion {}

@GenerateDataClass(generateCopyWith: true)
class MutableBranch {
  String name;
  String address;
  String contact;
  Int latitude;
  Int longitude;
}

@GenerateDataClass(generateCopyWith: true)
class MutableUser {
  String id;
  String idSucursal;
  String email;
  String password;
  String user_type;
  MutableBranch branch;
}

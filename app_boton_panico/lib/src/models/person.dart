import 'dart:convert';

Person personFromJson(String str) => Person.fromJson(json.decode(str));

String personToJson(Person data) => json.encode(data.toJson());
String personToJsonWithId(Person data) => json.encode(data.toJsonWithId());

class Person {
  Person({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.idCard,
    this.phone,
    this.birthDate,
    this.address,
    this.gender,
    this.urlImage,
    this.ethnic,
    this.disability,
    this.maritalStatus,
  });

  String id;
  String firstName;
  String middleName;
  String lastName;
  String idCard;
  String phone;
  DateTime birthDate;
  String address;
  String gender;
  dynamic urlImage;
  String ethnic;
  bool disability;
  String maritalStatus;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["_id"].toString(),
        firstName: json["firstName"],
        middleName: json["middleName"],
        lastName: json["lastName"],
        idCard: json["idCard"],
        phone: json["phone"],
        birthDate: DateTime.parse(json["birthDate"]),
        address: json["address"],
        gender: json["gender"],
        urlImage: json["urlImage"],
        ethnic: json["ethnic"],
        disability: json["disability"],
        maritalStatus: json["maritalStatus"],
      );

  Map<String, dynamic> toJson() => {
        //"_id": id,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "idCard": idCard,
        "phone": phone,
        "birthDate": birthDate.toIso8601String(),
        "address": address,
        "gender": gender,
        //"urlImage": urlImage,
        "ethnic": ethnic,
        "disability": disability,
        "maritalStatus": maritalStatus,
      };

  Map<String, dynamic> toJsonWithId() => {
        "_id": id,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "idCard": idCard,
        "phone": phone,
        "birthDate": birthDate.toIso8601String(),
        "address": address,
        "gender": gender,
        "urlImage": urlImage,
        "ethnic": ethnic,
        "disability": disability,
        "maritalStatus": maritalStatus,
      };
}

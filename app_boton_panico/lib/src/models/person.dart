import 'dart:convert';

Person personFromJson(String str) => Person.fromJson(json.decode(str));

String personToJson(Person data) => json.encode(data.toJson());

class Person {
  Person({
    this.id,
    this.firstName,
    this.middleName,
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
  String idCard;
  String phone;
  DateTime birthDate;
  String address;
  String gender;
  String urlImage;
  String ethnic;
  bool disability;
  String maritalStatus;

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["_id"].toString(),
        firstName: json["firstName"],
        middleName: json["middleName"],
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
        "firstName": firstName,
        "middleName": middleName,
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

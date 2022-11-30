// ignore_for_file: file_names, camel_case_types, must_be_immutable, prefer_typing_uninitialized_variables, prefer_collection_literals

import 'package:crm_mobile/employee/models/person/employeeModel.dart';

class Manager {
  late final id;
  late final email;
  late final phone;
  late final password;
  late final fullname;
  late final roleId;
  late final image;
  late final gender;
  late final dob;
  late final createDate;
  late final updateDate;
  late final updateByID;
  late final status;
  late final fcmToken;
  late final updateBy;
  late Role role;
  Manager(
      {this.id,
      this.email,
      this.phone,
      this.password,
      this.fullname,
      this.roleId,
      this.image,
      this.createDate,
      this.updateDate,
      this.updateBy,
      this.dob,
      this.status,
      this.fcmToken,
      this.gender,
      required this.role,
      this.updateByID});
  Manager.fromJson(Map<dynamic, dynamic> json) {
    id = json["id"];
    fullname = json["fullname"];
    email = json["email"];
    phone = json["phone"];
    status = json["status"];
    roleId = json["roleId"];
    gender = json["gender"];
    image = json["image"];
    dob = json["dob"];
  }
}

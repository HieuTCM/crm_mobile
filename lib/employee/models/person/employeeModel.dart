// ignore_for_file: file_names, camel_case_types, must_be_immutable, prefer_typing_uninitialized_variables, prefer_collection_literals
class Role {
  late final id;
  late final name;
  Role({this.id, this.name});
}

class Employee {
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
  Employee(
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
}

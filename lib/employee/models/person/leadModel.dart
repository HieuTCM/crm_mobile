// ignore_for_file: file_names, camel_case_types, must_be_immutable, prefer_typing_uninitialized_variables, prefer_collection_literals

import 'package:crm_mobile/employee/models/person/employeeModel.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';

class Lead {
  late final totalRow;
  late final id;
  late final accountId;
  late final fullname;
  late final nameCall;
  late final gender;
  late final dob;
  late final phone;
  late final email;
  late final leadType;
  late final website;
  late final companyName;
  late final createDate;
  late final lastActivityDate;
  late final lastActivityType;
  late final lifeCycleStage;
  late final leadStatus;
  late final employeeId;
  late UserObj account;
  late Employee employee;

  Lead(
      {this.id,
      this.accountId,
      this.fullname,
      this.nameCall,
      this.gender,
      this.dob,
      this.phone,
      this.email,
      this.leadType,
      this.createDate,
      this.lastActivityDate,
      this.lastActivityType,
      this.website,
      this.leadStatus,
      this.lifeCycleStage,
      this.employeeId,
      this.companyName,
      this.totalRow,
      required this.account,
      required this.employee});
  Lead.fromJson(Map<String, dynamic> json, int totalRow) {
    id = json['id'];
    accountId = json['accountId'];
    fullname = json['fullname'];
    nameCall = json['nameCall'];
    gender = json['gender'];
    dob = json['dob'];
    phone = json['phone'];
    email = json['email'];
    leadType = json['leadType'];
    website = json['website'];
    companyName = json['companyName'];
    createDate = json['createDate'];
    lastActivityDate = json['lastActivityDate'];
    lastActivityType = json['lastActivityType'];
    lifeCycleStage = json['lifeCycleStage'];
    leadStatus = json['leadStatus'];
    employeeId = json['employeeId'];
    totalRow = totalRow;
  }
}

class LeadStatus {
  late final id;
  late final name;

  LeadStatus({this.id, this.name});

  LeadStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

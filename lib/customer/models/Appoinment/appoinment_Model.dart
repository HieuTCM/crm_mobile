// ignore_for_file: file_names, camel_case_types, must_be_immutable, prefer_typing_uninitialized_variables, prefer_collection_literals

import 'package:crm_mobile/customer/models/feedback/feedback_model.dart';
import 'package:crm_mobile/customer/models/person/employeeModel.dart';
import 'package:crm_mobile/customer/models/person/leadModel.dart';
import 'package:crm_mobile/customer/models/person/productOwner.dart';
import 'package:crm_mobile/customer/models/product/product_model.dart';

class Appointment {
  late final id;
  late final name;
  late final employeeId;
  late final leadId;
  late final productId;
  late final fullname;
  late final phone;
  late final email;
  late final activityType;
  late final appointmentStatus;
  late final description;
  late final createDate;
  late final startDate;
  late final startTime;
  late final endDate;
  late final abortReason;
  late final abortDate;
  late final acceptedDate;
  late final totalRow;
  late final isFeedback;
  late Employee employee;
  late Lead lead;
  late Product product;
  late Owner proOwner;
  late Feedbackmodel feedback;

  Appointment(
      {this.id,
      this.name,
      this.employeeId,
      this.leadId,
      this.productId,
      this.fullname,
      this.phone,
      this.email,
      this.activityType,
      this.appointmentStatus,
      this.description,
      this.createDate,
      this.abortDate,
      this.startDate,
      this.startTime,
      this.endDate,
      this.abortReason,
      this.acceptedDate,
      this.totalRow,
      this.isFeedback,
      required this.employee,
      required this.lead,
      required this.product,
      required this.proOwner,
      required this.feedback});
}

class RequestAppointment {
  late final name;
  late final productId;
  late final fullname;
  late final phone;
  late final email;
  late final activityType;
  late final description;
  late final startDate;
  late final startTime;
  RequestAppointment({
    this.name,
    this.productId,
    this.fullname,
    this.phone,
    this.email,
    this.activityType,
    this.description,
    this.startDate,
    this.startTime,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = name;
    data['productId'] = productId;
    data['fullname'] = fullname;
    data['phone'] = phone;
    data['email'] = email;
    data['activityType'] = activityType;
    data['description'] = description;
    data['startDate'] = startDate;
    data['startTime'] = startTime;

    return data;
  }
}

class ActivityType {
  late final id;
  late final name;
  ActivityType({this.id, this.name});
}

class AppointmentStatus {
  late final id;
  late final name;
  AppointmentStatus({this.id, this.name});

  AppointmentStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }
}

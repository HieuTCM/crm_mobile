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
  late Employee employee;
  late Lead lead;
  late Product product;
  late Owner proOwner;

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
      required this.employee,
      required this.lead,
      required this.product,
      required this.proOwner});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = this.name;
    data['productId'] = this.productId;
    data['fullname'] = this.fullname;
    data['phone'] = this.phone;
    data['activityType'] = this.activityType;
    data['description'] = this.description;
    data['startDate'] = this.startDate;
    data['startTime'] = this.startTime;

    return data;
  }
}

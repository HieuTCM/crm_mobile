import 'package:crm_mobile/customer/models/person/employeeModel.dart';
import 'package:crm_mobile/customer/models/person/userModel.dart';

class Lead {
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
      required this.account,
      required this.employee});
}

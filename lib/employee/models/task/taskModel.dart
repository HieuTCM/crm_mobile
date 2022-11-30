import 'package:crm_mobile/employee/models/person/employeeModel.dart';
import 'package:crm_mobile/employee/models/person/managerModel.dart';

class TaskDetail {
  late final leadId;
  late final leadStatus;
  TaskDetail({this.leadId, this.leadStatus});
}

class Task {
  late final id;
  late final name;
  late final createDate;
  late final employeeId;
  late final createrId;
  late final isDone;

  late List<TaskDetail> taskDetails;
  late Manager creater;
  late Employee employee;
  late final totalRow;

  Task({
    this.id,
    this.name,
    this.createDate,
    this.employeeId,
    this.createrId,
    this.isDone,
    required this.taskDetails,
    required this.creater,
    required this.employee,
    this.totalRow,
  });
}

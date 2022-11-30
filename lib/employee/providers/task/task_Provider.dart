import 'package:crm_mobile/employee/models/person/employeeModel.dart';
import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/person/managerModel.dart';
import 'package:crm_mobile/employee/models/task/taskModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class TaskProvider {
  static String token = getTokenAuthenFromSharedPrefs();

  // static const String _mainURL = 'https://dtv-crm.azurewebsites.net';
  static const String _mainURL = 'https://backup-dtv-crm.azurewebsites.net';
  //Header
  static final Map<String, String> _header = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Accept-Charset': 'UTF-8',
    "Authorization": 'Bearer $token'
  };

  /*-------------------------------------------------------------*/
  //path URL
  static const String _getTask = '/api/v1/Task/task?';
  static const String _updTaskAsDone = '/api/v1/Task/task/mask-task-as-done';

  /*-------------------------------------------------------------*/
  //Fetch_API
  static Future<String> updTaskAsDone(String id) async {
    String status = '';
    var body = json.encode(id);
    try {
      final res = await http.put(Uri.parse(_mainURL + _updTaskAsDone),
          headers: _header, body: body);
      if (res.statusCode == 200) {
        status = 'Successful';
      } else if (res.statusCode == 400) {
        status = 'Your task is almost unfinished';
      } else {
        status = 'failed';
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return status;
  }

  static Future<List<Task>> fetchTask(Map<String, String> param) async {
    List<Task> listTask = [];
    String queryString = Uri(queryParameters: param).query;
    Role role = Role();

    Employee emp = Employee(role: role);
    Manager mger = Manager(role: role);
    try {
      final res = await http.get(Uri.parse(_mainURL + _getTask + queryString),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var dataTask = jsondata['data'];
          var totalRow = jsondata['totalRow'];
          for (var data in dataTask) {
            List<TaskDetail> listTaskDetails = [];
            var taskDetailsData = data['taskDetails'];
            var managerData = data['creater'];
            var empData = data['employee'];
            for (var taskDetail in taskDetailsData) {
              TaskDetail taskDetails = TaskDetail(
                  leadId: taskDetail['leadId'],
                  leadStatus: taskDetail['leadStatus']);
              listTaskDetails.add(taskDetails);
            }
            if (managerData is Map) {
              mger = Manager.fromJson(managerData);
            }
            if (empData is Map) {
              emp = Employee.fromJson(empData);
            }
            Task task = Task(
                id: data['id'],
                name: data['name'],
                employeeId: data['employeeId'],
                createrId: data['createrId'],
                createDate: data['createDate'],
                isDone: data['isDone'],
                taskDetails: listTaskDetails,
                creater: mger,
                employee: emp,
                totalRow: totalRow);
            listTask.add(task);
          }
        }
      } else {
        List<TaskDetail> listTaskDetails = [];
        Task task = Task(
            creater: mger,
            employee: emp,
            taskDetails: listTaskDetails,
            id: 'NotFound');
        listTask.add(task);
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return listTask;
  }
}

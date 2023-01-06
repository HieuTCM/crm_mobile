import 'package:crm_mobile/employee/models/notification/notification.dart';
import 'package:crm_mobile/employee/models/person/employeeModel.dart';
import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/person/managerModel.dart';
import 'package:crm_mobile/employee/models/task/taskModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class NotificationProvider {
  static String token = getTokenAuthenFromSharedPrefs();

  // static const String _mainURL = 'https://dtv-crm.azurewebsites.net';
  static const String _mainURL = 'https://backup-dtv-crm.azurewebsites.net';
  //Header
  static final Map<String, String> _header = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': '*/*',
    'Accept-Charset': 'UTF-8',
    "Authorization": 'Bearer $token'
  };

  /*-------------------------------------------------------------*/
  //path URL
  static const String _getNotification = '/api/v1/Notification/notification';

  /*-------------------------------------------------------------*/
  //Fetch_API
  static Future<List<Notification>> fetchTask(Map<String, String> param) async {
    List<Notification> listNoti = [];
    String queryString = Uri(queryParameters: param).query;

    try {
      final res = await http.get(
          Uri.parse(_mainURL + _getNotification + queryString),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var datanoti = jsondata['data'];
          var totalRow = jsondata['totalRow'];
          for (var data in datanoti) {
            Notification noti = Notification.fromJson(data);
            noti.totalRow = totalRow;
            listNoti.add(noti);
          }
        }
      } else {
        List<Notification> listnoti = [];
        Notification noti = Notification(id: 'NotFound');
        listnoti.add(noti);
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return listNoti;
  }
}

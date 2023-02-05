import 'package:crm_mobile/employee/models/kpi/kpiModel.dart';
import 'package:crm_mobile/employee/models/person/employeeModel.dart';
import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/person/managerModel.dart';
import 'package:crm_mobile/employee/models/task/taskModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class KPIProvider {
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
  static const String _getKPIPeriod = '/v1/api/Enum/kpi-period';
  static const String _getKPI = '/api/v1/KPI/kpi/my-kpi/';

  /*-------------------------------------------------------------*/
  //Fetch_API

  static Future<List<kpiPeriod>> fetchkpiPeriod() async {
    List<kpiPeriod> listperiod = [];
    try {
      final res =
          await http.get(Uri.parse(_mainURL + _getKPIPeriod), headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var totalRow = jsondata['totalRow'];
          var perioddata = jsondata['data'];
          for (var data in perioddata) {
            kpiPeriod period = kpiPeriod.fromJson(data);
            listperiod.add(period);
          }
        }
      } else {
        kpiPeriod period = kpiPeriod();
        listperiod.add(period);
        return listperiod;
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return listperiod;
  }

  static Future<kpi> fetchkpi(String id) async {
    kpi KPI = kpi();
    try {
      final res =
          await http.get(Uri.parse(_mainURL + _getKPI + id), headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var totalRow = jsondata['totalRow'];
          var kpiddata = jsondata['data'];
          if (kpiddata is Map) {
            KPI = kpi.fromJson(kpiddata);
          }
        }
      } else {
        kpi KPI = kpi();
        return KPI;
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return KPI;
  }
}

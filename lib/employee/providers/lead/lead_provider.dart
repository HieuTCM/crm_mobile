import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/person/employeeModel.dart';
import 'package:crm_mobile/employee/models/person/leadModel.dart';
import 'package:crm_mobile/employee/models/person/productOwner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class LeadProvider {
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
  static const String _getLeadByID = '/api/v1/Lead/lead/';
  static const String _getListLeadStatus = '/v1/api/Enum/customer-status';
  static const String _updLeadStatus = '/api/v1/Lead/lead/update-status';

  /*-------------------------------------------------------------*/
  //Fetch_API
  static Future<Lead> fetchLeadByID(String id) async {
    UserObj user = UserObj();
    Role role = Role();
    Employee emp = Employee(role: role);
    Lead lead = Lead(account: user, employee: emp);
    try {
      final res = await http.get(Uri.parse(_mainURL + _getLeadByID + id),
          headers: _header);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        var dataLead = jsondata['data'];
        for (var data in dataLead) {
          lead = Lead.fromJson(data);
        }
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return lead;
  }

  static Future<List<LeadStatus>> fetchListLeadStatus() async {
    List<LeadStatus> listStatus = [];
    try {
      final res = await http.get(Uri.parse(_mainURL + _getListLeadStatus),
          headers: _header);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        for (var data in jsondata) {
          LeadStatus leadStatus = LeadStatus.fromJson(data);
          listStatus.add(leadStatus);
        }
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return listStatus;
  }

  static Future<String> updLeadstatus(Map<String, dynamic> data) async {
    String status = '';

    var body = json.encode(data);
    try {
      final res = await http.put(Uri.parse(_mainURL + _updLeadStatus),
          headers: _header, body: body);
      if (res.statusCode == 200) {
        status = 'successful';
      } else {
        status = 'failed';
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return status;
  }
}

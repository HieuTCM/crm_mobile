import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/person/employeeModel.dart';
import 'package:crm_mobile/employee/models/person/leadModel.dart';
import 'package:crm_mobile/employee/models/person/productOwner.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  static const String _getLead = '/api/v1/Lead/lead?';
  static const String _getListLeadStatus = '/v1/api/Enum/customer-status';
  static const String _updLeadStatus = '/api/v1/Lead/lead/update-status';
  static const String _getAllLeadEnum = '/v1/api/Enum/all-lead';

  /*-------------------------------------------------------------*/
  //Fetch_API
  static Future<List<LeadEnum>> fetchAllLeadEnum() async {
    List<LeadEnum> listlead = [];
    try {
      final res = await http.get(Uri.parse(_mainURL + _getAllLeadEnum),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var dataLead = jsondata['data'];
          for (var data in dataLead) {
            LeadEnum lead = LeadEnum.fromJson(data);
            listlead.add(lead);
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Can't get Lead Enum",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return listlead;
  }

  static Future<List<Lead>> fetchLead(Map<String, String> param) async {
    UserObj user = UserObj();
    Role role = Role();
    Employee emp = Employee(role: role);
    List<Lead> listLead = [];
    Lead lead = Lead(account: user, employee: emp);
    String queryString = Uri(queryParameters: param).query;
    try {
      final res = await http.get(Uri.parse(_mainURL + _getLead + queryString),
          headers: _header);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        var dataLead = jsondata['data'];
        var totalRow = jsondata['totalRow'];
        for (var data in dataLead) {
          data['totalRow'] = totalRow;
          lead = Lead.fromJson(data);
          listLead.add(lead);
        }
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return listLead;
  }

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
          data['totalRow'] = 1;
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

// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, unused_field, unused_local_variable, prefer_typing_uninitialized_variables

import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/opportunity/opportunityModel.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class OpportunityProviders {
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
  static const String _getOpportunity = '/api/v1/Opportunity/opportunity?';
  static const String _getOpportunitybyID = '/api/v1/Opportunity/opportunity/';
  static const String _insOpportunity = '/api/v1/Opportunity/opportunity/add';
  static const String _updOpportunity =
      '/api/v1/Opportunity/opportunity/update';
  static const String _getOpportunityStatus = '/v1/api/Enum/oppoturnity-status';
  static const String _updOpportunityStatus =
      '/api/v1/Opportunity/opportunity/update-status';
  static const String _getLostReason = '/v1/api/Enum/lost-reason';

  /*-------------------------------------------------------------*/
  //Fetch_API

  static Future<String> updOpportunityStatus(String id, int value) async {
    String status = '';
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['status'] = value;
    var body = json.encode(data);
    try {
      final res = await http.put(
          Uri.parse('$_mainURL' + '$_updOpportunityStatus'),
          headers: _header,
          body: body);
      if (res.statusCode == 200) {
        status = "Successful";
        Fluttertoast.showToast(
            msg: "Update Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        status = "Failed";
        Fluttertoast.showToast(
            msg: "Update Failed",
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

    return status;
  }

  static Future<String> insOpportunity(Opportunity opportunity) async {
    String status = '';
    var data = opportunity.toJson();
    var body = json.encode(data);
    try {
      final res = await http.post(Uri.parse(_mainURL + _insOpportunity),
          headers: _header, body: body);
      if (res.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Insert Opportunity Successfull",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Can't Insert Opportunity",
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
    return status;
  }

  static Future<List<OpportunityStatus>> fetchListOpportunityStatus() async {
    List<OpportunityStatus> listStatus = [];
    try {
      final res = await http.get(Uri.parse(_mainURL + _getOpportunityStatus),
          headers: _header);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        for (var data in jsondata) {
          OpportunityStatus OppStatus = OpportunityStatus.fromJson(data);
          listStatus.add(OppStatus);
        }
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return listStatus;
  }

  static Future<List<LostReason>> fetchListLostReason() async {
    List<LostReason> listLostReason = [];
    try {
      final res = await http.get(Uri.parse(_mainURL + _getLostReason),
          headers: _header);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        for (var data in jsondata) {
          LostReason lostReason = LostReason.fromJson(data);
          listLostReason.add(lostReason);
        }
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return listLostReason;
  }

  static Future<String> updOpportunity(
      String id, Map<String, dynamic> value) async {
    String status = '';
    var body = json.encode(value);
    try {
      final res = await http.put(Uri.parse('$_mainURL' + '$_updOpportunity'),
          headers: _header, body: body);
      if (res.statusCode == 200) {
        status = "Successful";
        Fluttertoast.showToast(
            msg: "Update Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        status = "Failed";
        Fluttertoast.showToast(
            msg: "Update Failed",
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

    return status;
  }

  static Future<List<Opportunity>> fetchAllOpportunity(
      Map<String, String> param) async {
    String queryString = Uri(queryParameters: param).query;
    List<Opportunity> listOpportunity = [];
    try {
      final res = await http.get(
          Uri.parse(_mainURL + _getOpportunity + queryString),
          headers: _header);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        var totalRow = jsondata['totalRow'];
        var apppointmentData = jsondata['data'];
        for (var data in apppointmentData) {
          data['totalRow'] = totalRow;
          Opportunity opp = Opportunity.fromJson(data);
          listOpportunity.add(opp);
        }
      } else {
        Opportunity opp = Opportunity(totalRow: 1);
        listOpportunity.add(opp);
        // Fluttertoast.showToast(
        //     msg: "Can't get opportunity",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return listOpportunity;
  }

  static Future<Opportunity> fetchOpportunitybyID(String id) async {
    Opportunity opp = Opportunity(totalRow: 1);
    try {
      final res = await http.get(Uri.parse(_mainURL + _getOpportunitybyID + id),
          headers: _header);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        var totalRow = jsondata['totalRow'];
        var apppointmentData = jsondata['data'];
        for (var data in apppointmentData) {
          data['totalRow'] = totalRow;
          opp = Opportunity.fromJson(data);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Can't get NoFavorite",
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
    return opp;
  }
}

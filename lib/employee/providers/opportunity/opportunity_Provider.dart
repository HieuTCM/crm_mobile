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

  /*-------------------------------------------------------------*/
  //Fetch_API

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
        Fluttertoast.showToast(
            msg: "Error ${res.statusCode.toString()} can't get NoFavorite",
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
    return listOpportunity;
  }
}

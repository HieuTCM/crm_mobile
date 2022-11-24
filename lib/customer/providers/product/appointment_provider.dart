// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, unused_field, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unused_local_variable

import 'package:crm_mobile/customer/helpers/shared_prefs.dart';
import 'package:crm_mobile/customer/models/Appoinment/appoinment_Model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class appointmentProvider {
  static String token = getTokenAuthenFromSharedPrefs();

  static const String _mainURL = 'https://dtv-crm.azurewebsites.net';

  //Header
  static final Map<String, String> _header = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Accept-Charset': 'UTF-8',
    "Authorization": 'Bearer $token'
  };

  /*-------------------------------------------------------------*/
  //path URL

  //Activity Type
  static const String _getActivityType = '/v1/api/Enum/activity-type';

  //Appointment
  static const String _insApponitmemt =
      '/api/v1/Appointment/appointment/add-by-customer';

  //fetch API

  static Future<List<ActivityType>> fetchAllActivityTypes() async {
    List<ActivityType> listActivityTypes = [];
    try {
      final res = await http.get(Uri.parse('$_mainURL' + '$_getActivityType'),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          for (var data in jsondata) {
            ActivityType activityType =
                ActivityType(id: data['id'], name: data['name']);
            listActivityTypes.add(activityType);
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Error ${res.statusCode.toString()}",
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

    return listActivityTypes;
  }

  static Future<String> insAppointment(
      RequestAppointment requestAppointment) async {
    String value = '';
    try {
      var data = requestAppointment.toJson();
      var body = json.encode(data);

      final res = await http.post(Uri.parse('$_mainURL' + '$_insApponitmemt'),
          headers: _header, body: body);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var appointData = jsondata['data'];
          value = 'Send request successful ';
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Error ${res.statusCode.toString()}",
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

    return value;
  }
}

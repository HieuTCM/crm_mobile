// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, unused_field, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unused_local_variable

import 'package:crm_mobile/customer/helpers/shared_prefs.dart';
import 'package:crm_mobile/customer/models/feedback/feedback_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class feedbackProvider {
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

  //Feedback
  static const String _insFeedback = '/api/v1/Feedback/feedback/add';
  static const String _getFeedbackbyAppointmentID =
      '/api/v1/Feedback/feedback/appointment/';

  //fetch API
  static Future<String> insFeedback(Map<String, dynamic> mapfeedback) async {
    String status = '';
    var body = json.encode(mapfeedback);
    try {
      final res = await http.post(Uri.parse('$_mainURL' + '$_insFeedback'),
          headers: _header, body: body);
      if (res.statusCode == 200) {
        status = "Successful";
      } else {
        status = "Failed";
        Fluttertoast.showToast(
            msg: " Send feedback Failed",
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

  static Future<Feedbackmodel> fetchFeedbackbyAppointmentID(String id) async {
    Feedbackmodel feedback = Feedbackmodel();
    try {
      final res = await http.get(
          Uri.parse('$_mainURL' + '$_getFeedbackbyAppointmentID' + id),
          headers: _header);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        var data = jsondata['data'];
        for (var feedbackdata in data) {
          if (feedbackdata is Map) {
            feedback = Feedbackmodel(
                id: feedbackdata['id'],
                appointmentId: feedbackdata['customerId'],
                customerId: feedbackdata['appointmentId'],
                content: feedbackdata['content'],
                rate: feedbackdata['rate'],
                feedbackDate:
                    feedbackdata['feedbackDate'].toString().substring(0, 10));
          }
        }
      } else {
        Fluttertoast.showToast(
            msg: "Get feedback Failed",
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

    return feedback;
  }
}

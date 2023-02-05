// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, unused_field, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unused_local_variable

import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/feedback/feedback_model.dart';
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
  static const String _getRating = '/api/v1/Feedback/feedback/counter';
  static const String _getAllFeedback = '/api/v1/Feedback/feedback?';
  static const String _getFeedbackbyAppointmentID =
      '/api/v1/Feedback/feedback/appointment/';

  //fetch API
  static Future<List<Feedbackmodel>> fetchFeedback(
      Map<String, String> param) async {
    String queryString = Uri(queryParameters: param).query;
    // Feedbackmodel feedback = Feedbackmodel();
    List<Feedbackmodel> listFeedback = [];
    try {
      final res = await http.get(
          Uri.parse('$_mainURL' + '$_getAllFeedback' + queryString),
          headers: _header);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        var data = jsondata['data'];
        var totalRow = jsondata['totalRow'];
        for (var feedbackdata in data) {
          if (feedbackdata is Map) {
            Feedbackmodel feedback = Feedbackmodel(
                id: feedbackdata['id'],
                appointmentId: feedbackdata['appointmentId'],
                customerId: feedbackdata['customerId'],
                content: feedbackdata['content'],
                rate: feedbackdata['rate'],
                feedbackDate:
                    feedbackdata['feedbackDate'].toString().substring(0, 10),
                totalRow: totalRow);
            listFeedback.add(feedback);
          }
        }
      } else {
        Feedbackmodel feedback = Feedbackmodel(totalRow: 1);
        listFeedback.add(feedback);
        // Fluttertoast.showToast(
        //     msg: "Get feedback Failed",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     fontSize: 16.0);
        return listFeedback;
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return listFeedback;
  }

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
            msg: "Send feedback Failed",
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
        // Fluttertoast.showToast(
        //     msg: "Get feedback Failed",
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

    return feedback;
  }

  static Future<Rating> fetchRating() async {
    Rating rating = Rating();
    try {
      final res =
          await http.get(Uri.parse(_mainURL + _getRating), headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var totalRow = jsondata['totalRow'];
          var ratingdata = jsondata['data'];
          if (ratingdata is Map) {
            rating = Rating(
                rate_1: ratingdata['rate_1'],
                rate_2: ratingdata['rate_2'],
                rate_3: ratingdata['rate_3'],
                rate_4: ratingdata['rate_4'],
                rate_5: ratingdata['rate_5'],
                average: ratingdata['average']);
          }
        }
      } else {
        Rating rating = Rating();
        return rating;
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return rating;
  }
}

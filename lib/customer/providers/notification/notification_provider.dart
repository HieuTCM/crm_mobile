// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, unused_field, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unused_local_variable

import 'package:crm_mobile/customer/helpers/shared_prefs.dart';
import 'package:crm_mobile/customer/models/notification/notificationModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class notificationProvider {
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
  static const String _getAllNotification =
      '/api/v1/Notification/notification?';

  //fetch API
  static Future<List<Notifications>> fetchAllNotifications(
      Map<String, String> param) async {
    List<Notifications> listNoti = [];
    Notifications noti = Notifications();
    String queryString = Uri(queryParameters: param).query;
    try {
      final res = await http.get(
          Uri.parse(_mainURL + _getAllNotification + queryString),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var totalRow = jsondata['totalRow'];
          var notiData = jsondata['data'];
          for (var data in notiData) {
            data['totalRow'] = totalRow;
            noti = Notifications.fromJson(data);
            listNoti.add(noti);
          }
        }
      } else {
        Notifications notifi = Notifications();
        listNoti.add(notifi);
        return listNoti;
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return listNoti;
  }
}

// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, unused_field, prefer_adjacent_string_concatenation

import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class searchProvider {
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
  static const String _getListSort = '/v1/api/FilterSort/product/getSort';
  static const String _getProvince = '/v1/api/FilterSort/product/getProvince';
  static const String _getDistrict =
      '/v1/api/FilterSort/product/getDistrict?province=';

  /*-------------------------------------------------------------*/
  //Fetch_API
  static Future<List<String>> fetchAllProvince() async {
    List<String> listprovince = [];

    try {
      // ignore: unnecessary_string_interpolations
      final res = await http.get(Uri.parse('$_mainURL' + '$_getProvince'),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var datauser = jsondata['data'];
          for (var data in datauser) {
            if (data != null) {
              listprovince.add(data);
            }
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
    return listprovince;
  }

  static Future<List<String>> fetchAllDistrict(String value) async {
    List<String> listDistrict = [];

    try {
      // ignore: unnecessary_string_interpolations
      final res = await http.get(Uri.parse(_mainURL + _getDistrict + value),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var datauser = jsondata['data'];
          for (var data in datauser) {
            listDistrict.add(data);
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
    return listDistrict;
  }

  static Future<List<Sort>> fetchAllSortType() async {
    List<Sort> listSort = [];

    try {
      // ignore: unnecessary_string_interpolations
      final res =
          await http.get(Uri.parse(_mainURL + _getListSort), headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);

          for (var data in jsondata) {
            Sort sort = Sort(id: data['id'], name: data['name']);
            listSort.add(sort);
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
    return listSort;
  }
}

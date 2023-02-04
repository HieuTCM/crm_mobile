// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, unused_field, prefer_adjacent_string_concatenation

import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/product/category_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class cateProviders {
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
  static const String _getAllCategory =
      '/api/v1/ProductCategory/product-category';

  /*-------------------------------------------------------------*/
  //Fetch_API

  static Future<List<Category>> fetchAllCategory() async {
    Category cate = Category();
    List<Category> listcate = [];
    String auth = getTokenAuthenFromSharedPrefs();
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Accept-Charset': 'UTF-8',
      "Authorization": 'Bearer $auth'
    };
    try {
      // ignore: unnecessary_string_interpolations
      final res = await http.get(Uri.parse('$_mainURL' + '$_getAllCategory'),
          headers: header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var datauser = jsondata['data'];
          for (var data in datauser) {
            cate = Category(
              id: data['id'],
              name: data['productCategoryName'],
            );
            listcate.add(cate);
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Get Category Failed",
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
    return listcate;
  }
}

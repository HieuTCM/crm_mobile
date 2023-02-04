// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, unused_field, prefer_collection_literals, deprecated_member_use

import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class userProviders {
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
  static final Map<String, String> _header2 = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Accept-Charset': 'UTF-8',
  };

  /*-------------------------------------------------------------*/
  //path URL

  static const String _loginWithGoogle = '/api/v1/Authentication/system/fbase';

  //User
  static const String _updProfile =
      '/api/v1/SystemAccount/system-account/update';
  static const String _updImageProfile =
      '/api/v1/SystemAccount/system-account/update-avatar';
  static const String _getUserInformation = '/api/v1/SystemAccount/profile';
  static const String _getUserAvatar =
      '/api/v1/SystemAccount/system-account/get-avatar';

  /*-------------------------------------------------------------*/
  //Fetch_API

  //login With Google
  static Future<UserObj> fetchUserLoginWithGoogle(String value) async {
    UserObj user = UserObj();

    var body = json.encode(value);

    try {
      final res = await http.post(Uri.parse(_mainURL + _loginWithGoogle),
          headers: _header2, body: body);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var datauser = jsondata['data'];
          if (datauser == 'USER_INVALID') {
            user = UserObj(status: datauser);
          } else if (datauser == 'ACCOUNT_NOTFOUND') {
            user = UserObj(status: datauser);
          } else {
            if (datauser is Map) {
              user = UserObj(
                id: datauser['id'],
                emailAddress: datauser['email'],
                phoneNumber: datauser['phone'],
                fullName: datauser['fullName'],
                status: datauser['status'],
                role: datauser['role'],
                gender: datauser['gender'],
                authToken: datauser['token'],
              );
            }
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Login Failed",
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

    return user;
  }

  //get User information
  static Future<UserObj> fetchUserInfor() async {
    UserObj user = UserObj();
    String img = '';
    String auth = getTokenAuthenFromSharedPrefs();
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Accept-Charset': 'UTF-8',
      "Authorization": 'Bearer $auth'
    };
    try {
      final res =
          await http.get(Uri.parse(_mainURL + _getUserAvatar), headers: header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          img = jsondata;
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Get User Information Failed",
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
    try {
      final res = await http.get(Uri.parse(_mainURL + _getUserInformation),
          headers: header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var datauser = jsondata['data'];
          for (var data in datauser) {
            user = UserObj(
              id: data['id'],
              emailAddress: data['email'],
              phoneNumber: data['phone'],
              fullName: data['fullname'],
              password: data['password'],
              gender: data['gender'],
              image: img,
              role: data['role'],
              dob: data['dob'].toString().substring(0, 10),
              status: data['status'],
            );
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Get User Information Failed",
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

    return user;
  }

  static Future<String> updCustomerAccount(UserObj userValue) async {
    String status = '';
    var data = userValue.toJson();
    var body = json.encode(data);

    try {
      final res = await http.put(Uri.parse(_mainURL + _updProfile),
          headers: _header, body: body);
      if (res.statusCode == 200) {
        print(res.body);
        Fluttertoast.showToast(
            msg: "Update Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
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

  static Future<String> updImageAccount(File file) async {
    String status = '';

    try {
      var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      // get file length
      var length = await file.length();
      final request = await http.MultipartRequest(
          "PUT", Uri.parse(_mainURL + _updImageProfile));
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['accept'] = 'text/plain';
      request.headers['Content-Type'] = 'multipart/form-data';

      request.files.add(await http.MultipartFile('picture', stream, length,
          filename: basename(file.path)));
      var res = await request.send();

      print(res.statusCode);
    } on HttpException catch (e) {
      print(e.toString());
    }

    return status;
  }
}

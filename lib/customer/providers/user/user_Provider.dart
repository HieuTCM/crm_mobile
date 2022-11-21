import 'package:crm_mobile/customer/helpers/shared_prefs.dart';
import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class userProviders {
  static String token = getTokenAuthenFromSharedPrefs();

  static const String _mainURL = 'https://dtv-crm.azurewebsites.net';

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
  //login
  static const String _loginbyEmailandPassword =
      '/api/v1/Authentication/customer';
  static const String _loginWithGoogle =
      '/api/v1/Authentication/customer/fbase';

  //User
  static const String _getUserInformation = '/api/v1/CustomerAccount/profile';
  static const String _getUserAvatar =
      '/api/v1/CustomerAccount/customer-account/get-avatar';

  /*-------------------------------------------------------------*/
  //Fetch_API
  //login by email and password
  static Future<UserObj> fetchUserLogin(String email, String password) async {
    UserObj user = new UserObj();
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = email;
    data['password'] = password;
    var body = json.encode(data);
    try {
      final res = await http.post(
          Uri.parse('$_mainURL' + '$_loginbyEmailandPassword'),
          headers: _header2,
          body: body);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var datauser = jsondata['data'];
          if (datauser is Map) {
            user = UserObj(
              id: datauser['id'],
              emailAddress: datauser['email'],
              phoneNumber: datauser['phone'],
              fullName: datauser['fullName'],
              status: datauser['status'],
              role: datauser['role'],
              gender: datauser['gender'],
              password: password,
              dob: datauser['dob'],
              authToken: datauser['token'],
            );
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return user;
  }

  //login With Google
  static Future<UserObj> fetchUserLoginWithGoogle(String value) async {
    UserObj user = new UserObj();

    var body = json.encode(value);

    try {
      final res = await http.post(Uri.parse('$_mainURL' + '$_loginWithGoogle'),
          headers: _header2, body: body);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var datauser = jsondata['data'];
          if (datauser == 'USER_INVALID') {
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
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return user;
  }

  //get User information
  static Future<UserObj> fetchUserInfor() async {
    UserObj user = new UserObj();
    String img = '';
    String auth = getTokenAuthenFromSharedPrefs();
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Accept-Charset': 'UTF-8',
      "Authorization": 'Bearer $auth'
    };
    try {
      final res = await http.get(Uri.parse('$_mainURL' + '$_getUserAvatar'),
          headers: header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          img = jsondata;
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    try {
      final res = await http.get(
          Uri.parse('$_mainURL' + '$_getUserInformation'),
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
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return user;
  }
}

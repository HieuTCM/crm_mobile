// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, unused_field, unnecessary_string_interpolations, prefer_adjacent_string_concatenation, unused_local_variable

import 'package:crm_mobile/customer/helpers/shared_prefs.dart';
import 'package:crm_mobile/customer/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/customer/models/person/employeeModel.dart';
import 'package:crm_mobile/customer/models/person/leadModel.dart';
import 'package:crm_mobile/customer/models/person/productOwner.dart';
import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:crm_mobile/customer/models/product/category_model.dart';
import 'package:crm_mobile/customer/models/product/product_model.dart';
import 'package:crm_mobile/customer/providers/product/product_provider.dart';
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
  //Appointment Status

  static const String _getAllAppointmentStatus =
      '/v1/api/Enum/appointment-status';

  //Appointment
  static const String _getAllApponitmemt = '/api/v1/Appointment/appointment?';
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

  static Future<List<AppointmentStatus>> fetchAllAppointmentStatus() async {
    List<AppointmentStatus> listActivityStatus = [];
    try {
      final res = await http.get(
          Uri.parse('$_mainURL' + '$_getAllAppointmentStatus'),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          for (var data in jsondata) {
            AppointmentStatus activityType =
                AppointmentStatus(id: data['id'], name: data['name']);
            listActivityStatus.add(activityType);
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

    return listActivityStatus;
  }

  static Future<List<Appointment>> fetchAllAppointments(
      Map<String, String> param) async {
    List<Appointment> listAppointment = [];
    UserObj user = UserObj();
    Category cate = Category();
    Owner owner = Owner();
    Role role = Role();
    Employee epm = Employee(role: role);
    int noFavorite = 0;
    int noView = 0;
    List<ProductImgae> listImg = [];
    Lead lead = Lead(account: user, employee: epm);
    Product product = Product(
        category: cate, owner: owner, employeeSold: epm, listImg: listImg);
    String queryString = Uri(queryParameters: param).query;
    try {
      final res = await http.get(
          Uri.parse(_mainURL + _getAllApponitmemt + queryString),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var totalRow = jsondata['totalRow'];
          var apppointmentData = jsondata['data'];
          for (var data in apppointmentData) {
            var leadData = data['lead'];
            if (leadData is Map) {
              lead = Lead(
                id: leadData['id'],
                accountId: leadData['accountId'],
                fullname: leadData['fullname'],
                nameCall: leadData['nameCall'],
                gender: leadData['gender'],
                dob: leadData['dob'],
                phone: leadData['phone'],
                email: leadData['email'],
                leadType: leadData['leadType'],
                website: leadData['website'],
                companyName: leadData['companyName'],
                createDate: leadData['createDate'],
                lastActivityDate: leadData['lastActivityDate'],
                lastActivityType: leadData['lastActivityType'],
                lifeCycleStage: leadData['lifeCycleStage'],
                leadStatus: leadData['leadStatus'],
                employeeId: leadData['employeeId'],
                employee: epm,
                account: user,
              );
            }
            var productData = data['product'];
            if (productData is Map) {
              await productProviders
                  .fetchProductByProID(productData['id'])
                  .then((value) async {
                product = value;
              });
            }
            if (data is Map) {
              Appointment appointment = Appointment(
                id: data['id'],
                name: data['name'],
                employeeId: data['employeeId'],
                leadId: data['leadId'],
                productId: data['productId'],
                fullname: data['fullname'],
                phone: data['phone'],
                email: data['email'],
                activityType: data['activityType'],
                appointmentStatus: data['appointmentStatus'],
                description:
                    data['description'].toString().replaceAll('//', '/'),
                createDate: data['createDate'],
                startDate: data['startDate'],
                startTime: data['startTime'],
                endDate: data['endDate'],
                abortReason: data['abortReason'],
                abortDate: data['abortDate'],
                acceptedDate: data['acceptedDate'],
                employee: epm,
                lead: lead,
                product: product,
                proOwner: product.owner,
                totalRow: totalRow,
              );
              listAppointment.add(appointment);
            }
          }
        }
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return listAppointment;
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

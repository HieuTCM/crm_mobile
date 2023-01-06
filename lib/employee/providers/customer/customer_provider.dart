import 'package:crm_mobile/employee/models/customer/analayze.dart';
import 'package:crm_mobile/employee/models/customer/customer_model.dart';
import 'package:crm_mobile/employee/models/person/employeeModel.dart';
import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/person/productOwner.dart';
import 'package:crm_mobile/employee/models/product/category_model.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:crm_mobile/employee/providers/product/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class CustomerProvider {
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
  static const String _getCustomer =
      '/api/v1/CustomerAccount/customer-account?';

  //Analyze
  static const String _getAnalyzeCate =
      '/api/v1/History/history/analyze-by-category?customerId=';
  static const String _getAnalyzeLocation =
      '/api/v1/History/history/analyze-by-location?customerId=';

  //Product
  static const String _getRecentList =
      '/api/v1/Product/product/customer-history-list/';
  static const String _getFavoriteList =
      '/api/v1/Product/product/customer-favorite-list/';

  /*-------------------------------------------------------------*/
  //Fetch_API
  static Future<List<Product>> fetchFavoriteList(String id) async {
    Category cate = Category();
    Owner owner = Owner();
    Role role = Role();
    Employee epm = Employee(role: role);
    List<ProductImgae> listImg = [];
    Product product = Product(
        category: cate, owner: owner, employeeSold: epm, listImg: listImg);
    List<Product> listproduct = [];

    try {
      final res = await http.get(Uri.parse(_mainURL + _getFavoriteList + id),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var dataProduct = jsondata['data'];
          for (var data in dataProduct) {
            await productProviders
                .fetchProductByProID(data['productId'])
                .then((value) async {
              product = value;

              if (!product.isDelete) {
                listproduct.add(product);
              }
            });
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        product = Product(
            id: 'NotFound',
            category: cate,
            owner: owner,
            employeeSold: epm,
            listImg: listImg);
        listproduct.add(product);
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return listproduct;
  }

  static Future<List<Product>> fetchRecentList(String id) async {
    Category cate = Category();
    Owner owner = Owner();
    Role role = Role();
    Employee epm = Employee(role: role);
    List<ProductImgae> listImg = [];
    Product product = Product(
        category: cate, owner: owner, employeeSold: epm, listImg: listImg);
    List<Product> listproduct = [];

    try {
      final res = await http.get(Uri.parse(_mainURL + _getRecentList + id),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var dataProduct = jsondata['data'];
          for (var data in dataProduct) {
            await productProviders
                .fetchProductByProID(data['productId'])
                .then((value) async {
              product = value;
              if (!product.isDelete) {
                listproduct.add(product);
              }
            });
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        product = Product(
            id: 'NotFound',
            category: cate,
            owner: owner,
            employeeSold: epm,
            listImg: listImg);
        listproduct.add(product);
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return listproduct;
  }

  static Future<List<AnalyzeCustomer>> fetchAnalyzeCate(String id) async {
    List<AnalyzeCustomer> listAnalyzeCate = [];
    try {
      final res = await http.get(Uri.parse(_mainURL + _getAnalyzeCate + id),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var dataAnalayze = jsondata['data'];
          for (var data in dataAnalayze) {
            AnalyzeCustomer analyzeCustomer = AnalyzeCustomer(
                name: data['category'], counting: data['counting'] + .0);
            listAnalyzeCate.add(analyzeCustomer);
          }
        }
      } else {
        AnalyzeCustomer analyzeCustomer =
            AnalyzeCustomer(name: 'NotFound', counting: 0.00);
        listAnalyzeCate.add(analyzeCustomer);
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return listAnalyzeCate;
  }

  static Future<List<AnalyzeCustomer>> fetchAnalyzeLocation(String id) async {
    List<AnalyzeCustomer> listAnalyzeCate = [];
    try {
      final res = await http.get(Uri.parse(_mainURL + _getAnalyzeLocation + id),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var dataAnalayze = jsondata['data'];
          for (var data in dataAnalayze) {
            AnalyzeCustomer analyzeCustomer = AnalyzeCustomer(
                name: data['location'], counting: data['counting'] + .0);
            listAnalyzeCate.add(analyzeCustomer);
          }
        }
      } else {
        AnalyzeCustomer analyzeCustomer =
            AnalyzeCustomer(name: 'NotFound', counting: 0.00);
        listAnalyzeCate.add(analyzeCustomer);
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return listAnalyzeCate;
  }

  static Future<List<CustomerModel>> fetchCustomer(
      Map<String, String> param) async {
    List<CustomerModel> listCustomer = [];
    String queryString = Uri(queryParameters: param).query;

    try {
      final res = await http.get(
          Uri.parse(_mainURL + _getCustomer + queryString),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var dataCustomer = jsondata['data'];
          var totalRow = jsondata['totalRow'];
          for (var data in dataCustomer) {
            CustomerModel customer = CustomerModel(
              totalRow: totalRow,
              id: data['id'],
              email: data['email'],
              fullname: data['fullname'],
              phone: data['phone'],
              gender: data['gender'],
              image: data['image'],
              dob: data['dob'],
              createDate: data['createDate'],
              status: data['status'],
            );
            listCustomer.add(customer);
          }
        }
      } else {
        CustomerModel customer = CustomerModel(id: 'NotFound');
        listCustomer.add(customer);
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return listCustomer;
  }
}

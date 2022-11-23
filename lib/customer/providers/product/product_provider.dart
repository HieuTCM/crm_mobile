// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, unused_field

import 'package:crm_mobile/customer/helpers/shared_prefs.dart';
import 'package:crm_mobile/customer/models/person/employeeModel.dart';
import 'package:crm_mobile/customer/models/person/productOwner.dart';
import 'package:crm_mobile/customer/models/product/category_model.dart';
import 'package:crm_mobile/customer/models/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class productProviders {
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
  static const String _getProductByCateID =
      '/api/v1/Product/product/product-category/';

  /*-------------------------------------------------------------*/
  //Fetch_API

  static Future<List<Product>> fetchProductByCateID(String id) async {
    Category cate = Category();
    Owner owner = Owner();
    Role role = Role();
    Employee epm = Employee(role: role);
    List<Product> listproduct = [];
    String auth = getTokenAuthenFromSharedPrefs();
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Accept-Charset': 'UTF-8',
      "Authorization": 'Bearer $auth'
    };
    try {
      final res = await http.get(Uri.parse(_mainURL + _getProductByCateID + id),
          headers: header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var dataProduct = jsondata['data'];
          for (var data in dataProduct) {
            List<ProductImgae> listImg = [];
            //fetch Category
            var cateData = data['category'];
            cate = Category(
                id: cateData['id'], name: cateData['productCategoryName']);
            //fetch Product Owner
            var ownerData = data['productOwner'];
            owner = Owner(
                id: ownerData['id'],
                name: ownerData['name'],
                email: ownerData['email'],
                phone: ownerData['phone'],
                isDelete: ownerData['isDelete']);
            //fetch product Img
            var listImgData = data['productImages'];
            if (listImgData.isEmpty) {
              ProductImgae img = ProductImgae(
                  title: 'Image',
                  url:
                      // 'https://media.publit.io/file/realestatecrm/fil-sT.jpg?at=eyJpdiI6ImdkeFIrclFnZ2NpQk95UmxCWjdvUEE9PSIsInZhbHVlIjoiamVYZzh3OHpoWGhvUWJjSStiSHo2ajErc2ptQytpUzRETU92RFNCK0tqdz0iLCJtYWMiOiIwMjhlYTA4ODcwODUzZTNjOTM4NjZiMGI3NDY5MzY0ZTg4ZDYwM2YyZTBiMjVmZDE0MDQyZTliOGI0Y2UzODFjIiwidGFnIjoiIn0=');
                      'https://www.sustainableplaces.eu/wp-content/uploads/2017/02/SmartBuilding.jpg');
              listImg.add(img);
              img = ProductImgae(
                  title: 'Image',
                  url:
                      // 'https://media.publit.io/file/realestatecrm/fil-sT.jpg?at=eyJpdiI6ImdkeFIrclFnZ2NpQk95UmxCWjdvUEE9PSIsInZhbHVlIjoiamVYZzh3OHpoWGhvUWJjSStiSHo2ajErc2ptQytpUzRETU92RFNCK0tqdz0iLCJtYWMiOiIwMjhlYTA4ODcwODUzZTNjOTM4NjZiMGI3NDY5MzY0ZTg4ZDYwM2YyZTBiMjVmZDE0MDQyZTliOGI0Y2UzODFjIiwidGFnIjoiIn0=');
                      'https://cdn.britannica.com/08/187508-050-D6FB5173/Shanghai-Tower-Gensler-San-Francisco-world-Oriental-2015.jpg');
              listImg.add(img);
            } else {
              for (var imgdata in listImgData) {
                ProductImgae img =
                    ProductImgae(title: imgdata['title'], url: imgdata['url']);
                listImg.add(img);
              }
            }
            //fetch Product
            Product product = Product(
              id: data['id'],
              name: data['name'],
              categoryId: data['categoryId'],
              price: data['price'],
              description: data['description'],
              area: data['area'],
              width: data['width'],
              length: data['length'],
              street: data['street'],
              province: data['province'],
              district: data['district'],
              noBedroom: data['noBedroom'],
              noToilet: data['noToilet'],
              noFloor: data['noFloor'],
              facade: data['facade'],
              isFurniture: data['isFurniture'],
              direction: data['direction'],
              utilities: data['utilities'],
              productOwnerId: data['productOwnerId'],
              productStatus: data['productStatus'],
              createDate: data['createDate'],
              updateDate: data['updateDate'],
              receivedDate: data['receivedDate'],
              soldDate: data['soldDate'],
              employeeSoldId: data['employeeSoldId'],
              isDelete: data['isDelete'],
              isSold: data['isSold'],
              category: cate,
              owner: owner,
              listImg: listImg,
              employeeSold: epm,
            );
            listproduct.add(product);
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Error ${res.statusCode.toString()} can't load product",
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
    return listproduct;
  }
}

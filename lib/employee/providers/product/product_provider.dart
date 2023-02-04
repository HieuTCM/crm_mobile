// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, unused_field, unused_local_variable, prefer_typing_uninitialized_variables

import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/person/employeeModel.dart';
import 'package:crm_mobile/employee/models/person/productOwner.dart';
import 'package:crm_mobile/employee/models/product/category_model.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class productProviders {
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
  static const String _getNoFavorite =
      '/api/v1/Product/product/number-of-farvorite?id=';
  static const String _getNoView = '/api/v1/Product/product/number-of-view?id=';
  static const String _getProductByCateID =
      '/api/v1/Product/product/product-category/';
  static const String _getProductByOwnerID =
      '/api/v1/Product/product/product-owner/';

  static const String _getProductByProID = '/api/v1/Product/product/';

  static const String _followProduct = '/api/v1/Product/product/favorite';
  static const String _getAllFollowProduct =
      '/api/v1/Product/product/my-favorite-list';
  static const String _getAllRecentProduct =
      '/api/v1/Product/product/my-recent-list';
  static const String _searchProduct = '/api/v1/Product/product?';
  static const String _getProductEnum = '/v1/api/Enum/all-product';
  static const String _getProductStatus = '/v1/api/Enum/product-status';

  /*-------------------------------------------------------------*/
  //Fetch_API

  static Future<List<String>> fetchProductStatus() async {
    List<String> listStatus = [];
    try {
      final res = await http.get(Uri.parse(_mainURL + _getProductStatus),
          headers: _header);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        for (var data in jsondata) {
          productStatus status = productStatus.fromJson(data);
          listStatus.add(status.name);
        }
      } else {
        Fluttertoast.showToast(
            msg: "Can't get Product Status",
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
    return listStatus;
  }

  static Future<int> fetchNoFarovite(String value) async {
    var noFavorite;

    try {
      final res = await http.get(Uri.parse(_mainURL + _getNoFavorite + value),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          noFavorite = jsondata;
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Can't get NoFavorite",
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

    return noFavorite;
  }

  static Future<List<productEnum>> fetchAllProductEnum() async {
    List<productEnum> listpro = [];
    try {
      final res = await http.get(Uri.parse(_mainURL + _getProductEnum),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var dataProduct = jsondata['data'];
          for (var data in dataProduct) {
            productEnum pro = productEnum.fromJson(data);
            listpro.add(pro);
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Can't get Product Enum",
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

    return listpro;
  }

  static Future<int> fetchNoView(String value) async {
    var noView;

    try {
      final res = await http.get(Uri.parse(_mainURL + _getNoView + value),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          noView = jsondata;
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Can't get NoView",
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

    return noView;
  }

  static Future<List<Product>> fetchProductByCateID(String id) async {
    Category cate = Category();
    Owner owner = Owner();
    Role role = Role();
    Employee epm = Employee(role: role);
    List<Product> listproduct = [];
    int noFavorite = 0;
    int noView = 0;
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
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png');
              listImg.add(img);
            } else {
              for (var imgdata in listImgData) {
                ProductImgae img =
                    ProductImgae(title: imgdata['title'], url: imgdata['url']);
                listImg.add(img);
              }
            }
            await productProviders.fetchNoFarovite(data['id']).then((value) {
              noFavorite = value;
            });
            await productProviders.fetchNoView(data['id']).then((value) {
              noView = value;
            });
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
              isFavorite: data['isFavorite'],
              noFavorite: noFavorite,
              noView: noView,
              category: cate,
              owner: owner,
              listImg: listImg,
              employeeSold: epm,
            );
            // if (!product.isDelete) {
            listproduct.add(product);
            // }
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Can't load product",
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

  static Future<List<Product>> fetchProductByOwnerID(String id) async {
    Category cate = Category();
    Owner owner = Owner();
    Role role = Role();
    Employee epm = Employee(role: role);
    List<Product> listproduct = [];
    int noFavorite = 0;
    int noView = 0;

    try {
      final res = await http.get(
          Uri.parse(_mainURL + _getProductByOwnerID + id),
          headers: _header);
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
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png');
              listImg.add(img);
            } else {
              for (var imgdata in listImgData) {
                ProductImgae img =
                    ProductImgae(title: imgdata['title'], url: imgdata['url']);
                listImg.add(img);
              }
            }
            await productProviders.fetchNoFarovite(data['id']).then((value) {
              noFavorite = value;
            });
            await productProviders.fetchNoView(data['id']).then((value) {
              noView = value;
            });
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
              isFavorite: data['isFavorite'],
              noFavorite: noFavorite,
              noView: noView,
              category: cate,
              owner: owner,
              listImg: listImg,
              employeeSold: epm,
            );
            // if (!product.isDelete) {
            listproduct.add(product);
            // }
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      }
      // else {
      //   Fluttertoast.showToast(
      //       msg: "Error ${res.statusCode.toString()} can't load product",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.BOTTOM,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Colors.red,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return listproduct;
  }

  static Future<Product> fetchProductByProID(String id) async {
    Category cate = Category();
    Owner owner = Owner();
    Role role = Role();
    Employee epm = Employee(role: role);
    List<ProductImgae> listImg = [];
    int noFavorite = 0;
    int noView = 0;
    Product product = Product(
        category: cate, owner: owner, employeeSold: epm, listImg: listImg);
    try {
      final res = await http.get(Uri.parse(_mainURL + _getProductByProID + id),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var Prodata = jsondata['data'];
          for (var data in Prodata) {
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
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png');
              listImg.add(img);
            } else {
              for (var imgdata in listImgData) {
                ProductImgae img =
                    ProductImgae(title: imgdata['title'], url: imgdata['url']);
                listImg.add(img);
              }
            }
            await productProviders.fetchNoFarovite(data['id']).then((value) {
              noFavorite = value;
            });
            await productProviders.fetchNoView(data['id']).then((value) {
              noView = value;
            });
            //fetch Product
            product = Product(
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
              isFavorite: data['isFavorite'],
              noFavorite: noFavorite,
              noView: noView,
              category: cate,
              owner: owner,
              listImg: listImg,
              employeeSold: epm,
            );
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Can't load product",
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

    return product;
  }

  static Future<bool> updFollowProduct(String value) async {
    bool status = false;
    var body = json.encode(value);
    try {
      final res = await http.put(Uri.parse(_mainURL + _followProduct),
          headers: _header, body: body);
      if (res.statusCode == 200) {
        var jsondata = json.decode(res.body);
        print(jsondata);
        status = jsondata;
      } else {
        Fluttertoast.showToast(
            msg: "Can't load product",
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

  static Future<List<Product>> fetchFollowdProduct() async {
    Category cate = Category();
    Owner owner = Owner();
    Role role = Role();
    Employee epm = Employee(role: role);
    List<ProductImgae> listImg = [];
    Product product = Product(
        category: cate, owner: owner, employeeSold: epm, listImg: listImg);
    List<Product> listproduct = [];

    try {
      final res = await http.get(Uri.parse(_mainURL + _getAllFollowProduct),
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

              // if (!product.isDelete) {
              listproduct.add(product);
              // }
            });
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Can't load product",
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

  static Future<List<Product>> fetchRecentProduct() async {
    Category cate = Category();
    Owner owner = Owner();
    Role role = Role();
    Employee epm = Employee(role: role);
    List<ProductImgae> listImg = [];
    Product product = Product(
        category: cate, owner: owner, employeeSold: epm, listImg: listImg);
    List<Product> listproduct = [];

    try {
      final res = await http.get(Uri.parse(_mainURL + _getAllRecentProduct),
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

              // if (!product.isDelete) {
              listproduct.add(product);
              // }
            });
          }
        } else {
          throw Exception('Error ${res.statusCode}');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Can't load product",
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

  static Future<List<Product>> fetchsearchProduct(
      Map<String, String> param) async {
    Category cate = Category();
    Owner owner = Owner();
    Role role = Role();
    Employee epm = Employee(role: role);
    int noFavorite = 0;
    int noView = 0;
    List<ProductImgae> listImg = [];
    Product product = Product(
        category: cate, owner: owner, employeeSold: epm, listImg: listImg);
    List<Product> listproduct = [];

    String queryString = Uri(queryParameters: param).query;
    try {
      final res = await http.get(
          Uri.parse(_mainURL + _searchProduct + queryString),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var dataProduct = jsondata['data'];
          var totalRow = jsondata['totalRow'];
          for (var data in dataProduct) {
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
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/1665px-No-Image-Placeholder.svg.png');
              listImg.add(img);
            } else {
              for (var imgdata in listImgData) {
                ProductImgae img =
                    ProductImgae(title: imgdata['title'], url: imgdata['url']);
                listImg.add(img);
              }
            }
            await productProviders.fetchNoFarovite(data['id']).then((value) {
              noFavorite = value;
            });
            await productProviders.fetchNoView(data['id']).then((value) {
              noView = value;
            });
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
              isFavorite: data['isFavorite'],
              noFavorite: noFavorite,
              noView: noView,
              totalRow: totalRow,
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
      } else if (res.statusCode == 404) {
        Category cate = Category();
        Owner owner = Owner();
        Role role = Role();
        Employee epm = Employee(role: role);
        int noFavorite = 0;
        int noView = 0;
        List<ProductImgae> listImg = [];
        Product product = Product(
            category: cate,
            owner: owner,
            employeeSold: epm,
            listImg: listImg,
            totalRow: 1);
        listproduct.add(product);
        Fluttertoast.showToast(
            msg: "Product not found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return listproduct;
      } else {
        Category cate = Category();
        Owner owner = Owner();
        Role role = Role();
        Employee epm = Employee(role: role);
        int noFavorite = 0;
        int noView = 0;
        List<ProductImgae> listImg = [];
        Product product = Product(
            category: cate,
            owner: owner,
            employeeSold: epm,
            listImg: listImg,
            totalRow: 1);
        listproduct.add(product);
        Fluttertoast.showToast(
            msg: "Product not found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return listproduct;
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return listproduct;
  }
}

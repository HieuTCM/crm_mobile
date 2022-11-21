import 'package:crm_mobile/customer/helpers/shared_prefs.dart';
import 'package:crm_mobile/customer/models/product/category_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class cateProviders {
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
  static const String _getAllCategory =
      '/api/v1/ProductCategory/product-category';

  /*-------------------------------------------------------------*/
  //Fetch_API

  static Future<List<Category>> fetchAllCategory() async {
    Category cate = new Category();
    List<Category> listcate = [];
    String auth = getTokenAuthenFromSharedPrefs();
    Map<String, String> header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Accept-Charset': 'UTF-8',
      "Authorization": 'Bearer $auth'
    };
    try {
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
      }
    } on HttpException catch (e) {
      print(e.toString());
    }
    return listcate;
  }
}

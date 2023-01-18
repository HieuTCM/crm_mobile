import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/person/productOwner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class OwnerProvider {
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
  static const String _getProductOwner = '/api/v1/ProductOwner/product-owner?';

  /*-------------------------------------------------------------*/
  //Fetch_API
  static Future<List<Owner>> fetchProductOwner(
      Map<String, String> param) async {
    List<Owner> listOwner = [];
    String queryString = Uri(queryParameters: param).query;
    try {
      final res = await http.get(
          Uri.parse(_mainURL + _getProductOwner + queryString),
          headers: _header);
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          var jsondata = json.decode(res.body);
          var dataOwner = jsondata['data'];
          var totalRow = jsondata['totalRow'];
          for (var data in dataOwner) {
            Owner owner = Owner.fromJson(data);

            owner.totalRow = totalRow;

            listOwner.add(owner);
          }
        }
      }
    } on HttpException catch (e) {
      print(e.toString());
    }

    return listOwner;
  }
}

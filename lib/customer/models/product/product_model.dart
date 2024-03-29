// ignore_for_file: file_names, camel_case_types, must_be_immutable, prefer_typing_uninitialized_variables, prefer_collection_literals

import 'package:crm_mobile/customer/models/person/employeeModel.dart';
import 'package:crm_mobile/customer/models/person/productOwner.dart';
import 'package:crm_mobile/customer/models/product/category_model.dart';

class ProductImgae {
  late final title;
  late final url;

  ProductImgae({this.title, this.url});
}

class Product {
  late final totalRow;
  late final id;
  late final name;
  late final categoryId;
  late final price;
  late final description;
  late final area;
  late final width;
  late final length;
  late final street;
  late final province;
  late final district;
  late final noBedroom;
  late final noToilet;
  late final noFloor;
  late final facade;
  late final isFurniture;
  late final direction;
  late final utilities;

  late final productOwnerId;
  late final productStatus;
  late final createDate;
  late final updateDate;
  late final receivedDate;
  late final soldDate;
  late final employeeSoldId;
  late final isDelete;
  late final isFavorite;
  late final isSold;
  late final noFavorite;
  late final noView;
  late Category category;
  late Employee employeeSold;
  late Owner owner;
  late List<ProductImgae> listImg;

  Product(
      {this.totalRow,
      this.id,
      this.name, //
      this.categoryId,
      this.price, //
      this.description, //
      this.width, //
      this.length, //
      this.area, //
      this.street, //
      this.province, //
      this.district, //
      this.direction, //
      this.facade, //
      this.isFurniture, //
      this.noBedroom, //
      this.noFloor, //
      this.noToilet, //
      this.utilities, //
      this.productOwnerId,
      this.productStatus,
      this.createDate,
      this.updateDate, //
      this.receivedDate,
      this.soldDate,
      this.employeeSoldId,
      this.isDelete,
      this.isSold,
      this.isFavorite,
      this.noFavorite,
      this.noView,
      required this.category,
      required this.owner,
      required this.employeeSold,
      required this.listImg}); //
}

class Fillter {
  late final id;
  late final name;
  Fillter({this.id, this.name});
}

class Sort {
  late final id;
  late final name;
  Sort({this.id, this.name});
}

class productStatus {
  late final id;
  late final name;

  productStatus({this.id, this.name});
  productStatus.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
  }
}

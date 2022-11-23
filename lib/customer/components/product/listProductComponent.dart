// ignore_for_file: file_names, camel_case_types, must_be_immutable

import 'package:crm_mobile/customer/components/product/productTab.dart';
import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:crm_mobile/customer/models/product/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class listProductComp extends StatefulWidget {
  List<Product> listProduct;
  UserObj user;
  listProductComp({super.key, required this.listProduct, required this.user});

  @override
  State<listProductComp> createState() => _listProductCompState();
}

class _listProductCompState extends State<listProductComp> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.listProduct.length,
        itemBuilder: (context, index) {
          return productTab(
            product: widget.listProduct[index],
            user: widget.user,
          );
        },
      ),
    );
  }
}

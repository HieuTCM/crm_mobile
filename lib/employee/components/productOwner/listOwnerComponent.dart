// ignore_for_file: file_names, camel_case_types, must_be_immutable

import 'package:crm_mobile/employee/models/person/productOwner.dart';
import 'package:crm_mobile/employee/components/product/productTab.dart';
import 'package:crm_mobile/employee/components/productOwner/productOwnerTab.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:crm_mobile/employee/providers/product/product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class listProductOwnerComp extends StatefulWidget {
  String wherecall;
  Function getListProductByCategory;
  List<Owner> listOwner;
  UserObj user;
  listProductOwnerComp(
      {super.key,
      required this.listOwner,
      required this.user,
      required this.getListProductByCategory,
      required this.wherecall});

  @override
  State<listProductOwnerComp> createState() => _listProductOwnerCompState();
}

class _listProductOwnerCompState extends State<listProductOwnerComp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.listOwner.length,
        itemBuilder: (context, index) {
          return OwnerTab(
            owner: widget.listOwner[index],
            user: widget.user,
          );
        },
      ),
    );
  }
}

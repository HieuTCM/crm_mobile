import 'package:crm_mobile/employee/components/product/listProductComponent.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:flutter/material.dart';

class ProductOwnerDetail extends StatefulWidget {
  List<Product> listProduct;
  ProductOwnerDetail({super.key, required this.listProduct});

  @override
  State<ProductOwnerDetail> createState() => _ProductOwnerDetailState();
}

class _ProductOwnerDetailState extends State<ProductOwnerDetail> {
  UserObj user = UserObj();
  getListProductByCategory() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('List Product')),
        body: Container(
            margin: const EdgeInsets.all(10),
            child: Column(children: [
              listProductComp(
                  listProduct: widget.listProduct,
                  user: user,
                  getListProductByCategory: getListProductByCategory,
                  wherecall: 'ProductOwner'),
            ])));
  }
}

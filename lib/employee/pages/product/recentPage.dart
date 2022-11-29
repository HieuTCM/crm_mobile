// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names

import 'package:crm_mobile/employee/components/NavBar/navBar.dart';
import 'package:crm_mobile/employee/components/product/listProductComponent.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:crm_mobile/employee/providers/product/product_provider.dart';
import 'package:crm_mobile/employee/providers/user/user_Provider.dart';
import 'package:flutter/material.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  bool waiting = true;
  UserObj user = UserObj();
  List<Product> listProduct = [];
  getUserinfo() async {
    await userProviders.fetchUserInfor().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  getListProduct(String id) async {
    setState(() {
      waiting = true;
    });
    await productProviders.fetchRecentProduct().then((value) {
      setState(() {
        listProduct = value;
        waiting = false;
      });
    });
  }

  @override
  void initState() {
    getUserinfo();
    getListProduct('');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Recent Product'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            (waiting)
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : (listProduct.isEmpty)
                    ? Container(
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.only(top: 12),
                        child: const Text(
                          'You have not view any product yet !!!',
                          style: TextStyle(fontSize: 20),
                        ))
                    : listProductComp(
                        wherecall: 'RecentPage',
                        listProduct: listProduct,
                        user: user,
                        getListProductByCategory: getListProduct,
                      )
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

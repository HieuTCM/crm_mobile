// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, prefer_final_fields, unused_field

import 'package:crm_mobile/employee/components/product/listProductComponent.dart';
import 'package:crm_mobile/employee/models/product/category_model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:crm_mobile/employee/pages/product/search/search.dart';
import 'package:crm_mobile/employee/providers/product/category_provider.dart';
import 'package:crm_mobile/employee/providers/product/product_provider.dart';
import 'package:crm_mobile/employee/providers/user/user_Provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String urlImg =
      'https://i.pinimg.com/474x/3d/b7/9e/3db79e59b9052890ea1ffbef0f3970cc.jpg';
  bool waiting = true;
  UserObj user = UserObj();
  List<Category> listCate = [];
  List<Product> listProduct = [];
  String? cateSelectedID;

  TextEditingController _searchController = TextEditingController();

  getUserinfo() async {
    userProviders.fetchUserInfor().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  getListProductByCategory(String id) async {
    setState(() {
      waiting = true;
    });
    productProviders.fetchProductByCateID(id).then((value) {
      setState(() {
        listProduct = value;
        waiting = false;
      });
    });
  }

  @override
  void initState() {
    getUserinfo();
    cateProviders.fetchAllCategory().then((value) {
      setState(() {
        listCate = value;
        cateSelectedID = listCate[0].id;
      });
      productProviders.fetchProductByCateID(listCate[0].id).then((value) {
        setState(() {
          waiting = false;
          listProduct = value;
        });
      });
    });
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
        title: const Text('Product Page'),
      ),
      body: (user.id == null)
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 12),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            autofocus: false,
                            controller: _searchController,
                            decoration: const InputDecoration(
                                hintText: "Search",
                                prefixIcon:
                                    Icon(Icons.search, color: Colors.black)),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: IconButton(
                            icon: const Icon(Icons.search, size: 35),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchPage(
                                            SearchValue: _searchController.text,
                                          )));
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      height: 10,
                      thickness: 2,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 170,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: listCate.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 120,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                gradient: (cateSelectedID ==
                                        listCate[index].id.toString())
                                    ? LinearGradient(
                                        colors: [
                                          Colors.green,
                                          Colors.greenAccent.shade700,
                                          Colors.teal,
                                        ],
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        stops: const [0.0, 0.4, 0.9],
                                        tileMode: TileMode.clamp,
                                      )
                                    : LinearGradient(
                                        colors: [
                                          Colors.lightBlue.shade200,
                                          Colors.blue.shade800,
                                          Colors.blueAccent.shade700,
                                        ],
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        stops: const [0.0, 0.6, 0.9],
                                        tileMode: TileMode.clamp,
                                      ),
                                borderRadius: BorderRadius.circular(12)),
                            child: ElevatedButton(
                              onPressed: () {
                                getListProductByCategory(listCate[index].id);
                                cateSelectedID = listCate[index].id;
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding: const EdgeInsets.all(12),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: Center(
                                  child: Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    listCate[index].name,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: FaIcon(
                                        icons[(index > 5)
                                            ? (index % 5) - 1
                                            : index],
                                        size: 50),
                                  )
                                ],
                              )),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      height: 10,
                      thickness: 2,
                    ),
                    (waiting)
                        ? const Expanded(
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : listProductComp(
                            wherecall: 'MainPage',
                            listProduct: listProduct,
                            user: user,
                            getListProductByCategory: getListProductByCategory,
                          ),
                    // const SizedBox(
                    //   height: 50,
                    // ),
                  ],
                ),
              ),
            ),
      // bottomNavigationBar: const NavBar(),
    );
  }

  List<IconData> icons = [
    FontAwesomeIcons.shop,
    FontAwesomeIcons.house,
    FontAwesomeIcons.building,
    FontAwesomeIcons.city,
    FontAwesomeIcons.hotel,
    FontAwesomeIcons.building,
  ];
}

// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, prefer_final_fields, unused_field

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_mobile/customer/components/NavBar/navBar.dart';
import 'package:crm_mobile/customer/components/product/listProductComponent.dart';
import 'package:crm_mobile/customer/helpers/shared_prefs.dart';
import 'package:crm_mobile/customer/models/notification/notificationModel.dart';
import 'package:crm_mobile/customer/models/product/category_model.dart';
import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:crm_mobile/customer/models/product/product_model.dart';
import 'package:crm_mobile/customer/pages/login/login.dart';
import 'package:crm_mobile/customer/pages/search/search.dart';
import 'package:crm_mobile/customer/providers/notification/notification_provider.dart';
import 'package:crm_mobile/customer/providers/product/category_provider.dart';
import 'package:crm_mobile/customer/providers/product/product_provider.dart';
import 'package:crm_mobile/customer/providers/user/user_Provider.dart';
import 'package:crm_mobile/main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String urlImg =
      'https://i.pinimg.com/474x/3d/b7/9e/3db79e59b9052890ea1ffbef0f3970cc.jpg';
  bool waiting = true;
  UserObj user = UserObj();
  List<Category> listCate = [];
  List<Product> listProduct = [];

  String? cateSelectedID;

  TextEditingController _searchController = TextEditingController();

  List<Notifications> listNoti = [];
  Map<String, String> mapParam = ({"pageNumber": "1", "pageSize": "10"});
  int totalRow = 0;
  int pageNumber = 1;
  int pageCurrent = 1;
  int totalpage = 1;

  getListNotifi() async {
    await notificationProvider.fetchAllNotifications(mapParam).then((value) {
      setState(() {
        listNoti = value;
        // waiting = false;
        totalRow = value[0].totalRow;
        totalpage = totalRow ~/ 10;
        if (totalRow % 10 != 0) {
          totalpage++;
        }
      });
    });
  }

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
    getListNotifi();
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
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0), // here the desired height
          child: AppBar(
            backgroundColor: Colors.blue,
            elevation: 0.0,
            leading: const Padding(
              padding: EdgeInsets.only(
                left: 18.0,
                top: 12.0,
                bottom: 12.0,
                right: 12.0,
              ),
            ),
          )),
      body: (user.id == null)
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                          width: 75,
                          height: 75,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          child: CircleAvatar(
                            radius: 48, // Image radius
                            backgroundImage: NetworkImage(
                                (user.image!.toString().isEmpty)
                                    ? urlImg
                                    : user.image),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      Row(children: [
                        Column(
                          children: [
                            Wrap(
                              children: [
                                Text('Welcome, ${user.fullName}'),
                              ],
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton(
                                child: const Text('Sign Out'),
                                onPressed: () async {
                                  GoogleSignIn _googleSignIn = GoogleSignIn();
                                  await _googleSignIn.signOut();
                                  await FirebaseAuth.instance.signOut();
                                  await sharedPreferences.clear();

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen()),
                                      (Route<dynamic> route) => false);
                                },
                              ),
                            ),
                          ],
                        )
                      ]),
                      const Spacer(),
                      Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              border: Border.all(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  width: 4.0,
                                  style: BorderStyle.solid)),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: const Icon(Icons.notifications),
                                tooltip: 'Notifications',
                                onPressed: () {
                                  // setState(() {
                                  //   waiting = true;
                                  // });
                                  getListNotifi();
                                  if (listNoti[0].id == null) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => StatefulBuilder(
                                                builder: ((context, setState) {
                                              return AlertDialog(
                                                content: Text(
                                                    'Don\'t have any notifications'),
                                              );
                                            })));
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (context) => StatefulBuilder(
                                                builder: ((context, setState) {
                                              return AlertDialog(
                                                  actions: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: const Text(
                                                              'Page: '),
                                                        ),
                                                        SizedBox(
                                                          child:
                                                              DropdownButton2(
                                                            value: pageCurrent,
                                                            dropdownMaxHeight:
                                                                300,
                                                            items: List<int>.generate(
                                                                    totalpage,
                                                                    (int index) =>
                                                                        index +
                                                                        1,
                                                                    growable:
                                                                        true)
                                                                .map((e) =>
                                                                    DropdownMenuItem(
                                                                        value:
                                                                            e,
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              100,
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Text(e.toString()),
                                                                        )))
                                                                .toList(),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                pageCurrent =
                                                                    value!;
                                                                mapParam.update(
                                                                    'pageNumber',
                                                                    (value) => value =
                                                                        pageCurrent
                                                                            .toString());
                                                                getListNotifi();
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                  title: const Text(
                                                      "Notifications"),
                                                  content: Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.5,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: ListView.builder(
                                                        scrollDirection:
                                                            Axis.vertical,
                                                        itemCount:
                                                            listNoti.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          Notifications noti =
                                                              listNoti[index];
                                                          return Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom: 10),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .blue)),
                                                            child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.6,
                                                                        child: AutoSizeText(
                                                                            noti
                                                                                .title,
                                                                            maxLines:
                                                                                1,
                                                                            style:
                                                                                const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.6,
                                                                        child: AutoSizeText(
                                                                            'Create Date: ${noti.createDate}',
                                                                            style:
                                                                                const TextStyle(fontSize: 14)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width: MediaQuery.of(context).size.width *
                                                                            0.6,
                                                                        child: AutoSizeText(
                                                                            noti
                                                                                .content,
                                                                            style:
                                                                                TextStyle(fontSize: 14)),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ]),
                                                          );
                                                        }),
                                                  ));
                                            })));
                                  }
                                },
                              ))),
                    ],
                  ),
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
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: listCate.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 110,
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
      bottomNavigationBar: const NavBar(),
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

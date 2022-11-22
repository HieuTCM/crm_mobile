import 'package:crm_mobile/customer/components/NavBar/navBar.dart';
import 'package:crm_mobile/customer/components/product/listProductComponent.dart';
import 'package:crm_mobile/customer/models/product/category_model.dart';
import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:crm_mobile/customer/models/product/product_model.dart';
import 'package:crm_mobile/customer/pages/login/login.dart';
import 'package:crm_mobile/customer/providers/product/category_provider.dart';
import 'package:crm_mobile/customer/providers/product/product_provider.dart';
import 'package:crm_mobile/customer/providers/user/user_Provider.dart';
import 'package:crm_mobile/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String urlImg =
      'https://i.pinimg.com/474x/3d/b7/9e/3db79e59b9052890ea1ffbef0f3970cc.jpg';
  bool waiting = true;
  UserObj user = new UserObj();
  List<Category> listCate = [];
  List<Product> listProduct = [];
  String? cateSelectedID;
  getUserinfo() async {
    userProviders.fetchUserInfor().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  Future getListProductByCategory(String id) async {
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
    List<IconData> icons = [
      FontAwesomeIcons.shop,
      FontAwesomeIcons.house,
      FontAwesomeIcons.building,
      FontAwesomeIcons.city,
      FontAwesomeIcons.hotel,
      FontAwesomeIcons.building
    ];
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
                                          builder: (context) => LoginScreen()),
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
                                onPressed: () {},
                              ))),
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
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12)),
                          child: ElevatedButton(
                            onPressed: () {
                              getListProductByCategory(listCate[index].id);
                              cateSelectedID = listCate[index].id;
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              padding: const EdgeInsets.all(12),
                              backgroundColor: (cateSelectedID ==
                                      listCate[index].id.toString())
                                  ? Color.fromARGB(255, 10, 76, 109)
                                  : Colors.blue,
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
                                  child: FaIcon(icons[index], size: 50),
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
                      : listProductComp(listProduct: listProduct)
                ],
              ),
            ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, prefer_final_fields, unused_field

import 'package:crm_mobile/employee/models/product/category_model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:crm_mobile/employee/pages/appointment/appointmentPage.dart';
import 'package:crm_mobile/employee/pages/login/loginPage.dart';
import 'package:crm_mobile/employee/pages/product/productPage.dart';
import 'package:crm_mobile/employee/pages/product/search/search.dart';
import 'package:crm_mobile/employee/pages/productOwner/productOwnerPage.dart';
import 'package:crm_mobile/employee/pages/task/taskPage.dart';
import 'package:crm_mobile/employee/providers/product/category_provider.dart';
import 'package:crm_mobile/employee/providers/product/product_provider.dart';
import 'package:crm_mobile/employee/providers/user/user_Provider.dart';
import 'package:crm_mobile/main.dart';
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
          : SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.height,
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
                                  onPressed: () {},
                                ))),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      height: 10,
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Spacer(),
                                createWidget(
                                    'Product',
                                    const FaIcon(FontAwesomeIcons.box,
                                        size: 50),
                                    Colors.blue,
                                    const ProductPage()),
                                const SizedBox(
                                  width: 30,
                                ),
                                createWidget(
                                    'Product Owner',
                                    const FaIcon(FontAwesomeIcons.userTie,
                                        size: 50),
                                    Colors.blue,
                                    const ProductOwnerPage()),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                createWidget(
                                    'Task',
                                    const FaIcon(FontAwesomeIcons.listCheck,
                                        size: 50),
                                    Colors.blueGrey,
                                    const TaskPage()),
                                const SizedBox(
                                  width: 30,
                                ),
                                createWidget(
                                    'Appointment',
                                    const FaIcon(FontAwesomeIcons.calendarCheck,
                                        size: 50),
                                    Colors.blueGrey,
                                    const AppointmentPage()),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                createWidget(
                                    'Customer',
                                    const FaIcon(FontAwesomeIcons.user,
                                        size: 50),
                                    Colors.teal,
                                    SearchPage(SearchValue: '')),
                                const SizedBox(
                                  width: 30,
                                ),
                                createWidget(
                                    'Lead',
                                    const FaIcon(FontAwesomeIcons.userCheck,
                                        size: 50),
                                    Colors.teal,
                                    SearchPage(SearchValue: '')),
                                const Spacer(),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                createWidget(
                                    'Opportunity',
                                    const FaIcon(FontAwesomeIcons.userPlus,
                                        size: 50),
                                    Colors.indigoAccent,
                                    SearchPage(SearchValue: '')),
                                const SizedBox(
                                  width: 30,
                                ),
                                createWidget(
                                    'Feedback',
                                    const FaIcon(FontAwesomeIcons.comment,
                                        size: 50),
                                    Colors.indigoAccent,
                                    SearchPage(SearchValue: '')),
                                const Spacer(),
                              ],
                            ),
                          ]),
                    )
                  ],
                ),
              ),
            ),
      // bottomNavigationBar: const NavBar(),
    );
  }

  Widget createWidget(String name, FaIcon icon, Color colors, Widget widget) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => widget));
        },
        child: Container(
          width: 150,
          height: 165,
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: colors,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: icon,
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ],
          )),
        ));
  }
}

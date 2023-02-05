// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, prefer_final_fields, unused_field

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_mobile/employee/helpers/shared_prefs.dart';
import 'package:crm_mobile/employee/models/notification/notificationModel.dart';
import 'package:crm_mobile/employee/models/product/category_model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:crm_mobile/employee/pages/appointment/appointmentPage.dart';
import 'package:crm_mobile/employee/pages/customer/customer.dart';
import 'package:crm_mobile/employee/pages/feedback/feedbackPage.dart';
import 'package:crm_mobile/employee/pages/kpi/kpiPage.dart';
import 'package:crm_mobile/employee/pages/lead/leadPage.dart';
import 'package:crm_mobile/employee/pages/login/loginPage.dart';
import 'package:crm_mobile/employee/pages/opportunity/opportunityPage.dart';
import 'package:crm_mobile/employee/pages/product/productPage.dart';
import 'package:crm_mobile/employee/pages/product/search/search.dart';
import 'package:crm_mobile/employee/pages/productOwner/productOwnerPage.dart';
import 'package:crm_mobile/employee/pages/task/taskPage.dart';
import 'package:crm_mobile/employee/providers/notification/notification_provider.dart';
import 'package:crm_mobile/employee/providers/product/category_provider.dart';
import 'package:crm_mobile/employee/providers/product/product_provider.dart';
import 'package:crm_mobile/employee/providers/user/user_Provider.dart';
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
        waiting = false;
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
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: const Icon(Icons.notifications),
                                  tooltip: 'Notifications',
                                  onPressed: () {
                                    setState(() {
                                      waiting = true;
                                    });
                                    getListNotifi();
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
                                  },
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
                                    Colors.blue,
                                    const TaskPage()),
                                const SizedBox(
                                  width: 30,
                                ),
                                createWidget(
                                    'Appointment',
                                    const FaIcon(FontAwesomeIcons.calendarCheck,
                                        size: 50),
                                    Colors.blue,
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
                                    Colors.blue,
                                    const CustomerPage()),
                                const SizedBox(
                                  width: 30,
                                ),
                                createWidget(
                                    'Lead',
                                    const FaIcon(FontAwesomeIcons.userCheck,
                                        size: 50),
                                    Colors.blue,
                                    LeadPage()),
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
                                    Colors.blue,
                                    OpportunityPage()),
                                const SizedBox(
                                  width: 30,
                                ),
                                createWidget(
                                    'Feedback',
                                    const FaIcon(FontAwesomeIcons.comment,
                                        size: 50),
                                    Colors.blue,
                                    FeedbackPage()),
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
                                    'KPI',
                                    const FaIcon(FontAwesomeIcons.user,
                                        size: 50),
                                    Colors.blue,
                                    const KPIPage()),
                                const Spacer(),
                              ],
                            )
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
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.width * 0.4,
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

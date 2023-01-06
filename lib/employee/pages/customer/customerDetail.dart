// ignore_for_file: prefer_interpolation_to_compose_strings, unnecessary_null_comparison

import 'package:crm_mobile/employee/models/customer/analayze.dart';
import 'package:crm_mobile/employee/models/customer/customer_model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:crm_mobile/employee/pages/productOwner/productOwnerDetail.dart';
import 'package:crm_mobile/employee/providers/customer/customer_provider.dart';
import 'package:crm_mobile/employee/providers/user/user_Provider.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetailPage extends StatefulWidget {
  CustomerModel customer;
  CustomerDetailPage({super.key, required this.customer});

  @override
  State<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends State<CustomerDetailPage> {
  UserObj user = UserObj();
  List<Product> recentlist = [];
  List<Product> followwlist = [];
  List<AnalyzeCustomer> catelist = [];
  List<AnalyzeCustomer> locationlist = [];
  bool recentLoading = true;
  bool followLoading = true;
  Map<String, double> categories = new Map<String, double>();
  Map<String, double> locations = new Map<String, double>();

  getUserinfo() async {
    userProviders.fetchUserInfor().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  getAnalyzeValue() async {
    CustomerProvider.fetchAnalyzeCate(widget.customer.id).then((value) {
      catelist = value;
      if (value.isEmpty) {
        categories['NotFound'] = 1;
      } else {
        for (int i = 0; i < catelist.length; i++) {
          // double doubleVar = catelist[i].counting.toDouble();
          categories[catelist[i].name] = catelist[i].counting;
        }
      }
    });
    CustomerProvider.fetchAnalyzeLocation(widget.customer.id).then((value) {
      locationlist = value;
      if (value.isEmpty) {
        locations['NotFound'] = 1;
      } else {
        for (int i = 0; i < locationlist.length; i++) {
          // double doubleVar = catelist[i].counting.toDouble();
          locations[locationlist[i].name] = locationlist[i].counting;
        }
      }
    });
  }

  getRecetnList() async {
    CustomerProvider.fetchRecentList(widget.customer.id).then((value) {
      setState(() {
        recentLoading = false;
        if (value[0].id != 'NotFound') {
          recentlist = value;
        }
      });
    });
  }

  getFollowList() async {
    CustomerProvider.fetchFavoriteList(widget.customer.id).then((value) {
      setState(() {
        followLoading = false;
        if (value[0].id != 'NotFound') {
          followwlist = value;
        }
      });
    });
  }

  @override
  void initState() {
    getRecetnList();
    getFollowList();
    getAnalyzeValue();
    getUserinfo();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String urlImg =
        'https://i.pinimg.com/474x/3d/b7/9e/3db79e59b9052890ea1ffbef0f3970cc.jpg';

    return Scaffold(
        appBar: AppBar(title: const Text('Customer Detail Page')),
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height * 0.75,
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                child: Center(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: CircleAvatar(
                              radius: 48, // Image radius
                              backgroundImage: NetworkImage(
                                  (widget.customer.image.toString().length <=
                                          10)
                                      ? urlImg
                                      : widget.customer.image),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text(widget.customer.fullname)],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text('Email: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(' ${widget.customer.email}',
                              style: const TextStyle(fontSize: 17)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text('Phone: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  _makePhoneCall(widget.customer.phone);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      widget.customer.phone,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text('Recent Product: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: (recentLoading)
                              ? const Text('Loading ...',
                                  style: TextStyle(fontSize: 17))
                              : (recentlist.isEmpty)
                                  ? const Text(
                                      '0',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        (recentlist.isEmpty)
                                            ? null
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductOwnerDetail(
                                                          listProduct:
                                                              recentlist,
                                                        )));
                                      },
                                      child: Text(
                                        '${recentlist.length}  (View More)',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text('Followed Product: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: (followLoading)
                              ? const Text('Loading ...',
                                  style: TextStyle(fontSize: 17))
                              : (followwlist.isEmpty)
                                  ? const Text(
                                      '0',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 20,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        (followwlist.isEmpty)
                                            ? null
                                            : Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductOwnerDetail(
                                                          listProduct:
                                                              followwlist,
                                                        )));
                                      },
                                      child: Text(
                                        '${followwlist.length}  (View More)',
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    (categories.isEmpty)
                        ? const SizedBox()
                        : const Text('History analyze Category: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                    (categories.isEmpty)
                        ? const SizedBox()
                        : PieChart(
                            dataMap: categories,
                            chartRadius:
                                MediaQuery.of(context).size.width / 1.7,
                            legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.right),
                            chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true),
                          ),
                    (locations.isEmpty)
                        ? const SizedBox()
                        : const Text('History analyze Location: ',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                    (locations.isEmpty)
                        ? const SizedBox()
                        : PieChart(
                            dataMap: locations,
                            chartRadius:
                                MediaQuery.of(context).size.width / 1.7,
                            legendOptions: const LegendOptions(
                              legendPosition: LegendPosition.bottom,
                              showLegendsInRow: true,
                            ),
                            chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true,
                                chartValueStyle: TextStyle(
                                    color: Colors.black, fontSize: 12)),
                          )
                  ]),
                ))
          ]),
        ));
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (!await launchUrl(launchUri)) {
      throw 'Could not launch $launchUri';
    }
  }
}

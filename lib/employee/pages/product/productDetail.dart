// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names

import 'package:crm_mobile/employee/components/product/productDetailComponent.dart';
import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:crm_mobile/employee/pages/product/followPgae.dart';
import 'package:crm_mobile/employee/pages/product/recentPage.dart';
import 'package:crm_mobile/employee/pages/root/mainPage.dart';
import 'package:crm_mobile/employee/pages/product/search/search.dart';
import 'package:crm_mobile/employee/providers/appointment/appointment_provider.dart';
import 'package:crm_mobile/employee/providers/product/product_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:xen_popup_card/xen_card.dart';

class ProductDetail extends StatefulWidget {
  String wherecall;
  Product product;
  UserObj user;
  ProductDetail(
      {super.key,
      required this.product,
      required this.user,
      required this.wherecall});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _tabIndex = 0;
  List<ActivityType> listActivityTypes = [];
  ActivityType? activityTypeSelected;
  DateTime _date = DateTime.now();
  TimeOfDay _Time = TimeOfDay.now();
  bool popupClosed = false;
  bool isFollow = false;
  previousImge() {
    setState(() {
      if (_tabIndex > 0) {
        _tabIndex--;
      } else {
        _tabIndex = widget.product.listImg.length - 1;
      }
    });
  }

  nextImge() {
    setState(() {
      if (_tabIndex >= widget.product.listImg.length - 1) {
        _tabIndex = 0;
      } else {
        _tabIndex++;
      }
    });
  }

  TextEditingController nameRequestController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();

  String? nameRequest;
  String? DescriptionRequest;

  String? validReqName;
  String? validCusName;
  bool isSelectedType = false;
  String? validDes;

  String? validateName(String value) {
    RegExp regExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
    bool check = regExp.hasMatch(value);
    if (value.isEmpty) {
      return 'Enter your name';
    } else if (check) {
      return 'Enter a Valid name';
    } else if (value.length < 3) {
      return 'Name more than 3 characters';
    } else if (value.length >= 50) {
      return 'Name no more than 50 characters';
    } else {
      return (!regExp.hasMatch(value)) ? null : 'Name Invald';
    }
  }

  String? validateResName(String value) {
    RegExp regExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
    bool check = regExp.hasMatch(value);
    if (value.isEmpty) {
      return 'Enter Resquest Name';
    } else if (check) {
      return 'Enter a Valid Resquest Name';
    } else if (value.length < 3) {
      return 'Resquest Name more than 3 characters';
    } else if (value.length >= 30) {
      return 'Resquest Name no more than 30 characters';
    } else {
      return (!regExp.hasMatch(value)) ? null : 'Resquest Name Invald';
    }
  }

  String? validateDes(String value) {
    // RegExp regExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
    // RegExp regExp = RegExp('');
    // bool check = regExp.hasMatch(value);
    if (value.isEmpty) {
      return 'Enter your Description';
    } else if (value.length < 3) {
      return 'Resquest Name more than 3 characters';
    } else if (value.length >= 50) {
      return 'Description no more than 50 characters';
    } else {
      return null;
    }
  }

  submitRequest(String value) {
    print(value);
  }

  @override
  void initState() {
    super.initState();
    appointmentProvider.fetchAllActivityTypes().then((value) async {
      setState(() {
        for (var data in value) {
          listActivityTypes.add(data);
        }
      });
    });
    if (widget.product.isFavorite) {
      setState(() {
        isFollow = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserObj userData = widget.user;

    final children = <Widget>[];
    for (var img in widget.product.listImg) {
      children.add(
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(
              img.url.toString(),
            ),
            fit: BoxFit.cover,
          )),
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.45,
                child: Stack(
                  // alignment: Alignment.topCenter,
                  children: [
                    IndexedStack(index: _tabIndex, children: children),
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(12),
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 161, 159, 159)
                                  .withOpacity(0),
                              border: Border.all(color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(12)),
                          child: IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.chevronLeft,
                              size: 20,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (widget.wherecall == 'MainPage') {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainPage()));
                              } else if (widget.wherecall == 'FollowPage') {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FollowPage()));
                              } else if (widget.wherecall == 'RecentPage') {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RecentPage()));
                              } else if (widget.wherecall == 'SearchPage') {
                                Navigator.of(context).pop();
                              } else if (widget.wherecall ==
                                  'AppointmentView') {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.chevronLeft,
                                size: 20,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                previousImge();
                              },
                            ),
                          ),
                          const Spacer(),
                          Container(
                            width: 40,
                            height: 40,
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: const FaIcon(
                                FontAwesomeIcons.chevronRight,
                                size: 20,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                nextImge();
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            ],
          ),
          ProductDetailComponent(product: widget.product),
        ],
      ),

      //bottomNavigationBar: const NavBar(),
    );
  }

  XenCardGutter? CardGutter() {
    XenCardGutter gutter = XenCardGutter(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              if (validateName(nameController.text) != null ||
                  validateResName(nameRequestController.text) != null ||
                  validateDes(DescriptionController.text) != null ||
                  isSelectedType == false) {
                Fluttertoast.showToast(
                    msg: "Invalid Input",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                Navigator.pop(context);
                setState(() {
                  popupClosed = true;
                });
                RequestAppointment request = RequestAppointment(
                    name: nameRequestController.text,
                    email: widget.user.emailAddress,
                    phone: widget.user.phoneNumber,
                    fullname: nameController.text,
                    activityType: activityTypeSelected!.name,
                    description: DescriptionRequest,
                    productId: widget.product.id,
                    startDate: DateFormat(
                      'MM/dd/yyyy',
                    ).format(_date),
                    startTime: '${_Time.hour}:${_Time.minute}');
                appointmentProvider.insAppointment(request).then((value) {
                  setState(() {
                    popupClosed = false;
                  });
                  Fluttertoast.showToast(
                      msg: " $value",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                });
              }
            },
            child: const Text('Submit'),
          )),
    );
    return gutter;
  }
}

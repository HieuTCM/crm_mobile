// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names

import 'package:crm_mobile/customer/components/product/productDetailComponent.dart';
import 'package:crm_mobile/customer/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:crm_mobile/customer/models/product/product_model.dart';
import 'package:crm_mobile/customer/pages/product/followPgae.dart';
import 'package:crm_mobile/customer/pages/product/recentPage.dart';
import 'package:crm_mobile/customer/pages/root/mainPage.dart';
import 'package:crm_mobile/customer/providers/appointment/appointment_provider.dart';
import 'package:crm_mobile/customer/providers/product/product_provider.dart';
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
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RecentPage()));
                              } else if (widget.wherecall ==
                                  'AppointmentView') {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ),
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.all(12),
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(0, 255, 255, 255)
                                  .withOpacity(0.6),
                              borderRadius: BorderRadius.circular(50)),
                          child: IconButton(
                            icon: FaIcon(
                              FontAwesomeIcons.heart,
                              size: 20,
                              color: (isFollow)
                                  ? Colors.red
                                  : const Color.fromARGB(255, 0, 0, 0),
                            ),
                            onPressed: () async {
                              await productProviders
                                  .updFollowProduct(widget.product.id)
                                  .then((value) {
                                if (value) {
                                  setState(() {
                                    isFollow = !isFollow;
                                  });
                                  if (isFollow) {
                                    Fluttertoast.showToast(
                                        msg: "Follow Product Successful",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: " Product Unfollowed",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: const Color.fromARGB(
                                            255, 223, 0, 0),
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Follow Product failed",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                              });
                            },
                          ),
                        )
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
          (widget.product.isSold)
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    height: 50.0,
                    width: 300,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.grey, Colors.grey, Colors.grey],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.0, 0.6, 0.9],
                        tileMode: TileMode.clamp,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Product is Sold',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ))
              : (popupClosed)
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        height: 50.0,
                        width: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.lightBlue.shade200,
                              Colors.blue.shade800,
                              Colors.blueAccent.shade700,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: const [0.0, 0.6, 0.9],
                            tileMode: TileMode.clamp,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ))
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        height: 50.0,
                        width: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.lightBlue.shade200,
                              Colors.blue.shade800,
                              Colors.blueAccent.shade700,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: const [0.0, 0.6, 0.9],
                            tileMode: TileMode.clamp,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (emailController.text == "") {
                              emailController.text = userData.emailAddress;
                            }
                            if (nameController.text == "") {
                              nameController.text = userData.fullName;
                            }
                            if (phoneController.text == "") {
                              phoneController.text = userData.phoneNumber;
                            }

                            showDialog(
                                context: context,
                                builder: (builder) => StatefulBuilder(
                                    builder: ((context, setState) =>
                                        XenPopupCard(
                                          gutter: CardGutter(),
                                          body: Container(
                                              alignment: Alignment.topLeft,
                                              padding: const EdgeInsets.all(12),
                                              child: SingleChildScrollView(
                                                child: Column(children: [
                                                  Row(
                                                    children: const [
                                                      Text(
                                                        'Name of Request : ',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                  TextField(
                                                      controller:
                                                          nameRequestController,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          validReqName =
                                                              validateResName(
                                                                  value);
                                                          nameRequest =
                                                              value.replaceAll(
                                                                  RegExp('\n'),
                                                                  r' \n ');
                                                        });
                                                      },
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        errorText: validReqName,
                                                        hintText:
                                                            "Name of Request ",
                                                      )),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: const [
                                                      Text(
                                                        'Your Name :',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                      controller:
                                                          nameController,
                                                      keyboardType:
                                                          TextInputType.name,
                                                      onChanged: (value) {
                                                        validCusName =
                                                            validateName(value);
                                                      },
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            const OutlineInputBorder(),
                                                        errorText: validCusName,
                                                        hintText: "Your Name",
                                                      )),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        'Type of Request :',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const Spacer(),
                                                      SizedBox(
                                                        child: DropdownButton2(
                                                          hint: const Text(
                                                              'Select Type'),
                                                          value:
                                                              activityTypeSelected,
                                                          items:
                                                              listActivityTypes
                                                                  .map((e) =>
                                                                      DropdownMenuItem(
                                                                        value:
                                                                            e,
                                                                        child: Text(
                                                                            e.name),
                                                                      ))
                                                                  .toList(),
                                                          onChanged: (value) {
                                                            setState(() {
                                                              isSelectedType =
                                                                  true;
                                                              activityTypeSelected =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  (isSelectedType)
                                                      ? const SizedBox()
                                                      : Row(
                                                          children: const [
                                                            Spacer(),
                                                            Text(
                                                              'Select Type',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize: 12),
                                                            )
                                                          ],
                                                        ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: const [
                                                      Text(
                                                        'Description :',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    controller:
                                                        DescriptionController,
                                                    keyboardType:
                                                        TextInputType.multiline,
                                                    maxLines: 4,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        validDes =
                                                            validateDes(value);
                                                        DescriptionRequest =
                                                            value.replaceAll(
                                                                RegExp('\n'),
                                                                r' \n');
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                        errorText: validDes,
                                                        hintText:
                                                            "Enter Description",
                                                        border:
                                                            const OutlineInputBorder(),
                                                        focusedBorder:
                                                            const OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                    width: 1,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0)))),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Date : ",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      IconButton(
                                                          onPressed: (() {
                                                            showDatePicker(
                                                                    context:
                                                                        context,
                                                                    initialDate: DateTime(
                                                                        DateTime.now()
                                                                            .year,
                                                                        DateTime.now()
                                                                            .month,
                                                                        DateTime.now()
                                                                            .day),
                                                                    firstDate: DateTime(
                                                                        DateTime.now()
                                                                            .year,
                                                                        DateTime.now()
                                                                            .month,
                                                                        DateTime.now()
                                                                            .day),
                                                                    lastDate:
                                                                        DateTime(
                                                                            2050))
                                                                .then((value) {
                                                              setState(() {
                                                                _date = value!;
                                                              });
                                                            });
                                                          }),
                                                          icon: const FaIcon(
                                                            FontAwesomeIcons
                                                                .calendar,
                                                            color: Colors.blue,
                                                            size: 30,
                                                          )),
                                                      Text(
                                                        DateFormat(
                                                          'MM/dd/yyyy',
                                                        ).format(_date),
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Time : ",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      IconButton(
                                                          onPressed: (() {
                                                            showTimePicker(
                                                                    context:
                                                                        context,
                                                                    builder: (context,
                                                                        child) {
                                                                      return MediaQuery(
                                                                        data: MediaQuery.of(context).copyWith(
                                                                            alwaysUse24HourFormat:
                                                                                true),
                                                                        child: child ??
                                                                            Container(),
                                                                      );
                                                                    },
                                                                    initialTime: TimeOfDay(
                                                                        hour: TimeOfDay.now()
                                                                            .hour,
                                                                        minute:
                                                                            TimeOfDay.now().minute))
                                                                .then((value) {
                                                              setState(() {
                                                                _Time = value!;
                                                              });
                                                            });
                                                          }),
                                                          icon: const FaIcon(
                                                            FontAwesomeIcons
                                                                .clock,
                                                            color: Colors.blue,
                                                            size: 30,
                                                          )),
                                                      Text(
                                                        _Time.format(context),
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 100,
                                                  ),
                                                ]),
                                              )),
                                        ))));
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.transparent,
                            elevation: 0.0,
                          ),
                          child: const Text(
                            "Ask for advice",
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
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

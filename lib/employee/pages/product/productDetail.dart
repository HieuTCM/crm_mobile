// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names

import 'package:crm_mobile/employee/components/product/productDetailComponent.dart';
import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:crm_mobile/employee/pages/product/productPage.dart';
import 'package:crm_mobile/employee/providers/appointment/appointment_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductDetail extends StatefulWidget {
  String wherecall;
  Product product;
  ProductDetail({super.key, required this.product, required this.wherecall});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _tabIndex = 0;
  List<ActivityType> listActivityTypes = [];
  ActivityType? activityTypeSelected;
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
                                Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ProductPage()));
                              } else if (widget.wherecall == 'SearchPage') {
                                Navigator.of(context).pop();
                              } else if (widget.wherecall == 'ProductOwner') {
                                Navigator.pop(context);
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
}

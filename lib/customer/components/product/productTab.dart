// ignore_for_file: file_names, camel_case_types, must_be_immutable

import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:crm_mobile/customer/models/product/product_model.dart';
import 'package:crm_mobile/customer/pages/product/productDetail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class productTab extends StatefulWidget {
  Product product;
  UserObj user;
  productTab({super.key, required this.product, required this.user});

  @override
  State<productTab> createState() => _productTabState();
}

bool isfollow = false;

class _productTabState extends State<productTab> {
  var f = NumberFormat("###,###,###.0#", "en_US");
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade800,
              Colors.lightBlue.shade200,
              Colors.blueAccent.shade700,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            stops: const [0.0, 0.4, 0.9],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.circular(12)),
      child: InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetail(
                          product: widget.product,
                          user: widget.user,
                        )));
          },
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.product.listImg[0].url.toString(),
                            ),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(6),
                    width: 50,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 161, 159, 159)
                            .withOpacity(0.6),
                        borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      icon: FaIcon(
                        FontAwesomeIcons.heart,
                        size: 30,
                        color: (isfollow) ? Colors.red : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {});
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Wrap(children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.product.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),
              Wrap(children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${f.format(widget.product.price)} VND',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),
              Wrap(children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      widget.product.district + ' ' + widget.product.province),
                ),
              ]),
            ],
          )),
    );
  }
}

// ignore_for_file: file_names, camel_case_types, must_be_immutable, use_build_context_synchronously

import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:crm_mobile/employee/models/person/productOwner.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/pages/productOwner/productOwnerDetail.dart';
import 'package:crm_mobile/employee/providers/product/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class OwnerTab extends StatefulWidget {
  Owner owner;
  UserObj user;
  OwnerTab({
    super.key,
    required this.owner,
    required this.user,
  });

  @override
  State<OwnerTab> createState() => _OwnerTabState();
}

class _OwnerTabState extends State<OwnerTab> {
  List<Product> listProduct = [];
  getlistProduct(String value) async {
    await productProviders.fetchProductByOwnerID(value).then((value) {
      setState(() {
        listProduct = value;
      });
    });
  }

  @override
  void initState() {
    getlistProduct(widget.owner.id);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 90,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue, width: 3)),
      child: InkWell(
          onTap: () async {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                    elevation: 0,
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 40)),
                        child: const Text("Close"),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                    content: SizedBox(
                      height: 250,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Column(
                        children: [
                          const Text(
                            'Product Owner',
                            style: TextStyle(fontSize: 30),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Text('Name: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                widget.owner.name,
                                style: const TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Text('Email: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Text(' ${widget.owner.email}',
                                    style: const TextStyle(fontSize: 17)),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Text('Phone: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        _makePhoneCall(widget.owner.phone);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            widget.owner.phone,
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
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Text('Total Product: ',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductOwnerDetail(
                                                  listProduct: listProduct,
                                                )));
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        '${listProduct.length}  (View More)',
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
                    )));
          },
          child: Column(children: [
            Row(
              children: [
                Text(
                  widget.owner.name,
                  style: const TextStyle(fontSize: 16),
                ),
                const Spacer(),
                Text('Total Product: ${listProduct.length}')
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text('Email: ${widget.owner.email}'),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text('Name: ${widget.owner.phone}'),
              ],
            )
          ])),
    );
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

// ignore_for_file: file_names, camel_case_types, must_be_immutable, use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:crm_mobile/customer/models/product/product_model.dart';
import 'package:crm_mobile/customer/pages/product/productDetail.dart';
import 'package:crm_mobile/customer/providers/product/product_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class productTab extends StatefulWidget {
  String wherecall;
  Function getListProductByCategory;
  Product product;
  UserObj user;
  productTab(
      {super.key,
      required this.product,
      required this.user,
      required this.getListProductByCategory,
      required this.wherecall});

  @override
  State<productTab> createState() => _productTabState();
}

class _productTabState extends State<productTab> {
  var f = NumberFormat("###,###,###.0#", "en_US");

  @override
  void initState() {
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
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: (widget.product.isSold || widget.product.isDelete)
                ? [Colors.grey, Colors.grey, Colors.grey]
                : [
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
          onTap: () async {
            OverlayLoadingProgress.start(context);
            await productProviders
                .fetchProductByProID(widget.product.id)
                .then((value) {
              OverlayLoadingProgress.stop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProductDetail(
                            user: widget.user,
                            wherecall: widget.wherecall,
                            product: value,
                          )));
            });
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
                  Positioned(
                    top: 150,
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 161, 159, 159)
                            .withOpacity(0),
                      ),
                      child: Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.eye),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${widget.product.noView}',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          const FaIcon(FontAwesomeIcons.heart),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(widget.product.noFavorite.toString(),
                              style: const TextStyle(fontSize: 20))
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 0.44,
                  child: AutoSizeText(
                    widget.product.name,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: AutoSizeText(
                    widget.product.productStatus,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),
              Row(children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: AutoSizeText(
                    '${f.format(widget.product.price)} VND',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width * 0.44,
                  child: Text(
                    (widget.product.isSold)
                        ? "Is Sold"
                        : (widget.product.isDelete)
                            ? 'Is deleted'
                            : '',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),
              Row(children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                      widget.product.district + ' ' + widget.product.province,
                      style: const TextStyle(fontSize: 16)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 0.22,
                  child: AutoSizeText(
                    maxLines: 1,
                    'Area: ${widget.product.area} m2',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ]),
            ],
          )),
    );
  }
}

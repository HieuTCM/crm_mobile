import 'package:crm_mobile/customer/models/product/product_model.dart';
import 'package:crm_mobile/customer/pages/product/productDetail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class productTab extends StatefulWidget {
  Product product;
  productTab({super.key, required this.product});

  @override
  State<productTab> createState() => _productTabState();
}

class _productTabState extends State<productTab> {
  var f = NumberFormat("###,###,###.0#", "en_US");
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(12)),
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProductDetail(
                          product: widget.product,
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
                      icon: const FaIcon(
                        FontAwesomeIcons.heart,
                        size: 30,
                        color: Colors.black,
                      ),
                      onPressed: () {},
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

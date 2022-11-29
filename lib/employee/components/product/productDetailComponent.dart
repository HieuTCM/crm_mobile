// ignore_for_file: file_names

import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ProductDetailComponent extends StatefulWidget {
  Product product;
  ProductDetailComponent({super.key, required this.product});

  @override
  State<ProductDetailComponent> createState() => _ProductDetailComponentState();
}

class _ProductDetailComponentState extends State<ProductDetailComponent> {
  @override
  Widget build(BuildContext context) {
    // String address = widget.product.street +
    //     ', ' +
    //     widget.product.district +
    //     ',  ' +
    //     widget.product.province;
    String address =
        '${(widget.product.street == null) ? '' : widget.product.street}, ${widget.product.district}, ${widget.product.province} ';
    var f = NumberFormat("###,###,###.0#", "en_US");
    var maxheight = MediaQuery.of(context).size.width * 0.91;
    String price = f.format(widget.product.price).toString();
    return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.58,
        maxChildSize: 0.9,
        minChildSize: 0.58,
        builder: (context, scrollController) => Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(
                  top: 5, left: 25, right: 25, bottom: 25),
              alignment: Alignment.topLeft,
              height: maxheight,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 60,
                          height: 7,
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              widget.product.name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: Text(
                              'Date: ${widget.product.updateDate.toString().substring(0, 10)}',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              address,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 70, 68, 68),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Type: ${widget.product.category.name} ',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 70, 68, 68),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Text('Price: $price VND',
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w500)))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Area: ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 70, 68, 68),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${widget.product.area}m2  (${widget.product.width}m x ${widget.product.length}m)',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 70, 68, 68),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.layerGroup, size: 15),
                          const Text(
                            '\tFloor: ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 70, 68, 68),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${widget.product.noFloor}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 70, 68, 68),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.33),
                          const FaIcon(FontAwesomeIcons.road, size: 15),
                          const Text(
                            '\tFacade: ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 70, 68, 68),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${widget.product.facade}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 70, 68, 68),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.toilet, size: 15),
                          const Text(
                            '\tToilet Room: ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 70, 68, 68),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${widget.product.noToilet}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 70, 68, 68),
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.22),
                          const FaIcon(FontAwesomeIcons.bed, size: 15),
                          const Text(
                            '\tBed Room: ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 70, 68, 68),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${widget.product.noBedroom}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 70, 68, 68),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.compass, size: 15),
                          const Text(
                            '\tDirection : ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            widget.product.direction,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const FaIcon(FontAwesomeIcons.squarePlus, size: 15),
                          const Text(
                            '\tUtilities : ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Expanded(
                            child: Text(
                              (widget.product.utilities) == null
                                  ? 'No'
                                  : widget.product.utilities,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
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
                          const Icon(Icons.chair, size: 15),
                          const Text(
                            '\tFurniture : ',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Expanded(
                            child: Text(
                              (widget.product.isFurniture) == true
                                  ? 'Yes'
                                  : 'No',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
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
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: SingleChildScrollView(
                          child: Text(
                            widget.product.description,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ]),
              ),
            ));
  }
}

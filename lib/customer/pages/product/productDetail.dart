import 'package:crm_mobile/customer/components/NavBar/navBar.dart';
import 'package:crm_mobile/customer/components/product/productDetailComponent.dart';
import 'package:crm_mobile/customer/models/product/product_model.dart';
import 'package:crm_mobile/customer/pages/root/mainPage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductDetail extends StatefulWidget {
  Product product;
  ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int _tabIndex = 0;

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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()));
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
                              color: const Color.fromARGB(255, 0, 137, 250)
                                  .withOpacity(0.6),
                              borderRadius: BorderRadius.circular(50)),
                          child: IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.heart,
                              size: 20,
                              color: Colors.white,
                            ),
                            onPressed: () {},
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(15),
              height: 50.0,
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
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
}

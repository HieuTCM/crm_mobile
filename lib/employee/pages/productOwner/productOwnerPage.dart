import 'package:crm_mobile/employee/components/NavBar/navBar.dart';
import 'package:crm_mobile/employee/components/productOwner/listOwnerComponent.dart';
import 'package:crm_mobile/employee/models/person/productOwner.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/providers/product/product_provider.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:crm_mobile/employee/providers/productOwner/productOwner_Provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class ProductOwnerPage extends StatefulWidget {
  const ProductOwnerPage({super.key});

  @override
  State<ProductOwnerPage> createState() => _ProductOwnerPageState();
}

class _ProductOwnerPageState extends State<ProductOwnerPage> {
  bool waiting = true;
  UserObj user = UserObj();
  List<Owner> listOwner = [];
  Map<String, String> mapParam = ({"pageNumber": "1", "pageSize": "6"});

  final TextEditingController _searchController = TextEditingController();

  int totalRow = 0;
  int pageNumber = 1;
  int pageCurrent = 1;

  int totalpage = 1;

  getListProductOwner(String searchValue) async {
    setState(() {
      waiting = true;
    });
    if (searchValue.isNotEmpty) {
      mapParam["searchString"] = searchValue;
    } else {
      mapParam.remove('searchString');
    }

    await OwnerProvider.fetchProductOwner(mapParam).then((value) {
      setState(() {
        listOwner = value;
        waiting = false;
        totalRow = value[0].totalRow;
        totalpage = totalRow ~/ 6;
        if (totalRow % 6 != 0) {
          totalpage++;
        }
      });
    });
  }

  @override
  void initState() {
    getListProductOwner('');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Product Owner'),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextField(
                      controller: _searchController,
                      autofocus: false,
                      decoration: InputDecoration(
                          hintText: "Search",
                          prefixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  pageCurrent = 1;
                                  mapParam.update(
                                      'pageNumber', (value) => value = '1');
                                });
                                getListProductOwner(_searchController.text);
                              },
                              icon: const Icon(Icons.search, size: 30),
                              color: Colors.black),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  pageCurrent = 1;
                                  _searchController.text = '';
                                  mapParam.update(
                                      'pageNumber', (value) => value = '1');
                                });
                                getListProductOwner('');
                              },
                              icon: const Icon(Icons.restart_alt_rounded,
                                  size: 30),
                              color: Colors.black)),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    alignment: Alignment.center,
                    child: const Text('Page: '),
                  ),
                  SizedBox(
                    child: DropdownButton2(
                      value: pageCurrent,
                      dropdownMaxHeight: 300,
                      items: List<int>.generate(
                              totalpage, (int index) => index + 1,
                              growable: true)
                          .map((e) => DropdownMenuItem(
                              value: e,
                              child: Container(
                                width: 70,
                                alignment: Alignment.center,
                                child: Text(e.toString()),
                              )))
                          .toList(),
                      onChanged: (value) {
                        setState(() async {
                          pageCurrent = value!;
                          mapParam.update('pageNumber',
                              (value) => value = pageCurrent.toString());
                          await getListProductOwner(_searchController.text);
                        });
                      },
                    ),
                  ),
                ],
              ),
              (waiting)
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : (listOwner.isEmpty)
                      ? const Expanded(
                          child: Center(child: Text('Product Owner not found')),
                        )
                      : listProductOwnerComp(
                          wherecall: 'SearchPage',
                          listOwner: listOwner,
                          user: user,
                          getListProductByCategory: getListProductOwner,
                        ),
              const SizedBox(
                height: 10,
              )
            ],
          )),
      // bottomNavigationBar: const NavBar(),
    );
  }
}

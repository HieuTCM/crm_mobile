// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, no_leading_underscores_for_local_identifiers, prefer_final_fields, unused_field

import 'package:crm_mobile/customer/components/NavBar/navBar.dart';
import 'package:crm_mobile/customer/components/product/listProductComponent.dart';
import 'package:crm_mobile/customer/models/person/userModel.dart';
import 'package:crm_mobile/customer/models/product/product_model.dart';
import 'package:crm_mobile/customer/providers/product/product_provider.dart';
import 'package:crm_mobile/customer/providers/product/search_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';

class SearchPage extends StatefulWidget {
  String SearchValue;
  SearchPage({super.key, required this.SearchValue});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool waiting = true;
  UserObj user = UserObj();
  List<Product> listProduct = [];
  List<String> listProvince = [];
  List<String> listDistrict = [];
  List<Sort> listSort = [];
  List<String> listStatus = [];

  String? provinceSelected;
  String? DistrictSelected;
  String? StatusSelected;
  Sort? SortSelected;

  bool issort = true;

  Map<String, String> mapParam = ({"pageNumber": "1", "pageSize": "5"});

  TextEditingController _searchController = TextEditingController();
  TextEditingController _minController = TextEditingController();
  TextEditingController _maxController = TextEditingController();

  String fillter = '';
  String provinde = '';
  String district = '';
  String price = '';
  String min = '';
  String max = '';

  String proStatus = '';
  String sort = '';

  int totalRow = 0;
  int pageNumber = 1;
  int pageCurrent = 1;

  int totalpage = 1;

  getListProductWith(String searchValue, String fillter, String sort) async {
    setState(() {
      mapParam.update('pageNumber', (value) => value = '1');
      pageCurrent = 1;
      waiting = true;
    });
    if (searchValue != 'MHjdLiT59asdyKu') {
      if (searchValue.isNotEmpty) {
        mapParam["searchString"] = searchValue;
      }
      if (provinde.isNotEmpty) {
        fillter = '$provinde$district';
        mapParam["filter"] = fillter;
      }
      if (sort.isNotEmpty) {
        mapParam["sort"] = '${SortSelected!.id};$issort';
      }
      if (min.isNotEmpty) {
        if (max.isNotEmpty) {
          if (fillter.isEmpty) {
            fillter = '3;$min,$max';
            mapParam["filter"] = fillter;
          } else {
            fillter = fillter + '&3;$min,$max';
            mapParam["filter"] = fillter;
          }
        }
      }
      if (proStatus.isNotEmpty) {
        if (fillter.isEmpty) {
          fillter = '15;$StatusSelected';
          mapParam["filter"] = fillter;
        } else {
          fillter = fillter + '&15;$StatusSelected';
          mapParam["filter"] = fillter;
        }
      }
    }

    await productProviders.fetchsearchProduct(mapParam).then((value) {
      setState(() {
        listProduct = value;
        waiting = false;
        totalRow = value[0].totalRow;
        totalpage = totalRow ~/ 5;
        if (totalRow % 5 != 0) {
          totalpage++;
        }
      });
    });
  }

  getListProduct(String searchValue, String fillter, String sort) async {
    setState(() {
      waiting = true;
    });
    if (searchValue != 'MHjdLiT59asdyKu') {
      if (searchValue.isNotEmpty) {
        mapParam["searchString"] = searchValue;
      }
    }
    await productProviders.fetchsearchProduct(mapParam).then((value) {
      setState(() {
        listProduct = value;
        waiting = false;
        totalRow = value[0].totalRow;
        totalpage = totalRow ~/ 5;
        if (totalRow % 5 != 0) {
          totalpage++;
        }
      });
    });
  }

  getListProvince() async {
    await searchProvider.fetchAllProvince().then((value) {
      setState(() {
        listProvince = value;
      });
    });
  }

  getListStatus() async {
    await productProviders.fetchProductStatus().then((value) {
      setState(() {
        listStatus = value;
      });
    });
  }

  getListSort() async {
    await searchProvider.fetchAllSortType().then((value) {
      setState(() {
        listSort = value;
      });
    });
  }

  getListDistrict(String value) async {
    await searchProvider.fetchAllDistrict(value).then((value) {
      setState(() {
        listDistrict = value;
      });
    });
  }

  @override
  void initState() {
    _searchController.text = widget.SearchValue;
    getListProvince();
    getListSort();
    getListStatus();
    getListProductWith(_searchController.text, fillter, sort);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var maxheight = MediaQuery.of(context).size.width * 0.5;
    return Scaffold(
      appBar: AppBar(title: const Text('Search'), actions: [
        Container(
          alignment: Alignment.center,
          child: const Text('Page: '),
        ),
        SizedBox(
          child: DropdownButton2(
            value: pageCurrent,
            dropdownMaxHeight: 300,
            items: List<int>.generate(totalpage, (int index) => index + 1,
                    growable: true)
                .map((e) => DropdownMenuItem(
                    value: e,
                    child: Container(
                      width: 30,
                      alignment: Alignment.center,
                      child: Text(e.toString()),
                    )))
                .toList(),
            onChanged: (value) {
              setState(() async {
                pageCurrent = value!;
                mapParam.update(
                    'pageNumber', (value) => value = pageCurrent.toString());
                await getListProduct(_searchController.text, fillter, sort);
              });
            },
          ),
        ),
        SizedBox(
          width: 10,
        )
      ]),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: maxheight,
              child: Column(children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 12),
                      width: MediaQuery.of(context).size.width * 0.69,
                      child: TextField(
                        autofocus: false,
                        controller: _searchController,
                        decoration: const InputDecoration(
                            hintText: "Search",
                            prefixIcon:
                                Icon(Icons.search, color: Colors.black)),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: IconButton(
                        icon: const Icon(Icons.search, size: 35),
                        onPressed: () {
                          getListProductWith(
                              _searchController.text, fillter, sort);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: IconButton(
                        icon: const Icon(Icons.restart_alt, size: 35),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage(
                                        SearchValue: _searchController.text,
                                      )));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Row(children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.53,
                        child: Row(
                          children: [
                            const Text('Province'),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              child: DropdownButton2(
                                hint: const Text(' Province'),
                                value: provinceSelected,
                                dropdownMaxHeight: 300,
                                items: listProvince
                                    .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          alignment: Alignment.center,
                                          child: Text(e),
                                        )))
                                    .toList(),
                                onChanged: (value) async {
                                  setState(() {
                                    provinde = '13;$value';
                                    provinceSelected = value;
                                    getListDistrict(value.toString());
                                  });
                                },
                              ),
                            ),
                          ],
                        )),
                    const Spacer(),
                    Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Row(
                          children: [
                            const Text('District'),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              child: DropdownButton2(
                                hint: const Text(' District'),
                                value: DistrictSelected,
                                dropdownMaxHeight: 300,
                                items: listDistrict
                                    .map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Container(
                                          width: 80,
                                          alignment: Alignment.center,
                                          child: Text(
                                            e.toString(),
                                            style:
                                                const TextStyle(fontSize: 14),
                                          ),
                                        )))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    district = '&14;$value';
                                    DistrictSelected = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        )),
                  ]),
                ),
                const SizedBox(
                  height: 7,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Row(children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Row(
                          children: [
                            const Text('Price'),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              // padding: const EdgeInsets.only(left: 5),
                              width: MediaQuery.of(context).size.width * 0.38,
                              child: TextField(
                                  autofocus: false,
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        if (value == '') {
                                          _maxController.clear();
                                        } else {
                                          value =
                                              '${_formatNumber(value.replaceAll(',', ''))}';
                                          _minController.value =
                                              TextEditingValue(
                                            text: value,
                                            selection: TextSelection.collapsed(
                                                offset: value.length),
                                          );
                                          min = _minController.text
                                              .replaceAll(',', '');
                                        }
                                      },
                                    );
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: _minController,
                                  decoration: const InputDecoration(
                                    hintText: "Min",
                                  )),
                            ),
                            const Text('\t - \t'),
                            Container(
                              // padding: const EdgeInsets.only(left: 12),
                              width: MediaQuery.of(context).size.width * 0.38,
                              child: TextField(
                                  autofocus: false,
                                  enabled: (_minController.text.isNotEmpty),
                                  onChanged: (value) {
                                    setState(
                                      () {
                                        if (value != '') {
                                          value =
                                              '${_formatNumber(value.replaceAll(',', ''))}';
                                          _maxController.value =
                                              TextEditingValue(
                                            text: value,
                                            selection: TextSelection.collapsed(
                                                offset: value.length),
                                          );
                                          max = _maxController.text
                                              .replaceAll(',', '');
                                        }
                                      },
                                    );
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: _maxController,
                                  decoration: InputDecoration(
                                    errorText: (_minController.text.isEmpty)
                                        ? null
                                        : (_maxController.text.isEmpty)
                                            ? 'Input Max Price'
                                            : (double.parse(_maxController.text
                                                        .replaceAll(',', '')) <
                                                    double.parse(_minController
                                                        .text
                                                        .replaceAll(',', '')))
                                                ? 'Max must not less than Min'
                                                : null,
                                    hintText: "Max",
                                  )),
                            ),
                          ],
                        )),
                  ]),
                ),
                SizedBox(
                  height: 7,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: const Text('SortBy: '),
                      ),
                      SizedBox(
                        child: DropdownButton2(
                          value: SortSelected,
                          hint: const Text('Sort by '),
                          dropdownMaxHeight: 300,
                          items: listSort
                              .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Container(
                                    width: 100,
                                    alignment: Alignment.center,
                                    child: Text(e.name),
                                  )))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              SortSelected = value;
                              sort = value!.name;
                            });
                          },
                        ),
                      ),
                      const Spacer(),
                      Container(
                        alignment: Alignment.center,
                        child: const Text('Type: '),
                      ),
                      FlutterSwitch(
                        showOnOff: true,
                        activeTextColor: Colors.black,
                        inactiveTextColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        activeText: 'Asc',
                        inactiveText: 'Des',
                        value: issort,
                        onToggle: (val) {
                          setState(() {
                            issort = val;
                          });
                        },
                      ),
                      const Spacer()
                    ],
                  ),
                )
              ]),
            ),
            SizedBox(
              height: 22,
            ),
            const Divider(
              height: 15,
              thickness: 2,
            ),
            Container(
              child: (waiting)
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : (listProduct[0].id == null)
                      ? const Expanded(
                          child: Center(child: Text('Product not found')),
                        )
                      : listProductComp(
                          wherecall: 'SearchPage',
                          listProduct: listProduct,
                          user: user,
                          getListProductByCategory: getListProductWith,
                        ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: const NavBar(),
    );
  }

  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
}

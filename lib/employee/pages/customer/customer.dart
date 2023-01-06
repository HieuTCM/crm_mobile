import 'package:crm_mobile/employee/components/customer/listCustomerComponent.dart';
import 'package:crm_mobile/employee/models/customer/customer_model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/providers/customer/customer_provider.dart';
import 'package:crm_mobile/employee/providers/user/user_Provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  bool waiting = true;
  UserObj user = UserObj();
  List<CustomerModel> listCustomer = [];

  Map<String, String> mapParam = ({"pageNumber": "1", "pageSize": "6"});
  final TextEditingController _searchController = TextEditingController();

  int totalRow = 0;
  int pageNumber = 1;
  int pageCurrent = 1;
  int totalpage = 1;

  getUserinfo() async {
    userProviders.fetchUserInfor().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  getListCustomer() async {
    setState(() {
      waiting = true;
      mapParam["sort"] = '1;false';
    });
    await CustomerProvider.fetchCustomer(mapParam).then((value) {
      setState(() {
        listCustomer = value;
        waiting = false;
        totalRow = value[0].totalRow;
        totalpage = totalRow ~/ 6;
        if (totalRow % 6 != 0) {
          totalpage++;
        }
      });
    });
  }

  getListCustomerBysearch(String searchValue) async {
    setState(() {
      waiting = true;
      mapParam["sort"] = '1;false';
    });
    if (searchValue.isNotEmpty) {
      mapParam["searchString"] = searchValue;
    } else {
      mapParam.remove('searchString');
    }

    await CustomerProvider.fetchCustomer(mapParam).then((value) {
      setState(() {
        listCustomer = value;
        waiting = false;
        totalRow = value[0].totalRow;
        totalpage = totalRow ~/ 6;
        if (totalRow % 6 != 0) {
          totalpage++;
        }
      });
    });
  }

  String? filterSelected;

  @override
  void initState() {
    getUserinfo();
    getListCustomer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Customer Page')),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
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
                              width: 100,
                              alignment: Alignment.center,
                              child: Text(e.toString()),
                            )))
                        .toList(),
                    onChanged: (value) {
                      setState(() async {
                        pageCurrent = value!;
                        mapParam.update('pageNumber',
                            (value) => value = pageCurrent.toString());
                        await getListCustomerBysearch(_searchController.text);
                      });
                    },
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.only(left: 12),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                pageCurrent = 1;
                                mapParam.update(
                                    'pageNumber', (value) => value = '1');
                              });
                              getListCustomerBysearch(_searchController.text);
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
                              getListCustomerBysearch('');
                            },
                            icon:
                                const Icon(Icons.restart_alt_rounded, size: 30),
                            color: Colors.black)),
                  ),
                ),
              ],
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.75,
                margin: const EdgeInsets.all(12),
                child: (waiting)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : (listCustomer.isEmpty || listCustomer[0].id == 'NotFound')
                        ? const Center(
                            child: Text('Customer not found'),
                          )
                        : listCustomerComp(
                            listCustomer: listCustomer,
                            user: user,
                          ))
          ]),
        ));
  }
}

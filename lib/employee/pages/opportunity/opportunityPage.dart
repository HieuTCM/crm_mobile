import 'package:crm_mobile/employee/components/lead/leadTab.dart';
import 'package:crm_mobile/employee/components/opportunity/opportunityTab.dart';
import 'package:crm_mobile/employee/models/opportunity/opportunityModel.dart';
import 'package:crm_mobile/employee/providers/lead/lead_provider.dart';
import 'package:crm_mobile/employee/providers/opportunity/opportunity_Provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class OpportunityPage extends StatefulWidget {
  OpportunityPage({super.key});

  @override
  State<OpportunityPage> createState() => _OpportunityPageState();
}

class _OpportunityPageState extends State<OpportunityPage> {
  List<Opportunity> listOpportunity = [];
  bool Waiting = true;

  Map<String, String> mapParam = ({"pageNumber": "1", "pageSize": "6"});
  final TextEditingController _searchController = TextEditingController();

  int totalRow = 0;
  int pageNumber = 1;
  int pageCurrent = 1;
  int totalpage = 1;

  getOpportunity(String searchValue) async {
    setState(() {
      Waiting = true;
      mapParam["sort"] = '1;false';
    });
    if (searchValue.isNotEmpty) {
      mapParam["searchString"] = searchValue;
    } else {
      mapParam.remove('searchString');
    }

    await OpportunityProviders.fetchAllOpportunity(mapParam).then((value) {
      setState(() {
        listOpportunity = value;
        Waiting = false;
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
    getOpportunity('');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Opportunity Page')),
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
                        await getOpportunity(_searchController.text);
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
                              getOpportunity(_searchController.text);
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
                              getOpportunity('');
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
              child: (Waiting)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: listOpportunity.length,
                      itemBuilder: (context, index) {
                        return OpportunityTab(
                            opportunity: listOpportunity[index]);
                      },
                    ),
            )
          ]),
        ));
  }
}

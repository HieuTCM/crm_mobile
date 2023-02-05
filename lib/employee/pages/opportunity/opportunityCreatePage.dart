// ignore_for_file: prefer_final_fields, camel_case_types

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_mobile/employee/models/opportunity/opportunityModel.dart';
import 'package:crm_mobile/employee/pages/opportunity/opportunityPage.dart';
import 'package:crm_mobile/employee/providers/lead/lead_provider.dart';
import 'package:crm_mobile/employee/providers/opportunity/opportunity_Provider.dart';
import 'package:crm_mobile/employee/providers/product/product_provider.dart';
import 'package:crm_mobile/employee/models/person/leadModel.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:xen_popup_card/xen_card.dart';

class opportunityCreatePage extends StatefulWidget {
  const opportunityCreatePage({super.key});

  @override
  State<opportunityCreatePage> createState() => _opportunityCreatePageState();
}

class _opportunityCreatePageState extends State<opportunityCreatePage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var f = NumberFormat("###,###,###.0#", "en_US");

  String? DescriptionRequest;
  String? validDes;
  String leadId = '';
  bool styleSearch = true;

  List<productEnum> AllProEnum = [];
  List<productEnum> ProEnumSearch = [];
  bool proSearch = false;
  TextEditingController _ProSearchController = TextEditingController();

  List<LeadEnum> AllLeadEnum = [];
  List<LeadEnum> LeadEnumSearch = [];
  bool leadSearch = false;
  TextEditingController _LeadSearchController = TextEditingController();

  getProEnum() async {
    setState(() {
      proSearch = true;
    });

    await productProviders.fetchAllProductEnum().then((value) {
      setState(() {
        AllProEnum = value;
        proSearch = false;
        ProEnumSearch = AllProEnum;
      });
    });
  }

  getLeadEnum() async {
    setState(() {
      leadSearch = true;
    });

    await LeadProvider.fetchAllLeadEnum().then((value) {
      setState(() {
        AllLeadEnum = value;
        leadSearch = false;
        LeadEnumSearch = AllLeadEnum;
      });
    });
  }

  searchLeadbyPhone(String search, StateSetter setState) {
    List<LeadEnum> _result = [];
    if (search.isEmpty) {
      _result = AllLeadEnum;
    } else {
      _result = AllLeadEnum.where((lead) => lead.phone
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase())).toList();
    }
    setState(() {
      LeadEnumSearch = _result;
    });
  }

  searchLeadbyName(String search, StateSetter setState) {
    List<LeadEnum> _result = [];
    if (search.isEmpty) {
      _result = AllLeadEnum;
    } else {
      _result = AllLeadEnum.where((lead) =>
              lead.name.toString().toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    setState(() {
      LeadEnumSearch = _result;
    });
  }

  searchProbyName(String search, StateSetter setState) {
    List<productEnum> _result = [];
    if (search.isEmpty) {
      _result = AllProEnum;
    } else {
      _result = AllProEnum.where((pro) =>
              pro.name.toString().toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    setState(() {
      ProEnumSearch = _result;
    });
  }

  searchProbyOwnerPhone(String search, StateSetter setState) {
    List<productEnum> _result = [];
    if (search.isEmpty) {
      _result = AllProEnum;
    } else {
      _result = AllProEnum.where((pro) => pro.ownerPhone
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase())).toList();
    }
    setState(() {
      ProEnumSearch = _result;
    });
  }

  @override
  void initState() {
    getProEnum();
    getLeadEnum();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Opportunity Create Page')),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Container(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text('Opportunity Name : ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: TextField(
                      autofocus: false,
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Opportunity Name",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: const [
                  Text('Opportunity Description : ',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 12),
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  autofocus: false,
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  onChanged: (value) {
                    setState(() {
                      validDes = validateDes(value);
                      DescriptionRequest =
                          value.replaceAll(RegExp('\n'), r' \n');
                    });
                  },
                  decoration: InputDecoration(
                      errorText: validDes,
                      hintText: "Enter Description",
                      border: const OutlineInputBorder(),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Color.fromARGB(255, 0, 0, 0)))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: const Text('Lead : ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                  const Spacer(),
                  (lead.id != null)
                      ? InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: ((context, setState) =>
                                          XenPopupCard(
                                              body: Container(
                                                  child:
                                                      LeadPopup(setState)))));
                                });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.09,
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(children: [
                              Row(
                                children: [
                                  const Text(
                                    'Name: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(lead.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ))
                                ],
                              ),
                              Row(
                                children: [
                                  const Text('Phone: ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500)),
                                  Text(lead.phone,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ))
                                ],
                              ),
                            ]),
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ElevatedButton(
                              onPressed: () {
                                (leadSearch)
                                    ? Fluttertoast.showToast(
                                        msg: 'Loading list lead ...',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0)
                                    : showDialog(
                                        context: context,
                                        builder: (context) {
                                          return StatefulBuilder(
                                              builder: ((context, setState) =>
                                                  XenPopupCard(
                                                      body: Container(
                                                          child: LeadPopup(
                                                              setState)))));
                                        });
                              },
                              child: (leadSearch)
                                  ? const Text('Loading...')
                                  : const Text('Choose Lead'))),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: const Text('Product : ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                  const Spacer(),
                  (pro.id != null)
                      ? InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                    builder: ((context, setState) =>
                                        XenPopupCard(
                                            body: ProPopup(setState)))));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.25,
                            margin: const EdgeInsets.all(5),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(children: [
                              Row(
                                children: [
                                  const Text(
                                    'Name: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                      // width: MediaQuery.of(context).size.width * 0.48,
                                      child: AutoSizeText(pro.name,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          )))
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  const Text(
                                    'Address: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                      // width: MediaQuery.of(context).size.width * 0.45,
                                      child: AutoSizeText(pro.address,
                                          maxLines: 2,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ))),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  const Text(
                                    'Price: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text("${f.format(pro.price)}  VND",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ))
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  const Text(
                                    'Owner\'s Name: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Expanded(
                                      // width: MediaQuery.of(context).size.width * 0.32,
                                      child: AutoSizeText(pro.ownerName,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ))),
                                ],
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  const Text(
                                    'Owner\'s Phone: ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(pro.ownerPhone,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ))
                                ],
                              ),
                            ]),
                          ))
                      : SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ElevatedButton(
                              onPressed: () {
                                (proSearch)
                                    ? Fluttertoast.showToast(
                                        msg: 'Loading list Product ...',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0)
                                    : showDialog(
                                        context: context,
                                        builder: (context) => StatefulBuilder(
                                            builder: ((context, setState) =>
                                                XenPopupCard(
                                                    body:
                                                        ProPopup(setState)))));
                              },
                              child: (proSearch)
                                  ? const Text('Loading...')
                                  : const Text('Choose Product'))),
                  const Spacer(),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      if (validateDes(_descriptionController.text.toString()) !=
                              null ||
                          _nameController.text.toString() == '' ||
                          lead.id == null ||
                          pro.id == null) {
                        Fluttertoast.showToast(
                            msg: 'Can\'t Create a new Opportunity',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        Opportunity opp = Opportunity(
                            totalRow: 1,
                            name: _nameController.text.toString(),
                            description: _descriptionController.text.toString(),
                            leadId: lead.id,
                            productId: pro.id);
                        OpportunityProviders.insOpportunity(opp).then((value) {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OpportunityPage()));
                        });
                      }
                    },
                    child: const Text('Create Opportunity')),
              )
            ],
          ))),
    );
  }

  String? validateDes(String value) {
    if (value.isEmpty) {
      return 'Enter your Description';
    } else if (value.length < 3) {
      return 'Description more than 3 characters';
    } else if (value.length >= 50) {
      return 'Description no more than 50 characters';
    } else {
      return null;
    }
  }

  Widget LeadPopup(StateSetter setState) {
    return Column(
      children: [
        Row(
          children: [
            const Text('Search: '),
            Expanded(
              child: TextField(
                autofocus: false,
                onChanged: (value) {
                  (styleSearch)
                      ? searchLeadbyName(value, setState)
                      : searchLeadbyPhone(value, setState);
                },
                controller: _LeadSearchController,
                decoration: InputDecoration(
                  hintText: (styleSearch) ? "Lead's Name" : "Lead's Phone",
                ),
              ),
            ),
            FlutterSwitch(
              width: 85,
              showOnOff: true,
              activeTextColor: Colors.black,
              inactiveTextColor: const Color.fromARGB(255, 255, 255, 255),
              activeText: 'Name',
              inactiveText: 'Phone',
              value: styleSearch,
              onToggle: (val) {
                setState(() {
                  styleSearch = !styleSearch;
                });
              },
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6,
          margin: const EdgeInsets.all(12),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: LeadEnumSearch.length,
              itemBuilder: (context, index) {
                LeadEnum lead = LeadEnumSearch[index];
                return InkWell(
                    onTap: () {
                      getLead(lead);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.09,
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(children: [
                        Row(
                          children: [
                            const Text(
                              'Name: ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Text(lead.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            const Text('Phone: ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                            Text(lead.phone,
                                style: const TextStyle(
                                  fontSize: 16,
                                ))
                          ],
                        ),
                      ]),
                    ));
              }),
        )
      ],
    );
  }

  Widget ProPopup(StateSetter setState) {
    return Column(
      children: [
        Row(
          children: [
            const Text('Search: '),
            Expanded(
              child: TextField(
                autofocus: false,
                onChanged: (value) {
                  (styleSearch)
                      ? searchProbyName(value, setState)
                      : searchProbyOwnerPhone(value, setState);
                },
                controller: _LeadSearchController,
                decoration: InputDecoration(
                  hintText: (styleSearch) ? "Product's Name" : "Owner's Phone",
                ),
              ),
            ),
            FlutterSwitch(
              width: 85,
              showOnOff: true,
              activeTextColor: Colors.black,
              inactiveTextColor: const Color.fromARGB(255, 255, 255, 255),
              activeText: 'Name',
              inactiveText: 'Phone',
              value: styleSearch,
              onToggle: (val) {
                setState(() {
                  styleSearch = !styleSearch;
                });
              },
            ),
          ],
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6,
          margin: const EdgeInsets.all(12),
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: ProEnumSearch.length,
              itemBuilder: (context, index) {
                productEnum pro = ProEnumSearch[index];
                return InkWell(
                    onTap: () {
                      getPro(pro);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.25,
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(children: [
                        Row(
                          children: [
                            const Text(
                              'Name: ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                                // width: MediaQuery.of(context).size.width * 0.48,
                                child: AutoSizeText(pro.name,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    )))
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Text(
                              'Address: ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                                // width: MediaQuery.of(context).size.width * 0.45,
                                child: AutoSizeText(pro.address,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ))),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Text(
                              'Price: ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Text("${f.format(pro.price)}  VND",
                                style: const TextStyle(
                                  fontSize: 16,
                                ))
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Text(
                              'Owner\'s Name: ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Expanded(
                                // width: MediaQuery.of(context).size.width * 0.32,
                                child: AutoSizeText(pro.ownerName,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ))),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Text(
                              'Owner\'s Phone: ',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            Text(pro.ownerPhone,
                                style: const TextStyle(
                                  fontSize: 16,
                                ))
                          ],
                        ),
                      ]),
                    ));
              }),
        )
      ],
    );
  }

  LeadEnum lead = LeadEnum();
  getLead(LeadEnum data) {
    setState((() {
      lead = data;
    }));
    Navigator.pop(context);
  }

  productEnum pro = productEnum();
  getPro(productEnum data) {
    setState((() {
      pro = data;
    }));
    Navigator.pop(context);
  }
}

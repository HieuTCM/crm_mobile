// ignore_for_file: unnecessary_string_interpolations

import 'package:crm_mobile/employee/components/lead/leadDetailComp.dart';
import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/models/person/leadModel.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:crm_mobile/employee/models/opportunity/opportunityModel.dart';
import 'package:crm_mobile/employee/pages/product/productDetail.dart';
import 'package:crm_mobile/employee/providers/appointment/appointment_provider.dart';
import 'package:crm_mobile/employee/providers/lead/lead_provider.dart';
import 'package:crm_mobile/employee/providers/opportunity/opportunity_Provider.dart';
import 'package:crm_mobile/employee/providers/product/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xen_popup_card/xen_card.dart';

class OpportunityDetail extends StatefulWidget {
  Opportunity opportunity;
  OpportunityDetail({super.key, required this.opportunity});

  @override
  State<OpportunityDetail> createState() => _OpportunityDetailState();
}

class _OpportunityDetailState extends State<OpportunityDetail> {
  List<Product> listpro = [];
  List<Opportunity> listopp = [];
  List<Lead> listLead = [];
  List<Appointment> listAppointments = [];
  List<LeadStatus> listLeadStatus = [];

  List<OpportunityStatus> listOpportunityStatus = [];
  List<LostReason> listLostReason = [];

  TextEditingController _depositController = TextEditingController();
  TextEditingController _negotiationController = TextEditingController();

  getListOpportunityStatus() async {
    await OpportunityProviders.fetchListOpportunityStatus().then((value) {
      setState(() {
        listOpportunityStatus = value;
      });
    });
  }

  getListLostReason() async {
    await OpportunityProviders.fetchListLostReason().then((value) {
      setState(() {
        listLostReason = value;
      });
    });
  }

  updateStatusOpp(String id, int statusID) async {
    OverlayLoadingProgress.start(context);
    await OpportunityProviders.updOpportunityStatus(id, statusID).then((value) {
      OverlayLoadingProgress.stop(context);
      if (statusID == 7) {
        showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
                builder: ((context, setState) => AlertDialog(
                    title: Text("Lost Reason"),
                    content: Container(
                      width: 300,
                      height: 200,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listLostReason.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(5),
                              height: 50,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.circular(12)),
                              child: InkWell(
                                onTap: () {
                                  OverlayLoadingProgress.start(context);
                                  Map<String, dynamic> value =
                                      Map<String, dynamic>();
                                  value['id'] = widget.opportunity.id;
                                  value['lostReason'] =
                                      listLostReason[index].id;
                                  OpportunityProviders.updOpportunity(id, value)
                                      .then((value) {
                                    OverlayLoadingProgress.stop(context);
                                    Navigator.pop(context);
                                    getOpportunity(widget.opportunity.id);
                                    Fluttertoast.showToast(
                                        msg: "Update Lost Reason ${value}",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                        '${listLostReason[index].id} . ${listLostReason[index].status}')
                                  ],
                                ),
                              ),
                            );
                          }),
                    )))));
      } else {
        Navigator.pop(context);
        getOpportunity(widget.opportunity.id);
      }
    });
  }

  getProbyId(String id) async {
    await productProviders.fetchProductByProID(id).then((value) {
      setState(() {
        listpro.add(value);
      });
    });
  }

  updOpportunity(String id, int value, String type) async {
    OverlayLoadingProgress.start(context);
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = widget.opportunity.id;
    data[type] = value;
    OpportunityProviders.updOpportunity(id, data).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      getOpportunity(widget.opportunity.id);
      OverlayLoadingProgress.stop(context);
    });
  }

  getOpportunity(String id) async {
    await OpportunityProviders.fetchOpportunitybyID(widget.opportunity.id)
        .then((value) {
      setState(() {
        listopp.add(value);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => OpportunityDetail(
                      opportunity: listopp[0],
                    )));
      });
    });
  }

  getLeadbyId(String id) async {
    await LeadProvider.fetchLeadByID(id).then((value) {
      setState(() {
        listLead.add(value);
      });
    });
  }

  getListAppointment(String id) async {
    await appointmentProvider.fetchAppointmentsByLeadId(id).then((value) {
      setState(() {
        listAppointments = value;
      });
    });
  }

  getListLeadStatus() async {
    await LeadProvider.fetchListLeadStatus().then((value) {
      setState(() {
        listLeadStatus = value;
      });
    });
  }

  @override
  void initState() {
    getProbyId(widget.opportunity.productId);
    getLeadbyId(widget.opportunity.leadId);
    getListAppointment(widget.opportunity.leadId);
    getListLeadStatus();
    getListLostReason();
    getListOpportunityStatus();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.parse(s));
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  @override
  Widget build(BuildContext context) {
    var f = NumberFormat("###,###,###.0#", "en_US");
    return Scaffold(
        appBar: AppBar(title: const Text('Opportunity Detail Page')),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Opportunity Detail: ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      (widget.opportunity.opportunityStatus == 'Lost')
                          ? IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit_sharp,
                                size: 30,
                                color: Colors.grey,
                              ))
                          : IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => StatefulBuilder(
                                        builder: ((context, setState) =>
                                            AlertDialog(
                                                title: const Text(
                                                    "Edit Opportunity"),
                                                content: Container(
                                                  width: 300,
                                                  height: 150,
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        InkWell(
                                                          onTap: (() {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (context) => StatefulBuilder(
                                                                    builder: ((context, setState) => AlertDialog(
                                                                        title: const Text("Update Deposit"),
                                                                        content: Container(
                                                                          width:
                                                                              300,
                                                                          height:
                                                                              120,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: const [
                                                                                  Text('Price : ')
                                                                                ],
                                                                              ),
                                                                              Container(
                                                                                // padding: const EdgeInsets.only(left: 12),
                                                                                width: MediaQuery.of(context).size.width,
                                                                                child: TextField(
                                                                                  onChanged: (value) {
                                                                                    setState(
                                                                                      () {
                                                                                        value = '${_formatNumber(value.replaceAll(',', ''))}';
                                                                                        _depositController.value = TextEditingValue(
                                                                                          text: value,
                                                                                          selection: TextSelection.collapsed(offset: value.length),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  keyboardType: TextInputType.number,
                                                                                  controller: _depositController,
                                                                                  decoration: const InputDecoration(
                                                                                    suffixText: 'VNĐ',
                                                                                    // prefixText: 'VNĐ',
                                                                                    hintText: "Deposit",
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Spacer(),
                                                                                  ElevatedButton(
                                                                                    onPressed: () {
                                                                                      (_depositController.text.isEmpty) ? null : updOpportunity(widget.opportunity.id, int.parse(_depositController.text.replaceAll(',', '')), 'deposit');
                                                                                    },
                                                                                    child: const Text("Save"),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )))));
                                                          }),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .blue)),
                                                            child: Row(
                                                                children: const [
                                                                  Text(
                                                                      'Update Deposit'),
                                                                  Spacer(),
                                                                  Icon(Icons
                                                                      .subdirectory_arrow_right_rounded)
                                                                ]),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        InkWell(
                                                          onTap: (() {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (context) => StatefulBuilder(
                                                                    builder: ((context, setState) => AlertDialog(
                                                                        title: const Text("Update Negotiation Price"),
                                                                        content: Container(
                                                                          width:
                                                                              300,
                                                                          height:
                                                                              120,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: const [
                                                                                  Text('Price : ')
                                                                                ],
                                                                              ),
                                                                              Container(
                                                                                // padding: const EdgeInsets.only(left: 12),
                                                                                width: MediaQuery.of(context).size.width,
                                                                                child: TextField(
                                                                                  onChanged: (value) {
                                                                                    setState(
                                                                                      () {
                                                                                        value = '${_formatNumber(value.replaceAll(',', ''))}';
                                                                                        _negotiationController.value = TextEditingValue(
                                                                                          text: value,
                                                                                          selection: TextSelection.collapsed(offset: value.length),
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  keyboardType: TextInputType.number,
                                                                                  controller: _negotiationController,
                                                                                  decoration: const InputDecoration(
                                                                                    suffixText: 'VNĐ',
                                                                                    // prefixText: 'VNĐ',
                                                                                    hintText: "Negotiation",
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  const Spacer(),
                                                                                  ElevatedButton(
                                                                                    onPressed: () {
                                                                                      (_negotiationController.text.isEmpty) ? null : updOpportunity(widget.opportunity.id, int.parse(_negotiationController.text.replaceAll(',', '')), 'negotiationPrice');
                                                                                    },
                                                                                    child: const Text("Save"),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )))));
                                                          }),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: Colors
                                                                        .blue)),
                                                            child: Row(
                                                                children: const [
                                                                  Text(
                                                                      'Update Negotiation Price'),
                                                                  Spacer(),
                                                                  Icon(Icons
                                                                      .subdirectory_arrow_right_rounded)
                                                                ]),
                                                          ),
                                                        )
                                                      ]),
                                                )))));
                              },
                              icon: const Icon(
                                Icons.edit_sharp,
                                size: 30,
                                color: Colors.blue,
                              ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Name: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(widget.opportunity.name)
                        ],
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Create Date: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(widget.opportunity.createDate)
                        ],
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Padding(
                        padding:
                            (widget.opportunity.lostReason.toString().isEmpty)
                                ? const EdgeInsets.only(bottom: 0)
                                : const EdgeInsets.only(bottom: 7),
                        child:
                            (widget.opportunity.lostReason.toString().isEmpty)
                                ? const SizedBox()
                                : (Row(
                                    children: [
                                      const Text(
                                        'Sale Closing Date: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(widget.opportunity.lostReason)
                                    ],
                                  )),
                      ),
                      Row(
                        children: [
                          const Text(
                            'Description: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(widget.opportunity.description)
                        ],
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Status: ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          Text(widget.opportunity.opportunityStatus)
                        ],
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Padding(
                        padding: (widget.opportunity.listedPrice == 0)
                            ? const EdgeInsets.only(bottom: 0)
                            : const EdgeInsets.only(bottom: 7),
                        child: (widget.opportunity.listedPrice == 0)
                            ? const SizedBox()
                            : Row(
                                children: [
                                  const Text(
                                    'Listed Price: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                      '${f.format(widget.opportunity.listedPrice)} VND')
                                ],
                              ),
                      ),
                      Padding(
                        padding: (widget.opportunity.negotiationPrice == 0)
                            ? const EdgeInsets.only(bottom: 0)
                            : const EdgeInsets.only(bottom: 7),
                        child: (widget.opportunity.negotiationPrice == 0)
                            ? const SizedBox()
                            : Row(
                                children: [
                                  const Text(
                                    'Negotiation Price: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                      '${f.format(widget.opportunity.negotiationPrice)} VND')
                                ],
                              ),
                      ),
                      Padding(
                        padding: (widget.opportunity.lastPrice == 0)
                            ? const EdgeInsets.only(bottom: 0)
                            : const EdgeInsets.only(bottom: 7),
                        child: (widget.opportunity.lastPrice == 0)
                            ? const SizedBox()
                            : Row(
                                children: [
                                  const Text(
                                    'Last Price: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                      '${f.format(widget.opportunity.lastPrice)} VND')
                                ],
                              ),
                      ),
                      Padding(
                        padding: (widget.opportunity.deposit.toString().isEmpty)
                            ? const EdgeInsets.only(bottom: 0)
                            : const EdgeInsets.only(bottom: 7),
                        child: (widget.opportunity.deposit == 0)
                            ? const SizedBox()
                            : Row(
                                children: [
                                  const Text(
                                    'Deposit: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                      '${f.format(widget.opportunity.deposit)} VND')
                                ],
                              ),
                      ),
                      Padding(
                        padding:
                            (widget.opportunity.lostReason.toString().isEmpty)
                                ? const EdgeInsets.only(bottom: 0)
                                : const EdgeInsets.only(bottom: 7),
                        child:
                            (widget.opportunity.lostReason.toString().isEmpty)
                                ? const SizedBox()
                                : Row(
                                    children: [
                                      const Text(
                                        'Lost Reason: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(widget.opportunity.lostReason)
                                    ],
                                  ),
                      ),
                    ],
                  ),
                  const Text('Product Detail: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 7,
                  ),
                  (listpro.isEmpty)
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProductDetail(
                                              product: listpro[0],
                                              wherecall: 'AppointmentView',
                                            )));
                              },
                              child: Container(
                                alignment: Alignment.topCenter,
                                width: MediaQuery.of(context).size.width * 0.95,
                                height: 200.0,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        listpro[0].listImg[0].url,
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "${listpro[0].name} ",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 7,
                            ),
                            Row(
                              children: [
                                Text(
                                  "${f.format(listpro[0].price)}  VND",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                  const SizedBox(
                    height: 7,
                  ),
                  const Text('Lead Detail: ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  (listLead.isEmpty)
                      ? const CircularProgressIndicator()
                      : Column(children: [
                          Row(
                            children: [
                              const Text(
                                'Name:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => StatefulBuilder(
                                            builder: ((context, setState) =>
                                                XenPopupCard(
                                                    body: LeadDetailComp(
                                                  listAppointments:
                                                      listAppointments,
                                                  lead: listLead[0],
                                                  listStatus: listLeadStatus,
                                                )))));
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        listLead[0].fullname,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          Row(children: [
                            const Text(
                              'Mail:',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              listLead[0].email,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ]),
                          const SizedBox(
                            height: 7,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Phone:',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _makePhoneCall(listLead[0].phone);
                                  },
                                  child: Row(
                                    children: [
                                      const FaIcon(FontAwesomeIcons.phone,
                                          color: Colors.blue),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        listLead[0].phone,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ]),
                  (widget.opportunity.opportunityStatus == 'Lost')
                      ? Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 97, 97, 97)),
                                onPressed: () {},
                                child: const Text('Opportunity Lost')),
                          ),
                        )
                      : Row(
                          children: [
                            const Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 244, 54, 54)),
                                  onPressed: () {
                                    updateStatusOpp(widget.opportunity.id, 7);
                                  },
                                  child: const Text('Lost')),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => StatefulBuilder(
                                            builder: ((context, setState) =>
                                                AlertDialog(
                                                    title: Text(
                                                        "Update Opportunity Status"),
                                                    content: Container(
                                                      width: 300,
                                                      height: 420,
                                                      child: ListView.builder(
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              listOpportunityStatus
                                                                      .length -
                                                                  1,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          10),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              height: 50,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .blue),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12)),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  updateStatusOpp(
                                                                      widget
                                                                          .opportunity
                                                                          .id
                                                                          .toString(),
                                                                      int.parse(
                                                                          listOpportunityStatus[index]
                                                                              .id));
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                        '${listOpportunityStatus[index].id} . ${listOpportunityStatus[index].status}')
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    )))));
                                  },
                                  child: const Text('Update Status')),
                            ),
                            const Spacer()
                          ],
                        )
                ])));
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

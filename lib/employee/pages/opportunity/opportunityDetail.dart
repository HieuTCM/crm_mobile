import 'package:crm_mobile/employee/components/lead/leadDetailComp.dart';
import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/models/person/leadModel.dart';
import 'package:crm_mobile/employee/models/product/category_model.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';
import 'package:crm_mobile/employee/models/opportunity/opportunityModel.dart';
import 'package:crm_mobile/employee/pages/product/productDetail.dart';
import 'package:crm_mobile/employee/providers/appointment/appointment_provider.dart';
import 'package:crm_mobile/employee/providers/lead/lead_provider.dart';
import 'package:crm_mobile/employee/providers/product/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
  List<Lead> listLead = [];
  List<Appointment> listAppointments = [];
  List<LeadStatus> listLeadStatus = [];
  getProbyId(String id) async {
    await productProviders.fetchProductByProID(id).then((value) {
      setState(() {
        listpro.add(value);
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                  const Text(
                    'Opportunity Detail: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        ])
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

import 'dart:ui';

import 'package:crm_mobile/customer/components/NavBar/navBar.dart';
import 'package:crm_mobile/customer/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/customer/providers/appointment/appointment_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  bool waiting = true;

  List<Appointment> listAppointments = [];

  Map<String, String> mapParam = ({"pageNumber": "1", "pageSize": "6"});

  int totalRow = 0;
  int pageNumber = 1;
  int pageCurrent = 1;

  int totalpage = 1;

  getListAppointment() async {
    setState(() {
      waiting = true;
      mapParam["sort"] = '2;false';
    });

    await appointmentProvider.fetchAllAppointments(mapParam).then((value) {
      setState(() {
        listAppointments = value;
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
    getListAppointment();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appoitment List')),
      body: Column(
        children: [
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
                  items: List<int>.generate(totalpage, (int index) => index + 1,
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
                      await getListAppointment();
                    });
                  },
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
                  items: List<int>.generate(totalpage, (int index) => index + 1,
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
                      await getListAppointment();
                    });
                  },
                ),
              ),
              const SizedBox(
                width: 30,
              )
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            margin: const EdgeInsets.all(12),
            child: (waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: listAppointments.length,
                    itemBuilder: (context, index) {
                      Appointment appointment = listAppointments[index];
                      int maxString =
                          listAppointments[index].description.toString().length;
                      if (listAppointments[index]
                              .description
                              .toString()
                              .length >
                          40) {
                        maxString = 40;
                      }
                      String status = appointment.appointmentStatus;

                      return Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 5),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(children: [
                          Row(
                            children: [
                              Text(
                                appointment.name,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Text(appointment.createDate,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(
                                appointment.product.name,
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text('${appointment.product.price}  VND',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Text('${appointment.appointmentStatus}',
                                  style: TextStyle(
                                      color: (status == 'Waiting')
                                          ? Colors.yellow.shade800
                                          : (status == 'Accepted')
                                              ? Colors.blue.shade800
                                              : (status == 'Finished')
                                                  ? Colors.green.shade800
                                                  : Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            height: 50,
                            child: SingleChildScrollView(
                              child: (maxString < 40)
                                  ? Text(
                                      '${appointment.description.toString().substring(0, maxString)} ',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    )
                                  : Text(
                                      '${appointment.description.toString().substring(0, maxString)} ...',
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                            ),
                          )
                        ]),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names

import 'package:crm_mobile/employee/components/appointment/listappoitmentcomp.dart';
import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/providers/appointment/appointment_provider.dart';
import 'package:crm_mobile/employee/providers/user/user_Provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  bool waiting = true;
  UserObj user = UserObj();
  List<Appointment> listAppointments = [];
  List<String> listAppointmentStatus = ['All'];
  AppointmentStatus appointmentStatus = AppointmentStatus();
  Map<String, String> mapParam = ({"pageNumber": "1", "pageSize": "4"});

  int totalRow = 0;
  int pageNumber = 1;
  int pageCurrent = 1;

  int totalpage = 1;

  String fillter = '';

  String? filterSelected;

  getUserinfo() async {
    userProviders.fetchUserInfor().then((value) {
      setState(() {
        user = value;
      });
    });
  }

  getAppointmentStatus() async {
    await appointmentProvider.fetchAllAppointmentStatus().then((value) {
      setState(() {
        for (var data in value) {
          listAppointmentStatus.add(data.name);
        }
      });
    });
  }

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
        totalpage = totalRow ~/ 4;
        if (totalRow % 4 != 0) {
          totalpage++;
        }
      });
    });
  }

  getListAppointmentWithfillter(String value) async {
    setState(() {
      mapParam.update('pageNumber', (value) => value = '1');
      pageCurrent = 1;
      waiting = true;
      mapParam["sort"] = '2;false';
      mapParam["filter"] = '7;$value';
      if (value == 'All') {
        mapParam.remove("filter");
      }
    });

    await appointmentProvider.fetchAllAppointments(mapParam).then((value) {
      setState(() {
        if (value[0].appointmentStatus == 'NotFound') {
          listAppointments = [];
          totalpage = 1;
        } else {
          listAppointments = value;
          totalRow = value[0].totalRow;
          totalpage = totalRow ~/ 6;
          if (totalRow % 6 != 0) {
            totalpage++;
          }
        }
        waiting = false;
      });
    });
  }

  @override
  void initState() {
    getUserinfo();
    getAppointmentStatus();
    getListAppointment();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var f = NumberFormat("###,###,###.0#", "en_US");
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
                child: const Text('Fillter: '),
              ),
              SizedBox(
                child: DropdownButton2(
                  hint: const Text('Fillter '),
                  value: filterSelected,
                  dropdownMaxHeight: 300,
                  items: listAppointmentStatus
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Container(
                            width: 140,
                            alignment: Alignment.center,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 15),
                            ),
                          )))
                      .toList(),
                  onChanged: (e) async {
                    setState(() {
                      filterSelected = e;
                    });
                    if (e == 'All') {
                      setState(() {
                        mapParam.update('pageNumber', (value) => value = '1');
                        mapParam.remove('filter');
                      });

                      await getListAppointment();
                    }
                    await getListAppointmentWithfillter(filterSelected!);
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
              height: MediaQuery.of(context).size.height * 0.75,
              margin: const EdgeInsets.all(12),
              child: (waiting)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (listAppointments.isEmpty ||
                          listAppointments[0].appointmentStatus == 'NotFound')
                      ? const Center(
                          child: Text('Appointments not found'),
                        )
                      : ListAppointment(
                          listAppointments: listAppointments,
                          user: user,
                        )),
        ],
      ),
      // bottomNavigationBar: const NavBar(),
    );
  }
}

// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names

import 'package:crm_mobile/customer/components/appointment/appointmentDetailcomp.dart';
import 'package:crm_mobile/customer/models/Appoinment/appoinment_Model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xen_popup_card/xen_card.dart';

class ListAppointment extends StatefulWidget {
  List<Appointment> listAppointments;
  ListAppointment({super.key, required this.listAppointments});

  @override
  State<ListAppointment> createState() => _ListAppointmentState();
}

class _ListAppointmentState extends State<ListAppointment> {
  var f = NumberFormat("###,###,###.0#", "en_US");
  @override
  Widget build(BuildContext context) {
    List<Appointment> listAppointments = widget.listAppointments;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: listAppointments.length,
      itemBuilder: (context, index) {
        Appointment appointment = listAppointments[index];
        int maxString = listAppointments[index].description.toString().length;
        if (listAppointments[index].description.toString().length > 40) {
          maxString = 40;
        }
        String status = appointment.appointmentStatus;

        return InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (builder) => StatefulBuilder(
                    builder: ((context, setState) => XenPopupCard(
                        gutter: CardGutter(appointment.appointmentStatus),
                        body: AppointmentDetail(
                          appointment: appointment,
                        )))));
          },
          child: Container(
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
                          fontSize: 15, fontWeight: FontWeight.bold))
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
                  Text('${f.format(appointment.product.price)}  VND',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
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
          ),
        );
      },
    );
  }

  XenCardGutter? CardGutter(String value) {
    XenCardGutter gutter = XenCardGutter(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                  child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (builder) => StatefulBuilder(
                          builder: ((context, setState) =>
                              XenPopupCard(body: Container()))));
                },
                child: Text(value),
              ))
            ],
          )),
    );
    return gutter;
  }
}

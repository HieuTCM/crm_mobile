// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names, prefer_final_fields, unused_field, prefer_collection_literals

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_mobile/employee/components/appointment/appointmentDetailcomp.dart';
import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/pages/appointment/appointmentPage.dart';
import 'package:crm_mobile/employee/providers/appointment/appointment_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:xen_popup_card/xen_card.dart';
import 'package:rating_dialog/rating_dialog.dart';

class ListAppointment extends StatefulWidget {
  List<Appointment> listAppointments;
  UserObj user;
  ListAppointment(
      {super.key, required this.listAppointments, required this.user});

  @override
  State<ListAppointment> createState() => _ListAppointmentState();
}

class _ListAppointmentState extends State<ListAppointment> {
  var f = NumberFormat("###,###,###.0#", "en_US");
  TextEditingController _nameController = TextEditingController();
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
                        gutter: CardGutter(
                            appointment.appointmentStatus, appointment),
                        body: AppointmentDetail(
                          user: widget.user,
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.43,
                    child: AutoSizeText(
                      appointment.name,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: AutoSizeText(
                      appointment.createDate,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  )
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
                  Container(
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: AutoSizeText(
                      '${appointment.appointmentStatus}',
                      style: TextStyle(
                          color: (status == 'Waiting')
                              ? Colors.yellow.shade800
                              : (status == 'Accepted')
                                  ? Colors.blue.shade800
                                  : (status == 'Finished')
                                      ? Colors.green.shade800
                                      : Colors.red,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                    ),
                  ),
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

  XenCardGutter? CardGutter(String value, Appointment appointment) {
    XenCardGutter gutter = XenCardGutter(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              (value == 'Waiting')
                  ? Expanded(
                      child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (builder) => StatefulBuilder(
                                builder: ((context, setState) => XenPopupCard(
                                    gutter: RejectGutter(
                                        appointment, _nameController.text),
                                    body: Column(children: [
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: const Text(
                                            'Why do you want to Reject appointment ? '),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextField(
                                          autofocus: false,
                                          controller: _nameController,
                                          keyboardType: TextInputType.name,
                                          onChanged: (value) {},
                                          style: const TextStyle(fontSize: 14),
                                          textInputAction: TextInputAction.next,
                                          maxLines: 5,
                                          maxLength: 100,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            errorText: null,
                                            hintText: "Reason...",
                                          )),
                                    ])))));
                      },
                      child: const Text('Reject'),
                    ))
                  : (value == 'Accepted')
                      ? Expanded(
                          child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade800),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (builder) => StatefulBuilder(
                                    builder: ((context, setState) =>
                                        XenPopupCard(
                                            gutter: CancelGutter(appointment,
                                                _nameController.text),
                                            body: Column(children: [
                                              Container(
                                                alignment: Alignment.topLeft,
                                                child: const Text(
                                                    'Why do you want to Reject appointment ? '),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                  autofocus: false,
                                                  controller: _nameController,
                                                  keyboardType:
                                                      TextInputType.name,
                                                  onChanged: (value) {},
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  maxLines: 5,
                                                  maxLength: 100,
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    errorText: null,
                                                    hintText: "Reason...",
                                                  )),
                                            ])))));
                          },
                          child: const Text('Cancel'),
                        ))
                      : Expanded(
                          child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        )),
              const SizedBox(
                width: 10,
              ),
              (value == 'Waiting')
                  ? Expanded(
                      child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade800),
                      onPressed: () {
                        OverlayLoadingProgress.start(context);
                        appointmentProvider
                            .updAcceptApponitmemt(appointment.id)
                            .then((value) {
                          if (value == 'Successful') {
                            OverlayLoadingProgress.stop(context);
                            Fluttertoast.showToast(
                                msg: "Accept Successful",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AppointmentPage()));
                          } else {
                            Fluttertoast.showToast(
                                msg: "Accept failed ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: const Text('Accept'),
                    ))
                  : (value == 'Accepted')
                      ? Expanded(
                          child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {
                            String date = appointment.startDate +
                                ' ' +
                                appointment.startTime;
                            DateTime current = DateTime.now();
                            DateTime dateApp =
                                DateFormat("dd-MM-yyyy HH:mm:ss").parse(date);
                            if (current.compareTo(dateApp) < 0) {
                              Fluttertoast.showToast(
                                  msg: " Appointment was not yet started ",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            if (current.compareTo(dateApp) > 0 ||
                                current.compareTo(dateApp) == 0) {
                              OverlayLoadingProgress.start(context);
                              appointmentProvider
                                  .updFinishApponitmemt(appointment.id)
                                  .then((value) {
                                if (value == 'Successful') {
                                  OverlayLoadingProgress.stop(context);
                                  Fluttertoast.showToast(
                                      msg: "Finish Successful",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.green,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AppointmentPage()));
                                } else {
                                  OverlayLoadingProgress.stop(context);
                                  Fluttertoast.showToast(
                                      msg: "Finish failed ",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Navigator.pop(context);
                                }
                              });
                            }
                          },
                          child: const Text('Finish'),
                        ))
                      : (value == 'Finished')
                          ? Expanded(
                              child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 15, 84, 187)),
                              onPressed: () {
                                (appointment.isFeedback)
                                    ? showDialog(
                                        context: context,
                                        builder: (builder) => StatefulBuilder(
                                            builder: ((context, setState) =>
                                                AlertDialog(
                                                  content: Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    height: 200,
                                                    child: Column(children: [
                                                      const Center(
                                                        child: Text(
                                                          'Rating',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          for (var i = 0;
                                                              i <
                                                                  appointment
                                                                      .feedback
                                                                      .rate;
                                                              i++) ...[
                                                            const Spacer(),
                                                            const Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.yellow,
                                                              size: 40,
                                                            ),
                                                            const Spacer()
                                                          ]
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      const Center(
                                                        child: Text(
                                                          'Message',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Center(
                                                        child: (appointment
                                                                .feedback
                                                                .content
                                                                .toString()
                                                                .isEmpty)
                                                            ? const Text(
                                                                'No message')
                                                            : Text(appointment
                                                                .feedback
                                                                .content),
                                                      )
                                                    ]),
                                                  ),
                                                ))))
                                    : showDialog(
                                        context: context,
                                        builder: (builder) => StatefulBuilder(
                                            builder: ((context, setState) =>
                                                AlertDialog(
                                                  content: Container(
                                                    alignment: Alignment.center,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    height: 200,
                                                    child:
                                                        Column(children: const [
                                                      Center(
                                                        child: Text(
                                                          'Lead have not rating for you yet !!! ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ]),
                                                  ),
                                                ))));
                              },
                              child: const Text('Feedback'),
                            ))
                          : (value == 'Expired')
                              ? Expanded(
                                  child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 78, 78, 78)),
                                  onPressed: null,
                                  child: Text(value),
                                ))
                              : Expanded(
                                  child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 78, 78, 78)),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (builder) => StatefulBuilder(
                                            builder: ((context, setState) =>
                                                XenPopupCard(
                                                    body: Column(children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      'Date ${value.toString()}: ',
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        ' ${appointment.abortDate}',
                                                        style: const TextStyle(
                                                            fontSize: 16)),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: const Text(
                                                      'Reason ',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  (appointment.abortReason
                                                          .toString()
                                                          .isNotEmpty)
                                                      ? Container(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                            appointment
                                                                .abortReason,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                        )
                                                      : const Expanded(
                                                          child: Text(
                                                            'Do not have reason ',
                                                            style: TextStyle(
                                                                fontSize: 18),
                                                          ),
                                                        ),
                                                ])))));
                                  },
                                  child: Text(value),
                                ))
            ],
          )),
    );
    return gutter;
  }

  XenCardGutter? CancelGutter(Appointment appointment, String value) {
    XenCardGutter gutter = XenCardGutter(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    OverlayLoadingProgress.start(context);
                    appointmentProvider
                        .updCancelApponitmemt(
                            appointment.id, _nameController.text)
                        .then((value) {
                      if (value == 'Successful') {
                        OverlayLoadingProgress.stop(context);
                        Fluttertoast.showToast(
                            msg: "Cancel Successful",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AppointmentPage()));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Cancel failed ",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      }
                    });
                  },
                  child: const Text('Send'),
                )),
              ],
            )));
    return gutter;
  }

  XenCardGutter? RejectGutter(Appointment appointment, String value) {
    XenCardGutter gutter = XenCardGutter(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
                    OverlayLoadingProgress.start(context);
                    appointmentProvider
                        .updRejectApponitmemt(
                            appointment.id, _nameController.text)
                        .then((value) {
                      if (value == 'Successful') {
                        OverlayLoadingProgress.stop(context);
                        Fluttertoast.showToast(
                            msg: "Reject Successful",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AppointmentPage()));
                      } else {
                        Fluttertoast.showToast(
                            msg: "Reject failed ",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      }
                    });
                  },
                  child: const Text('Send'),
                )),
              ],
            )));
    return gutter;
  }
}

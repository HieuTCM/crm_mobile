// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, camel_case_types, must_be_immutable, file_names

import 'package:crm_mobile/employee/models/Appoinment/appoinment_Model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/pages/product/productDetail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentDetail extends StatefulWidget {
  UserObj user;
  Appointment appointment;
  AppointmentDetail({super.key, required this.appointment, required this.user});

  @override
  State<AppointmentDetail> createState() => _AppointmentDetailState();
}

class _AppointmentDetailState extends State<AppointmentDetail> {
  var f = NumberFormat("###,###,###.0#", "en_US");
  @override
  Widget build(BuildContext context) {
    UserObj user = widget.user;
    Appointment appointment = widget.appointment;
    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: [
                const Text(
                  'Name of Request : ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    '${appointment.name}',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Text(
                  'Your Name : ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    '${appointment.fullname}',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                const Text(
                  'Type of Request : ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    '${appointment.activityType}',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: const [
                Text(
                  'Description : ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${appointment.description}',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  'Date: ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    '${appointment.startDate}',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Text(
                  "Time : ",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    '${appointment.startTime}',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: const [
                Text(
                  "Product ",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDetail(
                              product: appointment.product,
                              user: user,
                              wherecall: 'AppointmentView',
                            )));
              },
              child: Container(
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.width * 0.7,
                height: 175.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(
                        appointment.product.listImg[0].url,
                      ),
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "${appointment.product.name} ",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "${f.format(appointment.product.price)}  VND",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
          ]),
        ));
  }
}

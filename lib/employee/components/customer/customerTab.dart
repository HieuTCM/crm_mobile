// ignore_for_file: file_names, camel_case_types, must_be_immutable, use_build_context_synchronously

import 'package:auto_size_text/auto_size_text.dart';
import 'package:crm_mobile/employee/models/customer/customer_model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:crm_mobile/employee/models/task/taskModel.dart';
import 'package:crm_mobile/employee/pages/customer/customerDetail.dart';
import 'package:crm_mobile/employee/pages/task/taskDetailPage.dart';
import 'package:crm_mobile/employee/providers/task/task_Provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';

class CustomerTab extends StatefulWidget {
  CustomerModel customer;
  UserObj user;
  CustomerTab({
    super.key,
    required this.customer,
    required this.user,
  });

  @override
  State<CustomerTab> createState() => _CustomerTabState();
}

class _CustomerTabState extends State<CustomerTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String urlImg =
        'https://i.pinimg.com/474x/3d/b7/9e/3db79e59b9052890ea1ffbef0f3970cc.jpg';
    CustomerModel customer = widget.customer;
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 170,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue, width: 3)),
      child: InkWell(
          onTap: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CustomerDetailPage(customer: customer)));
          },
          child: Column(children: [
            Row(
              children: [
                Container(
                    width: 75,
                    height: 75,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: CircleAvatar(
                      radius: 48, // Image radius
                      backgroundImage: NetworkImage(
                          (widget.customer.image.toString().length <= 10)
                              ? urlImg
                              : widget.customer.image),
                    )),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: AutoSizeText(
                    'Name: ${(widget.customer.fullname)}',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                    maxLines: 1,
                  ),
                ),
                const Spacer(),
                Text('Gender: ${(widget.customer.gender) ? 'Female' : 'Male'}')
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('Phone: '),
                Text(widget.customer.phone),
                const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: AutoSizeText(
                    'Email: ${(widget.customer.email)}',
                    style: const TextStyle(
                      fontSize: 17,
                    ),
                    maxLines: 1,
                  ),
                )
              ],
            ),
          ])),
    );
  }
}

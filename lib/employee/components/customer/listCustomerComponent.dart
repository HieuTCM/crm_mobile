// ignore_for_file: file_names, camel_case_types, must_be_immutable

import 'package:crm_mobile/employee/components/customer/customerTab.dart';
import 'package:crm_mobile/employee/models/customer/customer_model.dart';
import 'package:crm_mobile/employee/models/person/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class listCustomerComp extends StatefulWidget {
  List<CustomerModel> listCustomer;
  UserObj user;
  listCustomerComp({
    super.key,
    required this.listCustomer,
    required this.user,
  });

  @override
  State<listCustomerComp> createState() => _listCustomerCompState();
}

class _listCustomerCompState extends State<listCustomerComp> {
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.listCustomer.length,
        itemBuilder: (context, index) {
          return CustomerTab(
            customer: widget.listCustomer[index],
            user: widget.user,
          );
        },
      ),
    );
  }
}

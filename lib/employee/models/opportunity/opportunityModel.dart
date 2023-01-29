import 'package:crm_mobile/employee/models/person/employeeModel.dart';
import 'package:crm_mobile/employee/models/person/leadModel.dart';
import 'package:crm_mobile/employee/models/product/product_model.dart';

class Opportunity {
  late final id;
  late final name;
  late final leadId;
  late final employeeId;
  late final productId;
  late final saleClosingDate;
  late final createDate;
  late final deposit;
  late final description;
  late final opportunityStatus;
  late final lostReason;
  late final negotiationPrice;
  late final lastPrice;
  late final listedPrice;
  late int totalRow;

  Opportunity({
    this.id,
    this.name,
    this.leadId,
    this.employeeId,
    this.productId,
    this.saleClosingDate,
    this.createDate,
    this.deposit,
    this.description,
    this.opportunityStatus,
    this.lostReason,
    this.negotiationPrice,
    this.lastPrice,
    this.listedPrice,
    required this.totalRow,
  });

  Opportunity.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    leadId = json["leadId"];
    employeeId = json["employeeId"];
    productId = json["productId"];
    saleClosingDate = json["saleClosingDate"];
    createDate = json["createDate"];
    deposit = json["deposit"];
    description = json["description"];
    opportunityStatus = json["opportunityStatus"];
    lostReason = json["lostReason"];
    negotiationPrice = json["negotiationPrice"];
    lastPrice = json["lastPrice"];
    listedPrice = json["listedPrice"];
    totalRow = json["totalRow"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = name;
    data['description'] = description;
    data['leadId'] = leadId;
    data['productId'] = productId;
    return data;
  }
}

class OpportunityStatus {
  late final id;
  late final status;

  OpportunityStatus({this.id, this.status});

  OpportunityStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['name'];
  }
}

class LostReason {
  late final id;
  late final status;

  LostReason({this.id, this.status});

  LostReason.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['name'];
  }
}

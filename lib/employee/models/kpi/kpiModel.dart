class kpiPeriod {
  late final id;
  late final period;

  kpiPeriod({this.id, this.period});
  kpiPeriod.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    period = json["period"];
  }
}

class kpi {
  late final employeeId;
  late final employeeName;
  late final createDate;
  late final name;
  late final description;
  late final status;
  late final startDate;
  late final endDate;
  late final expectedCall;
  late final actualCall;
  late final expectedMeeting;
  late final actualMeeting;
  late final expectedLeadConvert;
  late final actualLeadConvert;
  late final expectedSales;
  late final actualSales;
  late final expectedRevenue;
  late final actualRevenue;
  kpi(
      {this.employeeId,
      this.employeeName,
      this.createDate,
      this.name,
      this.actualCall,
      this.actualLeadConvert,
      this.actualMeeting,
      this.actualRevenue,
      this.actualSales,
      this.description,
      this.endDate,
      this.expectedCall,
      this.expectedLeadConvert,
      this.expectedMeeting,
      this.expectedRevenue,
      this.expectedSales,
      this.startDate,
      this.status});
  kpi.fromJson(Map<dynamic, dynamic> json) {
    employeeId = json["employeeId"];
    employeeName = json["employeeName"];
    createDate = json["createDate"];
    name = json["name"];
    description = json["description"];
    status = json["status"];
    startDate = json["startDate"];
    endDate = json["endDate"];
    expectedCall = json["expectedCall"];
    actualCall = json["actualCall"];
    expectedMeeting = json["expectedMeeting"];
    actualMeeting = json["actualMeeting"];
    expectedLeadConvert = json["expectedLeadConvert"];
    actualLeadConvert = json["actualLeadConvert"];
    expectedSales = json["expectedSales"];
    actualSales = json["actualSales"];
    expectedRevenue = json["expectedRevenue"];
    actualRevenue = json["actualRevenue"];
  }
}

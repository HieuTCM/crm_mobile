// ignore_for_file: file_names, camel_case_types, must_be_immutable, prefer_typing_uninitialized_variables, prefer_collection_literals

class Feedbackmodel {
  late final id;
  late final customerId;
  late final appointmentId;
  late final content;
  late final rate;
  late final feedbackDate;
  late final totalRow;

  Feedbackmodel(
      {this.id,
      this.customerId,
      this.appointmentId,
      this.content,
      this.rate,
      this.feedbackDate,
      this.totalRow});
}

class Rating {
  late final rate_1;
  late final rate_2;
  late final rate_3;
  late final rate_4;
  late final rate_5;
  late final average;
  Rating(
      {this.rate_1,
      this.rate_2,
      this.rate_3,
      this.rate_4,
      this.rate_5,
      this.average});
  Rating.fromJson(Map<String, dynamic> json) {
    rate_1 = json['rate_1'];
    rate_2 = json['rate_2'];
    rate_3 = json['rate_3'];
    rate_4 = json['rate_4'];
    rate_5 = json['rate_5'];
    average = json['average'];
  }
}

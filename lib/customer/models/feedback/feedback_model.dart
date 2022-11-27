// ignore_for_file: file_names, camel_case_types, must_be_immutable, prefer_typing_uninitialized_variables, prefer_collection_literals

class Feedbackmodel {
  late final id;
  late final customerId;
  late final appointmentId;
  late final content;
  late final rate;
  late final feedbackDate;

  Feedbackmodel(
      {this.id,
      this.customerId,
      this.appointmentId,
      this.content,
      this.rate,
      this.feedbackDate});
}

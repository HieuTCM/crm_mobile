class Notifications {
  late final id;
  late final receiverId;
  late final receiverCustomerId;
  late final content;
  late final title;
  late final createDate;
  late final isRead;
  late final receiver;
  late final receiverCustomer;
  late final totalRow;
  Notifications(
      {this.id,
      this.receiverId,
      this.content,
      this.title,
      this.createDate,
      this.isRead,
      this.receiver,
      this.receiverCustomer,
      this.receiverCustomerId,
      this.totalRow});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiverId = json['receiverId'];
    receiverCustomerId = json['receiverCustomerId'];
    content = json['content'];
    title = json['title'];
    createDate = json['createDate'];
    isRead = json['isRead'];
    receiver = json['receiver'];
    receiverCustomer = json['receiverCustomer'];
    totalRow = json['totalRow'];
  }
}

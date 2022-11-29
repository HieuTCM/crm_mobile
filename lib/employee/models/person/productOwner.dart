// ignore_for_file: file_names, camel_case_types, must_be_immutable, prefer_typing_uninitialized_variables, prefer_collection_literals

class Owner {
  late final id;
  late final name;
  late final email;
  late final phone;
  late final isDelete;
  late final totalRow;
  late final totalProduct;

  Owner(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.isDelete,
      this.totalRow,
      this.totalProduct});

  Owner.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    phone = json["phone"];
    isDelete = json["isDelete"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    // data['id'] = this.id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['isDelete'] = isDelete;

    return data;
  }
}

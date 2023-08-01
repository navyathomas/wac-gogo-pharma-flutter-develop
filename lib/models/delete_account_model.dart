class DeleteAccountModel {
  DeleteData? data;

  DeleteAccountModel({this.data});

  DeleteAccountModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? DeleteData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DeleteData {
  DeleteCustomerAccount? deleteCustomerAccount;

  DeleteData({this.deleteCustomerAccount});

  DeleteData.fromJson(Map<String, dynamic> json) {
    deleteCustomerAccount = json['deleteCustomerAccount'] != null
        ? DeleteCustomerAccount.fromJson(json['deleteCustomerAccount'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (deleteCustomerAccount != null) {
      data['deleteCustomerAccount'] = deleteCustomerAccount!.toJson();
    }
    return data;
  }
}

class DeleteCustomerAccount {
  String? message;
  bool? status;

  DeleteCustomerAccount({this.message, this.status});

  DeleteCustomerAccount.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}

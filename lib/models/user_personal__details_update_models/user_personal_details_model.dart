class UserPersonalDetailsModels {
  UserInfoData? data;

  UserPersonalDetailsModels({this.data});

  UserPersonalDetailsModels.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? UserInfoData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class UserInfoData {
  bool? updateCustomerEmailMobile;
  UpdateCustomerV2? updateCustomerV2;


  UserInfoData({this.updateCustomerEmailMobile,this.updateCustomerV2});

  UserInfoData.fromJson(Map<String, dynamic> json) {
    updateCustomerEmailMobile = json['updateCustomerEmailMobile'];
  }
  UserInfoData.fromJsonUpdateCustomer(Map<String, dynamic> json) {
    updateCustomerV2 = json['updateCustomerV2'] != null
        ? UpdateCustomerV2.fromJson(json['updateCustomerV2'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['updateCustomerEmailMobile'] = updateCustomerEmailMobile;
    return data;
  }
}
class UpdateCustomerV2 {
  UpdateCustomer? customer;

  UpdateCustomerV2({this.customer});

  UpdateCustomerV2.fromJson(Map<String, dynamic> json) {
    customer = json['customer'] != null
        ? UpdateCustomer.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class UpdateCustomer {
  String? firstname;
  String? lastname;

  UpdateCustomer({this.firstname, this.lastname});

  UpdateCustomer.fromJson(Map<String, dynamic> json) {
    firstname = json['firstname'];
    lastname = json['lastname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    return data;
  }
}

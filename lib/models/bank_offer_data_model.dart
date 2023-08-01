class BankOfferDataModel {
  List<GetBankOffersByProductSku>? getBankOffersByProductSku;

  BankOfferDataModel({this.getBankOffersByProductSku});

  BankOfferDataModel.fromJson(Map<String, dynamic> json) {
    if (json['getBankOffersByProductSku'] != null) {
      getBankOffersByProductSku = <GetBankOffersByProductSku>[];
      json['getBankOffersByProductSku'].forEach((v) {
        getBankOffersByProductSku!.add(GetBankOffersByProductSku.fromJson(v));
      });
    }
  }
}

class GetBankOffersByProductSku {
  String? id;
  String? title;
  List<BankOfferDetail>? bankOfferDetail;

  GetBankOffersByProductSku({this.id, this.title, this.bankOfferDetail});

  GetBankOffersByProductSku.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['bank_offer_detail'] != null) {
      bankOfferDetail = <BankOfferDetail>[];
      json['bank_offer_detail'].forEach((v) {
        bankOfferDetail!.add(BankOfferDetail.fromJson(v));
      });
    }
  }
}

class BankOfferDetail {
  String? title;
  String? description;
  String? linkLabel;
  String? identifier;

  BankOfferDetail(
      {this.title, this.description, this.linkLabel, this.identifier});

  BankOfferDetail.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    linkLabel = json['link_label'];
    identifier = json['identifier'];
  }
}

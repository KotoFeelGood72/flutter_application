class CompanyInfo {
  final String? ukName;
  final String? photoPath;
  final Requisites? requisites;
  final List<Contact>? contacts;

  CompanyInfo({
    this.ukName,
    this.photoPath,
    this.requisites,
    this.contacts,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      ukName: json['uk_name'] as String?,
      photoPath: json['photo_path'] as String?,
      requisites: json['requisites'] != null
          ? Requisites.fromJson(json['requisites'] as Map<String, dynamic>)
          : null,
      contacts: json['contacts'] != null
          ? (json['contacts'] as List<dynamic>)
              .map((contact) =>
                  Contact.fromJson(contact as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uk_name': ukName,
      'photo_path': photoPath,
      'requisites': requisites?.toJson(),
      'contacts': contacts?.map((contact) => contact.toJson()).toList(),
    };
  }
}

class Requisites {
  final String? recipient;
  final String? inn;
  final String? kpp;
  final String? account;
  final String? bic;
  final String? correspondentAccount;
  final String? okpo;
  final String? bankName;

  Requisites({
    this.recipient,
    this.inn,
    this.kpp,
    this.account,
    this.bic,
    this.correspondentAccount,
    this.okpo,
    this.bankName,
  });

  factory Requisites.fromJson(Map<String, dynamic> json) {
    return Requisites(
      recipient: json['recipient'] as String?,
      inn: json['inn'] as String?,
      kpp: json['kpp'] as String?,
      account: json['account'] as String?,
      bic: json['bic'] as String?,
      correspondentAccount: json['correspondent_account'] as String?,
      okpo: json['okpo'] as String?,
      bankName: json['bank_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipient': recipient,
      'inn': inn,
      'kpp': kpp,
      'account': account,
      'bic': bic,
      'correspondent_account': correspondentAccount,
      'okpo': okpo,
      'bank_name': bankName,
    };
  }
}

class Contact {
  final String? name;
  final String? description;
  final String? email;
  final String? phone;

  Contact({
    this.name,
    this.description,
    this.email,
    this.phone,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      name: json['name'] as String?,
      description: json['description'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'email': email,
      'phone': phone,
    };
  }
}

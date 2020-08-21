// To parse this JSON data, do
//
//     final contact = contactFromJson(jsonString);

import 'dart:convert';

Contact contactFromJson(String str) => Contact.fromJson(json.decode(str));

String contactToJson(Contact data) => json.encode(data.toJson());

class Contact {
    String contactId;
    String companyId;
    String contactAddress;
    String contactDivision;
    String contactName;
    String contactNumber;
    String contactEmail;
    String contactCompany;

    Contact({
        this.contactId,
        this.companyId,
        this.contactAddress,
        this.contactDivision,
        this.contactName,
        this.contactNumber,
        this.contactEmail,
        this.contactCompany,
    });

    factory Contact.fromJson(Map<String, dynamic> json) => new Contact(
        contactId: json["contactId"],
        companyId: json["companyId"],
        contactAddress: json["contactAddress"],
        contactDivision: json["contactDivision"],
        contactName: json["contactName"],
        contactNumber: json["contactNumber"],
        contactEmail: json["contactEmail"],
        contactCompany: json["contactCompany"],
    );

    Map<String, dynamic> toJson() => {
        "contactId": contactId,
        "companyId": companyId,
        "contactAddress": contactAddress,
        "contactDivision": contactDivision,
        "contactName": contactName,
        "contactNumber": contactNumber,
        "contactEmail": contactEmail,
        "contactCompany": contactCompany,
    };
}

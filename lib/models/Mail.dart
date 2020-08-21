// To parse this JSON data, do
//
//     final mail = mailFromJson(jsonString);

import 'dart:convert';

Mail mailFromJson(String str) => Mail.fromJson(json.decode(str));

String mailToJson(Mail data) => json.encode(data.toJson());

class Mail {
    String id;
    String companyId;
    String name;
    String content;

    Mail({
        this.id,
        this.companyId,
        this.name,
        this.content,
    });

    factory Mail.fromJson(Map<String, dynamic> json) => Mail(
        id: json["id"],
        companyId: json["companyId"],
        name: json["name"],
        content: json["content"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "companyId": companyId,
        "name": name,
        "content": content,
    };
}

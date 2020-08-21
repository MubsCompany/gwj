// To parse this JSON data, do
//
//     final newsExternal = newsExternalFromJson(jsonString);

import 'dart:convert';

NewsExternal newsExternalFromJson(String str) => NewsExternal.fromJson(json.decode(str));

String newsExternalToJson(NewsExternal data) => json.encode(data.toJson());

class NewsExternal {
    String id;
    String companyId;
    String category;
    String source;
    String url;

    NewsExternal({
        this.id,
        this.companyId,
        this.category,
        this.source,
        this.url,
    });

    factory NewsExternal.fromJson(Map<String, dynamic> json) => new NewsExternal(
        id: json["id"],
        companyId: json["companyId"],
        category: json["category"],
        source: json["source"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "companyId": companyId,
        "category": category,
        "source": source,
        "url": url,
    };
}

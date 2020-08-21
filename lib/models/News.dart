// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

class News {
    String newsId;
    String companyId;
    String newsDate;
    String newsText;
    String newsTitle;
    String newsStatus;
    String newsImage;
    String isApprove;

    News({
        this.newsId,
        this.companyId,
        this.newsDate,
        this.newsText,
        this.newsTitle,
        this.newsStatus,
        this.newsImage,
        this.isApprove,
    });

    factory News.fromJson(Map<String, dynamic> json) => new News(
        newsId: json["newsId"],
        companyId: json["companyId"],
        newsDate: json["newsDate"],
        newsText: json["newsText"],
        newsTitle: json["newsTitle"],
        newsStatus: json["newsStatus"],
        newsImage: json["newsImage"],
        isApprove: json["isApprove"],
    );

    Map<String, dynamic> toJson() => {
        "newsId": newsId,
        "companyId": companyId,
        "newsDate": newsDate,
        "newsText": newsText,
        "newsTitle": newsTitle,
        "newsStatus": newsStatus,
        "newsImage": newsImage,
        "isApprove": isApprove,
    };
}

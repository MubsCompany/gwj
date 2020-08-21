// To parse this JSON data, do
//
//     final responseData = responseDataFromJson(jsonString);

import 'dart:convert';

ResponseData responseDataFromJson(String str) => ResponseData.fromJson(json.decode(str));

String responseDataToJson(ResponseData data) => json.encode(data.toJson());

class ResponseData {
    String responseCode;
    dynamic responseDesc;
    dynamic data;

    ResponseData({
        this.responseCode,
        this.responseDesc,
        this.data,
    });

    factory ResponseData.fromJson(Map<String, dynamic> json) => new ResponseData(
        responseCode: json["responseCode"],
        responseDesc: json["responseDesc"],
        data: json["data"],
    );

    Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "responseDesc": responseDesc,
        "data": data,
    };
}

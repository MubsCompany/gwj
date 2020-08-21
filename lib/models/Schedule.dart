// To parse this JSON data, do
//
//     final schedule = scheduleFromJson(jsonString);

import 'dart:convert';

Schedule scheduleFromJson(String str) => Schedule.fromJson(json.decode(str));

String scheduleToJson(Schedule data) => json.encode(data.toJson());

class Schedule {
    String scheduleId;
    String companyId;
    String scheduleContent;
    String scheduleDate;

    Schedule({
        this.scheduleId,
        this.companyId,
        this.scheduleContent,
        this.scheduleDate,
    });

    factory Schedule.fromJson(Map<String, dynamic> json) => new Schedule(
        scheduleId: json["scheduleId"],
        companyId: json["companyId"],
        scheduleContent: json["scheduleContent"],
        scheduleDate: json["scheduleDate"],
    );

    Map<String, dynamic> toJson() => {
        "scheduleId": scheduleId,
        "companyId": companyId,
        "scheduleContent": scheduleContent,
        "scheduleDate": scheduleDate,
    };
}

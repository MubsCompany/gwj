// To parse this JSON data, do
//
//     final reminder = reminderFromJson(jsonString);

import 'dart:convert';

Reminder reminderFromJson(String str) => Reminder.fromJson(json.decode(str));

String reminderToJson(Reminder data) => json.encode(data.toJson());

class Reminder {
    String reminderId;
    String scheduleId;
    String companyId;
    String reminderContent;
    String reminderDate;
    String status;

    Reminder({
        this.reminderId,
        this.scheduleId,
        this.companyId,
        this.reminderContent,
        this.reminderDate,
        this.status,
    });

    factory Reminder.fromJson(Map<String, dynamic> json) => new Reminder(
        reminderId: json["reminderId"],
        scheduleId: json["scheduleId"],
        companyId: json["companyId"],
        reminderContent: json["reminderContent"],
        reminderDate: json["reminderDate"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "reminderId": reminderId,
        "scheduleId": scheduleId,
        "companyId": companyId,
        "reminderContent": reminderContent,
        "reminderDate": reminderDate,
        "status": status,
    };
}

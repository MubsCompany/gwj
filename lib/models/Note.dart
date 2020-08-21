// To parse this JSON data, do
//
//     final note = noteFromJson(jsonString);

import 'dart:convert';

Note noteFromJson(String str) => Note.fromJson(json.decode(str));

String noteToJson(Note data) => json.encode(data.toJson());

class Note {
    String noteId;
    String companyId;
    String noteDate;
    String noteTitle;
    String noteContent;
    String noteHistory;
    String roleDestination;

    Note({
        this.noteId,
        this.companyId,
        this.noteDate,
        this.noteTitle,
        this.noteContent,
        this.noteHistory,
        this.roleDestination,
    });

    factory Note.fromJson(Map<String, dynamic> json) => new Note(
        noteId: json["noteId"],
        companyId: json["companyId"],
        noteDate: json["noteDate"],
        noteTitle: json["noteTitle"],
        noteContent: json["noteContent"],
        noteHistory: json["noteHistory"],
        roleDestination: json["roleDestination"],
    );

    Map<String, dynamic> toJson() => {
        "noteId": noteId,
        "companyId": companyId,
        "noteDate": noteDate,
        "noteTitle": noteTitle,
        "noteContent": noteContent,
        "noteHistory": noteHistory,
        "roleDestination": roleDestination,
    };
}

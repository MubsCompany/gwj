// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    String userId;
    String userPassword;
    String userName;
    String userEmail;
    String userNumber;
    String userAddress;
    String userPicture;
    String roleId;
    String userCode;
    String companyId;
    String firebaseToken;

    User({
        this.userId,
        this.userPassword,
        this.userName,
        this.userEmail,
        this.userNumber,
        this.userAddress,
        this.userPicture,
        this.roleId,
        this.userCode,
        this.companyId,
        this.firebaseToken,
    });

    factory User.fromJson(Map<String, dynamic> json) => new User(
        userId: json["userId"],
        userPassword: json["userPassword"],
        userName: json["userName"],
        userEmail: json["userEmail"],
        userNumber: json["userNumber"],
        userAddress: json["userAddress"],
        userPicture: json["userPicture"],
        roleId: json["roleId"],
        userCode: json["userCode"],
        companyId: json["companyId"],
        firebaseToken: json["firebaseToken"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "userPassword": userPassword,
        "userName": userName,
        "userEmail": userEmail,
        "userNumber": userNumber,
        "userAddress": userAddress,
        "userPicture": userPicture,
        "roleId": roleId,
        "userCode": userCode,
        "companyId": companyId,
        "firebaseToken": firebaseToken,
    };
}

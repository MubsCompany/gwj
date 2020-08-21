import 'package:encrypt/encrypt.dart' as Encrypt;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:template/utils/session.dart';
import 'package:template/utils/uidata.dart';

class GlobalFunction {

  static Future<bool> isValidRole()async{
    String roleId = await Session.getRoleId();
    return roleId == UIData.sekretarisId;
  }
  
  static fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);  
  }
  static String formatDate(DateTime dateTime,[String format ='yyyy-MM-dd']){
    final f = DateFormat(format);
    return f.format(dateTime);
  }
  static String formatDateTime(DateTime dateTime){
    final f = DateFormat('yyyy-MM-dd HH:mm:ss');
    return f.format(dateTime);
  }
  static String formatTime(DateTime dateTime){
    final f = DateFormat('HH:mm');
    return f.format(dateTime);
  }
  static changePage(BuildContext context,dynamic page){
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>page));
  }
  static popAndChangePage(BuildContext context,dynamic page){
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>page));
  }
  
  static showConfirmDialog(BuildContext context, Function() onPressed,{String content ="Are you sure want to delete this item ?"}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text("NO"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("YES"),
              onPressed: (){
                onPressed();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static showAlertDialog(BuildContext context,String content) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Information"),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static final key = Encrypt.Key.fromUtf8('qwertyuiopasdfghjklzxcvbnm123456');
  static final iv = Encrypt.IV.fromLength(16);
  static final encrypter = Encrypt.Encrypter(Encrypt.AES(key));
  static String encryptString(String str){
    String result = encrypter.encrypt(str, iv: iv).base64;
    print(result);
    return result;
    // final encrypted = encrypter.encrypt(str, iv: iv);
    // final decrypted = encrypter.decrypt(encrypted, iv: iv);
  }
  static String decryptString(String str){
    Encrypt.Encrypted encrypted = Encrypt.Encrypted.fromBase64(str);
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
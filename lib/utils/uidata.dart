
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';
import 'package:template/utils/api.dart';

class UIData {
  static const String appName = "GripWorkJourney";
  static  Color primaryColor = Pigment.fromString("#F3EB29");
  static  Color accentColor = Pigment.fromString("#00c2ff");
  static  Color containerColor = Pigment.fromString("#46508c");
  static  Color darkPrimaryColor = Pigment.fromString("#fe5d01");
  static  Color bcContactColor = Pigment.fromString("#59570D");
  static String uploadDir = "${ApiProvider.CORE_URL}/upload";
  static String dividerMail = "=====gwj=====";
  static String sekretarisId = "3";
  static String generalAffairId = "4";
  // static const String txtWelcome = "Selamat datang di aplikasi laporan harian kementerian ESDM";
  // static const String dirImage = "http://172.16.23.34/laporan-harian-esdm/image_upload/berita/";
}
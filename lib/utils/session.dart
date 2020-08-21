import 'package:shared_preferences/shared_preferences.dart';

class Session{

  static final  String isLogin = "isLogedIn";
  static final  String hasBeenShownIntroViews = "hasBeenShownIntroViews";
  static final  String userId = "userId";
  static final  String hasScheduled = "hasScheduled";
  static final  String roleId = "roleId";
  static final  String companyId = "companyId";
  static final  String firebaseToken = "firebaseToken";

  static Future<bool> getIsLogin()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLogin)?? false;
  }

  static Future<bool> setIsLogin(bool value)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(isLogin,value);
  }
  static Future<bool> getHasBeenShownIntroViews()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(hasBeenShownIntroViews)?? false;
  }

  static Future<bool> setHasBeenShownIntroViews(bool value)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(hasBeenShownIntroViews,value);
  }

  static Future<String> getUserId()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userId)?? null;
  }

  static Future<bool> setUserId(String value)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userId,value);
  }

  static Future<bool> getHasScheduled()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(hasScheduled)?? false;
  }

  static Future<bool> setHasScheduled(bool value)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(hasScheduled,value);
  }

  static Future<String> getRoleId()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(roleId)?? null;
  }

  static Future<bool> setRoleId(String value)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(roleId,value);
  }

  static Future<String> getCompanyId()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(companyId)?? null;
  }

  static Future<bool> setCompanyId(String value)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(companyId,value);
  }

  // is first session
  static Future<String> getFirebaseToken()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(firebaseToken)?? null;
  }

  static Future<bool> setFirebaseToken(String value)async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(firebaseToken,value);
  }

}

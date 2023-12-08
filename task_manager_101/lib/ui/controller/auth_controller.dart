import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_101/data/model/user_model.dart';

class AuthController{

  static String? token;
  static UserModel? user;

  static Future<void> saveUserInformation(String tokenPram , UserModel model) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token',tokenPram);
    await prefs.setString('user',jsonEncode(model.toJson()));

    token = tokenPram;
    user = model;
  }

  static Future<void> updateUserInformation(UserModel model) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user',jsonEncode(model.toJson()));
    user = model;
  }

  static Future<void> initializeUserCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token =  prefs.getString('token');
    user = UserModel.fromJson(jsonDecode(prefs.getString('user') ?? '{}'));
    log('i am  from 23 inside initalize methdo');
  }

  static Future<bool> checkUserAuthenticOrNot() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    log('the oken is --------------');
    print(token);
    if(token != null)
      {
        await initializeUserCache();
        return true;
      }
    return false;
  }

  static Future<void> claerSaveCheceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    token = null;
    user = null;
  }
}
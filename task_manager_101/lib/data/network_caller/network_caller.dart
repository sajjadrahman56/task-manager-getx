import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager_101/app.dart';
import 'package:task_manager_101/ui/controller/auth_controller.dart';
import 'package:task_manager_101/ui/screen/login_screen.dart';
import 'dart:convert';

import 'network_response.dart';

class NetworkCaller {
  Future postRequest(String url, {Map<String, dynamic>? body, bool isLogIn=false}) async {
    try {
      final Response response =
          await post(Uri.parse(url), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
            'token': AuthController.token.toString(),
      });
      log(response.headers.toString());
      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          jsonResponse: jsonDecode(response.body),
        );
      }else if (response.statusCode == 401) {
       if(isLogIn == false)
         {
           backToLogin();
         }
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          jsonResponse: jsonDecode(response.body),
        );
      }

      else{
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          jsonResponse: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future getRequest(String url) async {
    try {
      final Response response =
      await get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
        'token': AuthController.token.toString(),
      });
      log(response.headers.toString());
      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          jsonResponse: jsonDecode(response.body),
        );
      }else if (response.statusCode == 401) {
        backToLogin();
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          jsonResponse: jsonDecode(response.body),
        );
      }

      else{
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          jsonResponse: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }
  Future<void> backToLogin() async{
    await AuthController.claerSaveCheceData();
    Navigator.pushAndRemoveUntil(TaskManagerApp.navigationKey.currentContext!,
        MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
  }


  Future resetPasswordRequest(String url, {Map<String, dynamic>? body}) async {
    try {
      final Response response = await post(
        Uri.parse(url),
        body: body != null ? jsonEncode(body) : null,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          jsonResponse: jsonDecode(response.body),
        );
      } else {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          jsonResponse: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }
  Future postRequest2(String url, {Map<String, dynamic>? body}) async {
    try {
      final Response response =
      await post(Uri.parse(url), body: jsonEncode(body), headers: {
        'Content-Type': 'application/json',
        'token': AuthController.token.toString(),
      });
      log(response.headers.toString());
      log(response.statusCode.toString());
      log(response.body);

      if (response.statusCode == 200) {
        log('sajjad samina');
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          jsonResponse: jsonDecode(response.body),
        );
      }else if (response.statusCode == 401) {
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: true,
          jsonResponse: jsonDecode(response.body),
        );
      }

      else{
        return NetworkResponse(
          statusCode: response.statusCode,
          isSuccess: false,
          jsonResponse: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }
  }
}


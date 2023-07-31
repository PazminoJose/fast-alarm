import 'dart:io';

import 'package:app_boton_panico/src/components/snackbars.dart';
import 'package:app_boton_panico/src/global/global_variable.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  static final Dio _dio = Dio();
  static void configureDio() async {
    _dio.options.baseUrl = dotenv.env['BASE_URL'];
    _dio.options.headers = {
      HttpHeaders.contentTypeHeader: "application/json",
    };
  }

  static Future httpGet(String path) async {
    try {
      final resp = await _dio.get(
        path,
      );

      return resp.data;
    } catch (e) {
      ScaffoldMessenger.of(GlobalVariable.navigatorState.currentContext)
          .showSnackBar(MySnackBars.errorConectionSnackBar());
    }
  }

  static Future post(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.post(path, data: formData);
      return resp.data;
    } catch (e) {
      ScaffoldMessenger.of(GlobalVariable.navigatorState.currentContext)
          .showSnackBar(MySnackBars.errorConectionSnackBar());
    }
  }

  static Future put(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.put(path, data: formData);
      return resp.data;
    } catch (e) {
      ScaffoldMessenger.of(GlobalVariable.navigatorState.currentContext)
          .showSnackBar(MySnackBars.errorConectionSnackBar());
    }
  }

  static Future delete(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.delete(path, data: formData);
      return resp.data;
    } catch (e) {
      ScaffoldMessenger.of(GlobalVariable.navigatorState.currentContext)
          .showSnackBar(MySnackBars.errorConectionSnackBar());
    }
  }
}
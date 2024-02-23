import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:virtual_furnish_app/data/model/Home/home_model.dart';
import 'package:virtual_furnish_app/data/source/Home/home_source.dart';

//network logic
class HomeRepo {
  static Future<List<HomeModel>> getHomeData() async {
    try {
      List<HomeModel> homeData = [];
      var homeDataString = await HomeDataSource.fetchHomeData();
      List list = jsonDecode(homeDataString.body);
      for (int i = 0; i < list.length; i++) {
        HomeModel data = HomeModel.fromMap(list[i]);
        homeData.add(data);
      }
      return homeData;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  static Future<List<HomeModel>> fetchHomeDataByTitle(String title) async {
    try {
      List<HomeModel> homeData = [];
      var homeDataString = await HomeDataSource.fetchHomeData();
      List list = jsonDecode(homeDataString.body);
      for (int i = 0; i < list.length; i++) {
        if (list[i]['title'].toString() == title) {
          HomeModel data = HomeModel.fromMap(list[i]);
          homeData.add(data);
        }
        continue;
      }
      return homeData;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

  static Future<bool> addHomeData(HomeModel data) async {
    try {
      var response = await HomeDataSource.addHomeData(data.toMap());
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("Error in repo e.toString()");
      log(e.toString());
      return false;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Map/shopdata.dart';

class SearchController extends GetxController {

  TextEditingController controller = TextEditingController();

  var list = <Shop>[].obs;
  var searchList = <Shop>[].obs;

  @override
  void onInit() {
    super.onInit();
    fatchAll();
  }

  void fatchAll() async {
    try{
      final res = await fetchShops();
      list.value = res.shops;
    } catch (e){

    }
  }

  void onSearch(String keyword) {
    searchList.value = list.where((e) => e.name.contains(keyword)).toList();
  }
}
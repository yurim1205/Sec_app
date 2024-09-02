import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../Map/shopdata.dart';

class shoplike extends StatefulWidget {
  const shoplike({Key? key}) : super(key: key);

  @override
  State<shoplike> createState() => _shoplikeState();
}

class _shoplikeState extends State<shoplike> {
  final box = GetStorage();
  var isFinishFetched = false;

  // 찜한 가게를 보여줄 데이터
  List realList = [];

  // 로컬에 저장된 가게 [name] 리스트
  List shopList = [];

  // API를 호출해서 받은 선한 가게들 목록
  List rawList = [];

  init() async {
// 1. 선한가게를 불러옴
    final res = await fetchShops();
    rawList = res.shops;

    for (Shop item in rawList) {
      for (var likeItem in shopList) {
        // 2. 로컬에 저장된 likeItem(name을)과 API호출해서 받은 아이템의 name을 비교하여,
        // 같은 아이템을 realList에 저장
        if (likeItem == item.name) {
          realList.add(item);
          print(realList);
        }
      }
    }
    isFinishFetched = true;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    if (box.read('myLikedShopIds') != null) {
      shopList = box.read('myLikedShopIds') as List;
    }
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,  // 뒤로가기 버튼 제거
        backgroundColor: Color(0xfffaf4d9),
        iconTheme: IconThemeData(
          color: Color(0xff99ccff),
        ),
      ),
      body: _view(),
    );
  }

  Widget _view() {
    // 데이터 불러오는 과정이라면, 로딩을 보여줌
    if (!isFinishFetched) {
      return Center(
        child: CircularProgressIndicator(
          color: Color(0xff99ccff),
        ),
      );
    }
    // 로딩이 끝났지만, 리스트에 아무것도 들어있지 않다면, 찜한 가게가 없다고 보여줌
    else if (realList.isEmpty) {
      return Center(
        child: Text(
          "찜한 가게가 없어요 !",
          style: TextStyle(color: Colors.black45),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 로컬에 저장된 찜 가게들을 보여줌
          for (Shop item in realList) ...[
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    item.adress,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            )
          ],

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

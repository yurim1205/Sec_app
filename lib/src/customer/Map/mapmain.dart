import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../search/search.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../drawer_controller/drawer_controller.dart';
import 'shopdata.dart' as shopdata;
import 'package:geolocator/geolocator.dart';
import 'package:like_button/like_button.dart';
import '../search/search_controller.dart' as search;
import 'shopdata.dart';

class mapmain extends StatefulWidget {
  const mapmain({Key? key}) : super(key: key);

  static final LatLng userLatLng = const LatLng(
    // Map 초기화 위치
    37.5233273,126.921252,
  );

  static final Marker marker = Marker(
    markerId: const MarkerId('company'),
    position: userLatLng,
  );

  static final Circle circle = Circle(
    circleId: const CircleId('choolCheckCircle'),
    center: userLatLng,
    // 원의 중심이 되는 위치. LatLng값을 제공
    fillColor: Colors.blue.withOpacity(30.0),
    // 원의 색상
    radius: 100,
    // 원의 반지름 (미터 단위)
    strokeColor: Colors.blue,
    // 원의 테두리 색
    strokeWidth: 50, // 원의 테두리 두께
  );

  @override
  State<mapmain> createState() => _mapmainState();
}

class _mapmainState extends State<mapmain> {
  final box = GetStorage();
  var isisLiked = false;

  GoogleMapController? mapController;

  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();

    Get.put(search.SearchController());
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      // 마커 이미지 변경 부분
      const ImageConfiguration(),
      "assets/marker.png",
    );

    final shopProvider = await shopdata.fetchShops();

    setState(() {
      _markers.clear();
      for (final shop in shopProvider.shops) {
        final marker = Marker(
          markerId: MarkerId(shop.name),
          position: LatLng(shop.lat, shop.lon),
          infoWindow: InfoWindow(
            title: shop.name,
            snippet: shop.adress,
          ),
          icon: markerbitmap,
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    if (box.read('myLikedShopIds') == null) {
                      box.write('myLikedShopIds', []);
                    }
                    bool isLiked = box.read('myLikedShopIds').contains(shop.name) ?? false;
                    // GetStorage에서 해당 아이템이 있는지 확인

                    return Container(
                      child: Container(
                        height: 300, // 모달 높이 크기
                        margin: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          bottom: 40,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xfffaf4d9), // 모달 배경색
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ), // 모달 전체 라운딩 처리
                        ), // 모달 좌우하단 여백 크기

                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(17),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "  ${shop.name}", // 가게 이름
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                color: Colors.indigo,
                                              ),
                                            ),
                                            LikeButton(
                                              isLiked: isLiked, // 현재 상태로 설정
                                              onTap: (isLiked) async {
                                                if (isLiked) {
                                                  // 이미 좋아요 상태일 때 처리
                                                  isLiked = false;
                                                  // GetStorage에서 해당 아이템 제거
                                                  List likedShopIds = box.read('myLikedShopIds');
                                                  likedShopIds.remove(shop.name);
                                                  print(await box.read('myLikedShopIds'));
                                                  await box.write('myLikedShopIds', likedShopIds);

                                                  setState(() {}); // 화면 다시 그리기
                                                } else {
                                                  // 좋아요 상태가 아닐 때 처리
                                                  isLiked = true;
                                                  // GetStorage에 해당 아이템 추가
                                                  List likedShopIds = box.read('myLikedShopIds') ?? [];
                                                  likedShopIds.add(shop.name);
                                                  await box.write('myLikedShopIds', likedShopIds);
                                                  print(await box.read('myLikedShopIds'));
                                                  setState(() {}); // 화면 다시 그리기
                                                }
                                                return isLiked; // 변경된 상태 반환
                                              },
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          child: Row(
                                            children: [
                                              Text(
                                                "${shop.adress}", // 가게 주소
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          child: const Row(
                                            children: [
                                              Text(
                                                "제공품목",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  backgroundColor: Colors.yellowAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          child: Row(
                                            children: [
                                              Text(
                                                "  ${shop.provsnProdlstNm}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          child: const Row(
                                            children: [
                                              Text(
                                                " 영업시간",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  backgroundColor: Colors.yellowAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          child: Row(
                                            children: [
                                              Text(
                                                "  ${shop.bsnTmNm}", // 영업 시간
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          child: const Row(
                                            children: [
                                              Text(
                                                " 제공대상",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  backgroundColor: Colors.yellowAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          child: Row(
                                            children: [
                                              Text(
                                                "  ${shop.provsnTrgtNm2}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              backgroundColor: Colors.transparent,
            );
          },
        );

        // null 값이 있었던 경우 마커 생성 X
        if (shop.name != '' && shop.lat != 0 && shop.lon != 0 && shop.adress != '') {
          _markers[shop.name] = marker;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    return MaterialApp(
      home: Scaffold(
        onDrawerChanged: (isOpened) {
          // Drawer가 열려있다면, CustomDrawerController의 isOpen 변수를 true로 변경 해줌으로써, 바텀 네비게이션 바를 숨김
          if (isOpened) {
            Get.find<CustomDrawerController>().isOpen.value = true;
            Get.find<CustomDrawerController>().update();
          }
          // Drawer가 닫혀있다면, CustomDrawerController의 isOpen 변수를 false로 변경 해줌으로써, 바텀 네비게이션 바를 보임
          else {
            Get.find<CustomDrawerController>().isOpen.value = false;
            Get.find<CustomDrawerController>().update();
          }
        },
        appBar: AppBar(
          backgroundColor: const Color(0xfffaf4d9),
          iconTheme: const IconThemeData(
            color: Color(0xff99ccff),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                try {
                  Shop shop = await Get.to(const Search());

                  mapController?.moveCamera(
                    CameraUpdate.newLatLngZoom(
                      LatLng(shop.lat, shop.lon),
                      18,
                    ),
                  );
                } catch (e) {

                }
              },
              child: const SizedBox(
                height: 50,
                width: 50,
                child: Icon(
                  Icons.search,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: Container(
            color: const Color(0xfffaf4d9),
            child: ListView(
              children: [
                DrawerHeader(
                    child: Center(
                      child: Image.asset('assets/smalllogo.png', height: 230, width: 180),
                    )),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 23.0),
                  child: ListTile(
                    leading: const Icon(Icons.favorite_border),
                    title: const Text(
                      '후원하기',
                      style: TextStyle(fontSize: 15),
                      selectionColor: Color(0xff99ccff),
                    ),
                    onTap: () async {
                      final url = Uri.parse('https://basket.fund/goodimpact/6'); // 후원 사이트로 연결
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 23.0),
                  child: ListTile(
                    leading: const Icon(Icons.handshake_outlined),
                    title: const Text(
                      '동행하기',
                      style: TextStyle(fontSize: 15),
                    ),
                    onTap: () async {
                      final url = Uri.parse('https://www.xn--o39akkz01az4ip7f4xzwoa.com/apply/step1'); // 동행 사이트로 연결
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        body: FutureBuilder<String>(
          future: checkPermission(),
          builder: (context, snapshot) {
            // ❶ 로딩 상태
            if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // ➋ 권한 허가된 상태
            if (snapshot.data == '위치 권한이 허가 되었습니다.') {
              return CupertinoPageScaffold(
                child: Stack(
                  children: [
                    GoogleMap(
                      mapType: MapType.normal,
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(37.532600, 127.024612),
                        zoom: 10.0,
                      ),
                      markers: _markers.values.toSet(),
                      myLocationEnabled: true,
                    ),
                  ],
                ),
              );
            }

            // ➌ 권한 없는 상태
            return Center(
              child: Text(
                snapshot.data.toString(),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled(); // 위치 서비스 활성화여부 확인

    if (!isLocationEnabled) {
      // 위치 서비스 활성화 안 됨
      return '위치 서비스를 활성화해주세요.';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission(); // 위치 권한 확인

    if (checkedPermission == LocationPermission.denied) {
      // 위치 권한 거절됨

      // 위치 권한 요청하기
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
    }

    // 위치 권한 거절됨 (앱에서 재요청 불가)
    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정에서 허가해주세요.';
    }

    // 위 모든 조건이 통과되면 위치 권한 허가완료
    return '위치 권한이 허가 되었습니다.';
  }
}

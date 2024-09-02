import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'search_controller.dart' as search;

class Search extends GetView<search.SearchController> {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xfffaf4d9),
          iconTheme: const IconThemeData(
            color: Color(0xff99ccff),
          ),
          title: TextField(
            autofocus: true,
            controller: controller.controller,
            maxLines: 1,
            cursorColor: Colors.black,
            cursorWidth: 1.2,

            // 검색어를 입력시, 일치하는 장소가 리스트에 보임
            onChanged: (value) => controller.onSearch(value),

            decoration: const InputDecoration(
              hintStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff99ccff),
              ),
              isDense: true,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                borderSide: BorderSide.none,
              ),
              hintText: "장소를 입력해주세요.",
            ),
          ),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              size: 24,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Obx(
                () => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 일치하는 장소를 for문으로 위젯을 반복시켜 보여줌
                // TextSpan을 사용한 이유는, 일치하는 글자를 Bold처리 하기 위함
                for (var item in controller.searchList) ...[
                  GestureDetector(
                    onTap: () => Get.back(result: item),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: item.name.substring(0, item.name.indexOf(controller.controller.text)),
                                ),
                                TextSpan(
                                  text: item.name.substring(item.name.indexOf(controller.controller.text),
                                      item.name.indexOf(controller.controller.text) + controller.controller.text.length),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: item.name.substring(item.name.indexOf(controller.controller.text) + controller.controller.text.length),
                                ),
                              ],
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.adress,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

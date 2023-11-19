// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Shop _$ShopFromJson(Map<String, dynamic> json) => Shop(
      // 받아온 json에 명시된 키값을 정확히 입력해줘야한다.
      name: json['CMPNM_NM'] ?? '',
      sigunNm: json['SIGUN_NM'] ?? '',
      bsnTmNm: json['BSN_TM_NM'] ?? '',
      provsnProdlstNm: json['PROVSN_PRODLST_NM'] ?? '',
      provsnTrgtNm2: json['PROVSN_TRGT_NM2'] ?? '',
      refineLotnoAddr: json['REFINE_LOTNO_ADDR'] ?? '',
      refineZipno: json['REFINE_ZIPNO'] ?? '',

      // String으로 lat, lon 값이 오기 때문에 double로 변경해준다.
      lat: double.parse(json['REFINE_WGS84_LAT'] ?? '0'),
      lon: double.parse(json['REFINE_WGS84_LOGT'] ?? '0'),
      detailAddr: json['DETAIL_ADDR'] ?? '',
      provsnTrgtNm1: json['PROVSN_TRGT_NM1'] ?? '',
      adress: json['REFINE_ROADNM_ADDR'] ?? '',
);

Map<String, dynamic> _$ShopToJson(Shop instance) => <String, dynamic>{
      'CMPNM_NM': instance.name,
      'SIGUN_NM': instance.sigunNm,
      'BSN_TM_NM': instance.bsnTmNm,
      'PROVSN_PRODLST_NM': instance.provsnProdlstNm,
      'PROVSN_TRGT_NM2': instance.provsnTrgtNm2,
      'REFINE_LOTNO_ADDR': instance.refineLotnoAddr,
      'REFINE_ZIPNO': instance.refineZipno,
      'REFINE_WGS84_LAT': instance.lat,
      'REFINE_WGS84_LOGT': instance.lon,
      'DETAIL_ADDR': instance.detailAddr,
      'PROVSN_TRGT_NM1': instance.provsnTrgtNm1,
      'REFINE_ROADNM_ADDR': instance.adress,
};

// openApi의 json 파일은 한겹 더 쌓아진 상태였으므로 row까지 접근해줘야한다.
Locations _$LocationsFromJson(Map<String, dynamic> json) => Locations(
      shops: (json['GGGOODINFLSTOREST'][1]['row'] as List<dynamic>)
          .map((e) => Shop.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$LocationsToJson(Locations instance) => <String, dynamic>{
      'row': instance.shops,
};

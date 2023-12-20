import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/assetmanage_vm.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/page_view_models/aseetmanage_page_vm.dart';
import 'package:jb_finance/navigation/trade/models/trade_record_model.dart';
import 'package:jb_finance/navigation/trade/repos/trade_detail_repo.dart';
import 'package:jb_finance/navigation/trade/repos/trade_repo.dart';
import 'package:jb_finance/navigation/trade/view_models/trade_vm.dart';
import 'package:jb_finance/utils.dart';

//거래일지 상세 프로바이더
class TradeDetailVM
    extends FamilyAsyncNotifier<List<TradeRecordModel>?, String> {
  late final TradeRepo _tradeRepo;

  late final TradeDetailRepo _tradeDetailRepo;
  late final String corpCode;
  @override
  FutureOr<List<TradeRecordModel>?> build(String arg) async {
    _tradeRepo = ref.read(tradeRepo);
    _tradeDetailRepo = ref.read(tradeDetailRepo);
    corpCode = arg;

    final resData = await _tradeRepo.getTradeRecord({'sCorpCode': corpCode});

    final List<dynamic> record = resData['assetRecord'];
    final recordCnt = resData['assetRecordCnt'];

    if (recordCnt > 0) {
      final recordList = record.map((recordData) {
        return TradeRecordModel.fromJson(recordData);
      });

      return recordList.toList();
    } else {
      return null;
    }
  }

  //[기업] 거래일지 작성
  Future<Map<String, dynamic>> addTradeCorpDetail(
      Map<String, dynamic> param) async {
    final resData = await _tradeDetailRepo.addTradeCorpDetail(param);

    final List<dynamic> record = resData['assetRecord'];
    final recordCnt = resData['assetRecordCnt'];
    final Map<String, dynamic> detailInfo = resData['detailInfo'];

    if (recordCnt > 0) {
      final recordList = record.map((recordData) {
        return TradeRecordModel.fromJson(recordData);
      });

      //거래일지 상세 상태초기화
      state = AsyncData(recordList.toList());
      //거래일지 리스트 상태초기화
      ref.read(tradeCorpListProvider.notifier).state =
          const AsyncValue.loading();
      //포트폴리오 리스트 초기화
      ref.read(assetListProvider.notifier).state = const AsyncValue.loading();
      //포트폴리오 자산비중 초기화
      ref.read(assetProportionProvider.notifier).state =
          const AsyncValue.loading();
      //포트폴리오 초기화
      ref.read(assetmanageProvider.notifier).state = const AsyncValue.loading();
    } else {
      state = const AsyncData(null);
    }

    return detailInfo;
  }

  Future<Map<String, dynamic>> delTradeCorpDetail(int pSeq) async {
    final resData = await _tradeDetailRepo
        .delTradeCorpDetail({'pCorpCode': corpCode, 'pSeq': pSeq});

    final List<dynamic> record = resData['assetRecord'];
    final recordCnt = resData['assetRecordCnt'];
    final Map<String, dynamic> detailInfo = resData['detailInfo'];

    if (recordCnt > 0) {
      final recordList = record.map((recordData) {
        return TradeRecordModel.fromJson(recordData);
      });

      //거래일지 상세 상태초기화
      state = AsyncData(recordList.toList());
      //거래일지 리스트 상태초기화
      ref.read(tradeCorpListProvider.notifier).state =
          const AsyncValue.loading();
      //포트폴리오 리스트 초기화
      ref.read(assetListProvider.notifier).state = const AsyncValue.loading();
      //포트폴리오 자산비중 초기화
      ref.read(assetProportionProvider.notifier).state =
          const AsyncValue.loading();
      //포트폴리오 초기화
      ref.read(assetmanageProvider.notifier).state = const AsyncValue.loading();
    } else {
      state = const AsyncData(null);
    }

    return detailInfo;
  }

  Future<Map<String, dynamic>> getTradeCorpDetailInfo(
      BuildContext context) async {
    final responseData =
        await _tradeDetailRepo.getTradeCorpDetailInfo({'pCorpCode': corpCode});
    if (responseData['errMsg'] != null) {
      serverMessage(context, responseData['errMsg']);
      return {};
    } else {
      final Map<String, dynamic> detailInfo = responseData['detailInfo'];
      return detailInfo;
    }
  }
}

final tradeDetailProvider = AsyncNotifierProvider.family<TradeDetailVM,
    List<TradeRecordModel>?, String>(
  () => TradeDetailVM(),
);

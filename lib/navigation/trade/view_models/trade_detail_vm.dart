import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/assetmanage_vm.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/page_view_models/aseetmanage_page_vm.dart';
import 'package:jb_finance/navigation/trade/models/trade_record_model.dart';
import 'package:jb_finance/navigation/trade/repos/trade_detail_repo.dart';
import 'package:jb_finance/navigation/trade/repos/trade_repo.dart';
import 'package:jb_finance/navigation/trade/view_models/trade_vm.dart';

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
  Future<void> addTradeCorpDetail(Map<String, dynamic> param) async {
    final resData = await _tradeDetailRepo.addTradeCorpDetail(param);

    final List<dynamic> record = resData['assetRecord'];
    final recordCnt = resData['assetRecordCnt'];

    if (recordCnt > 0) {
      final recordList = record.map((recordData) {
        return TradeRecordModel.fromJson(recordData);
      });

      state = AsyncData(recordList.toList());
      ref.read(tradeCorpListProvider.notifier).state =
          const AsyncValue.loading();
      ref.read(assetListProvider.notifier).state = const AsyncValue.loading();
      ref.read(assetProportionProvider.notifier).state =
          const AsyncValue.loading();
      ref.read(assetmanageProvider.notifier).state = const AsyncValue.loading();
    } else {
      state = const AsyncData(null);
    }
  }
}

final tradeDetailProvider = AsyncNotifierProvider.family<TradeDetailVM,
    List<TradeRecordModel>?, String>(
  () => TradeDetailVM(),
);

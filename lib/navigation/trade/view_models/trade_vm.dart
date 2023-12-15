import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/assetmanage_vm.dart';
import 'package:jb_finance/navigation/assetmanage/view_models/page_view_models/aseetmanage_page_vm.dart';
import 'package:jb_finance/navigation/finance/view_models/corporation_vm.dart';
import 'package:jb_finance/navigation/finance/view_models/interest_vm.dart';
import 'package:jb_finance/navigation/planbook/view_models/planbook_vm.dart';
import 'package:jb_finance/navigation/trade/models/trade_corp_model.dart';
import 'package:jb_finance/navigation/trade/models/trade_record_model.dart';
import 'package:jb_finance/navigation/trade/repos/trade_repo.dart';

//거래일지 기업 리스트 프로바이더
class TradeCorpListVM extends AsyncNotifier<List<TradeCorpModel>?> {
  late final TradeRepo _tradeRepo;
  @override
  FutureOr<List<TradeCorpModel>?> build() async {
    _tradeRepo = ref.read(tradeRepo);

    final responseData = await _tradeRepo.getTradeCorpList();
    final List<dynamic> corpList = responseData['corpList'];
    final int corpCnt = responseData['corpListCnt'];
    if (corpCnt > 0) {
      final result = corpList.map((assetData) {
        return TradeCorpModel.fromJson(assetData);
      });
      return result.toList();
    } else {
      return null;
    }
  }

  Future<void> getTradeCorpList() async {
    final responseData = await _tradeRepo.getTradeCorpList();
    final List<dynamic> corpList = responseData['corpList'];
    final int corpCnt = responseData['corpListCnt'];
    if (corpCnt > 0) {
      final result = corpList.map((assetData) {
        return TradeCorpModel.fromJson(assetData);
      });
      state = AsyncValue.data(result.toList());
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<Map<String, dynamic>> initTradeList() async {
    final initData = await _tradeRepo.initTradeList();
    return initData;
  }

  Future<void> addTrade(Map<String, dynamic> param) async {
    await _tradeRepo.addTrade(param);
    //종목찾기, 관심종목 리스트 초기화
    ref.read(interProvider.notifier).state = const AsyncValue.loading();
    ref.read(corpProvider.notifier).state = const AsyncValue.loading();
    //거래일지 기업 리스트 초기화
    ref.read(tradeCorpListProvider.notifier).state = const AsyncValue.loading();
    //ref.read(tradeRecordProvider.notifier).state = const AsyncValue.loading();
    //목표관리 리스트 초기화
    //ref.read(planProvider.notifier).state = const AsyncValue.loading();
    //포트폴리오 초기화
    //ref.read(assetmanageProvider.notifier).state = const AsyncValue.loading();
    //ref.read(assetListProvider.notifier).state = const AsyncValue.loading();
    //ref.read(assetProportionProvider.notifier).state =
    const AsyncValue.loading();
  }

  Future<void> delTrade(Map<String, dynamic> param) async {
    await _tradeRepo.delTrade(param);
    //종목찾기, 관심종목 리스트 초기화
    ref.read(interProvider.notifier).state = const AsyncValue.loading();
    ref.read(corpProvider.notifier).state = const AsyncValue.loading();
    //거래일지 기업 리스트 초기화
    ref.read(tradeCorpListProvider.notifier).state = const AsyncValue.loading();
    //ref.read(tradeRecordProvider.notifier).state = const AsyncValue.loading();
    //목표관리 리스트 초기화
    //ref.read(planProvider.notifier).state = const AsyncValue.loading();
    //포트폴리오 초기화
    //ref.read(assetmanageProvider.notifier).state = const AsyncValue.loading();
    //ref.read(assetListProvider.notifier).state = const AsyncValue.loading();
    //ref.read(assetProportionProvider.notifier).state =
    const AsyncValue.loading();
  }
}

final tradeCorpListProvider =
    AsyncNotifierProvider<TradeCorpListVM, List<TradeCorpModel>?>(
  () => TradeCorpListVM(),
);

//거래일지 거래기록 프로바이더
class TradeRecordVM extends AsyncNotifier<List<TradeRecordModel>?> {
  late final TradeRepo _tradeRepo;

  @override
  FutureOr<List<TradeRecordModel>?> build() async {
    _tradeRepo = ref.read(tradeRepo);
    final curDate = DateTime.now();
    String year = curDate.year.toString();
    String month = curDate.month.toString().length == 1
        ? '0${curDate.month}'
        : '${curDate.month}';
    String day = curDate.day.toString().length == 1
        ? '0${curDate.day}'
        : '${curDate.day}';

    String stDate = '$year${month}01';
    String edDate = '$year$month$day';

    print('curdate : $year$month$day');

    final resData =
        await _tradeRepo.getTradeRecord({'pStDate': stDate, 'pEdDate': edDate});

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

  Future<void> getTradeRecord(Map<String, dynamic> param) async {
    final resData = await _tradeRepo.getTradeRecord(param);
    final List<dynamic> recordList = resData['assetRecord'];
    final int recordCnt = resData['assetRecordCnt'];
    if (recordCnt > 0) {
      final result = recordList.map((recordData) {
        return TradeRecordModel.fromJson(recordData);
      }).toList();
      state = AsyncValue.data(result);
    } else {
      state = const AsyncValue.data(null);
    }
  }
}

final tradeRecordProvider =
    AsyncNotifierProvider<TradeRecordVM, List<TradeRecordModel>?>(
  () => TradeRecordVM(),
);

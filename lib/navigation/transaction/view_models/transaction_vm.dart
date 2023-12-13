import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/navigation/transaction/models/trans_corp_model.dart';
import 'package:jb_finance/navigation/transaction/models/trans_record_model.dart';
import 'package:jb_finance/navigation/transaction/repos/transaction_repo.dart';

//거래일지 기업 리스트 프로바이더
class TransactionCorpVM extends AsyncNotifier<List<TransCorpModel>?> {
  @override
  FutureOr<List<TransCorpModel>?> build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}

final transCorpProvider =
    AsyncNotifierProvider<TransactionCorpVM, List<TransCorpModel>?>(
  () => TransactionCorpVM(),
);

//거래일지 거래기록 프로바이더
class TransactionRecordVM extends AsyncNotifier<List<TransRecordModel>?> {
  late final TransactionRepo _transactionRepo;

  @override
  FutureOr<List<TransRecordModel>?> build() async {
    _transactionRepo = ref.read(transactionRepo);
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

    final resData = await _transactionRepo
        .getTransRecord({'pStDate': stDate, 'pEdDate': edDate});

    final List<dynamic> record = resData['assetRecord'];
    final recordCnt = resData['assetRecordCnt'];

    if (recordCnt > 0) {
      final recordList = record.map((recordData) {
        return TransRecordModel.fromJson(recordData);
      });

      return recordList.toList();
    } else {
      return null;
    }
  }

  Future<void> getTransRecord(Map<String, dynamic> param) async {
    state = const AsyncValue.loading();
    final resData = await _transactionRepo.getTransRecord(param);
    final List<dynamic> recordList = resData['assetRecord'];
    final int recordCnt = resData['assetRecordCnt'];
    if (recordCnt > 0) {
      final result = recordList.map((recordData) {
        return TransRecordModel.fromJson(recordData);
      }).toList();
      state = AsyncValue.data(result);
    } else {
      state = const AsyncValue.data(null);
    }
  }
}

final transRecordProvider =
    AsyncNotifierProvider<TransactionRecordVM, List<TransRecordModel>?>(
  () => TransactionRecordVM(),
);

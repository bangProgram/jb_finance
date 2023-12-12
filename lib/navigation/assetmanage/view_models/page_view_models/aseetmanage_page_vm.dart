//자산관리 종목리스트 프로바이더
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/member/authentications.dart';
import 'package:jb_finance/navigation/assetmanage/models/assetmanage_list_model.dart';
import 'package:jb_finance/navigation/assetmanage/models/assetmanage_proportion_model.dart';
import 'package:jb_finance/navigation/assetmanage/models/assetmanage_record_model.dart';
import 'package:jb_finance/navigation/assetmanage/repos/assetmanage_repo.dart';
import 'package:jb_finance/navigation/assetmanage/repos/page_repos/aseetmanage_page_repo.dart';

class AssetmanageListVM extends AsyncNotifier<List<AssetmanageListModel>> {
  late final Authentications _auth;
  late final AssetmanagePageRepo _assetmanagePageRepo;

  @override
  FutureOr<List<AssetmanageListModel>> build() async {
    _auth = ref.read(authProvider);
    _assetmanagePageRepo = ref.read(assetmanagePageRepo);

    if (_auth.isLogin) {
      final responseData = await _assetmanagePageRepo.getAssetList();
      final List<dynamic> assetList = responseData['assetList'];
      final int assetCnt = responseData['assetListCnt'];
      if (assetCnt > 0) {
        final result = assetList.map((assetData) {
          return AssetmanageListModel.fromJson(assetData);
        });
        return result.toList();
      } else {
        return [AssetmanageListModel.empty()];
      }
    } else {
      return [AssetmanageListModel.empty()];
    }
  }

  Future<void> getAssetList() async {
    state = const AsyncValue.loading();
    final responseData = await _assetmanagePageRepo.getAssetList();
    final List<dynamic> assetList = responseData['assetList'];
    final int assetCnt = responseData['assetListCnt'];

    if (assetCnt > 0) {
      final result = assetList.map((assetData) {
        return AssetmanageListModel.fromJson(assetData);
      });
      state = AsyncValue.data(result.toList());
    } else {
      state = AsyncValue.data([AssetmanageListModel.empty()]);
    }
  }
}

final assetListProvider =
    AsyncNotifierProvider<AssetmanageListVM, List<AssetmanageListModel>>(
  () => AssetmanageListVM(),
);

//자산관리 거래일지 프로바이더
class AssetmanageRecordVM extends AsyncNotifier<List<AssetmanageRecordModel>?> {
  late final AssetmanagePageRepo _assetmanagePageRepo;

  @override
  FutureOr<List<AssetmanageRecordModel>?> build() async {
    _assetmanagePageRepo = ref.read(assetmanagePageRepo);
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

    final resData = await _assetmanagePageRepo
        .getAssetRecord({'pStDate': stDate, 'pEdDate': edDate});

    final List<dynamic> record = resData['assetRecord'];
    final recordCnt = resData['assetRecordCnt'];

    if (recordCnt > 0) {
      final recordList = record.map((recordData) {
        return AssetmanageRecordModel.fromJson(recordData);
      });

      return recordList.toList();
    } else {
      return null;
    }
  }

  Future<void> getAssetRecord(Map<String, dynamic> param) async {
    state = const AsyncValue.loading();
    final resData = await _assetmanagePageRepo.getAssetRecord(param);
    final List<dynamic> recordList = resData['assetRecord'];
    final int recordCnt = resData['assetRecordCnt'];
    if (recordCnt > 0) {
      final result = recordList.map((recordData) {
        return AssetmanageRecordModel.fromJson(recordData);
      }).toList();
      state = AsyncValue.data(result);
    } else {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> getAssetProportion(Map<String, dynamic> param) async {
    state = const AsyncValue.loading();
    final resData = await _assetmanagePageRepo.getAssetProportion(param);
    final List<dynamic> recordList = resData['assetProportion'];
    final int recordCnt = resData['assetProportionCnt'];

    if (recordCnt > 0) {
      final result = recordList.map((recordData) {
        return AssetmanageRecordModel.fromJson(recordData);
      }).toList();
      state = AsyncValue.data(result);
    } else {
      state = const AsyncValue.data(null);
    }
  }
}

final assetRecordProvider =
    AsyncNotifierProvider<AssetmanageRecordVM, List<AssetmanageRecordModel>?>(
  () => AssetmanageRecordVM(),
);

//자산관리 자산비중 프로바이더
class AssetmanageProportionVM
    extends AsyncNotifier<List<AssetmanageProportionModel>?> {
  late final AssetmanagePageRepo _assetmanagePageRepo;

  @override
  FutureOr<List<AssetmanageProportionModel>?> build() async {
    _assetmanagePageRepo = ref.read(assetmanagePageRepo);

    final resData = await _assetmanagePageRepo.getAssetProportion({});

    final List<dynamic> recordList = resData['assetProportion'];
    final int recordCnt = resData['assetProportionCnt'];

    if (recordCnt > 0) {
      final result = recordList.map((recordData) {
        return AssetmanageProportionModel.fromJson(recordData);
      });

      return result.toList();
    } else {
      return null;
    }
  }

  Future<void> getAssetProportion(Map<String, dynamic> param) async {
    state = const AsyncValue.loading();
    final resData = await _assetmanagePageRepo.getAssetProportion(param);
    final List<dynamic> recordList = resData['assetProportion'];
    final int recordCnt = resData['assetProportionCnt'];

    if (recordCnt > 0) {
      final result = recordList.map((recordData) {
        return AssetmanageProportionModel.fromJson(recordData);
      }).toList();
      state = AsyncValue.data(result);
    } else {
      state = const AsyncValue.data(null);
    }
  }
}

final assetProportionProvider = AsyncNotifierProvider<AssetmanageProportionVM,
    List<AssetmanageProportionModel>?>(
  () => AssetmanageProportionVM(),
);

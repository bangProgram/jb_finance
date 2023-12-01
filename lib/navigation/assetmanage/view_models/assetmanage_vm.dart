import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/member/authentications.dart';
import 'package:jb_finance/navigation/assetmanage/models/assetmanage_model.dart';
import 'package:jb_finance/navigation/assetmanage/models/assetmanage_list_model.dart';
import 'package:jb_finance/navigation/assetmanage/repos/assetmanage_repo.dart';
import 'package:jb_finance/utils.dart';

//자산관리 나의자산 프로바이더
class AssetmanageVM extends AsyncNotifier<AssetmanageModel> {
  late final Authentications _auth;
  late final AssetmanageRepo _assetmanageRepo;

  @override
  FutureOr<AssetmanageModel> build() async {
    _auth = ref.read(authProvider);
    _assetmanageRepo = ref.read(assetmanageRepo);

    if (_auth.isLogin) {
      final userId = _auth.getUserId;
      final responseData = await _assetmanageRepo.getPortAmount(userId);
      print('AssetmanageVM : ${responseData['message']}');
      final portfolioData = responseData['portAmountData'];
      if (portfolioData != null) {
        return AssetmanageModel.fromJson(portfolioData);
      } else {
        return AssetmanageModel.empty();
      }
    } else {
      return AssetmanageModel.empty();
    }
  }

  Future<void> getPortfolio() async {
    final userId = _auth.getUserId;
    final responseData = await _assetmanageRepo.getPortAmount(userId);
    final portfolioData = responseData['portAmountData'];
    if (portfolioData != null) {
      state = AsyncValue.data(AssetmanageModel.fromJson(portfolioData));
    }
    {
      state = AsyncValue.data(AssetmanageModel.empty());
    }
  }

  Future<void> updatePortfolio(
      BuildContext context, Map<String, dynamic> formData) async {
    state = const AsyncValue.loading();
    final userId = _auth.getUserId;
    state = await AsyncValue.guard(() async {
      final Map<String, dynamic> newForm = {
        ...formData,
        'userId': userId,
      };
      final result = await _assetmanageRepo.updatePortfolio(newForm);
      //true 일경우 update 성공
      if (result) {
        final responseData = await _assetmanageRepo.getPortAmount(userId);
        final portfolioData = responseData['portAmountData'];
        return AssetmanageModel.fromJson(portfolioData);
      } else {
        throw Exception('VM data 오류');
      }
    });

    if (state.hasError) {
      serverMessage(context, '${state.error}');
    }
  }
}

final assetmanageProvider =
    AsyncNotifierProvider<AssetmanageVM, AssetmanageModel>(
  () => AssetmanageVM(),
);

//자산관리 종목리스트 프로바이더
class AssetmanageListVM extends AsyncNotifier<List<AssetmanageListModel>> {
  late final Authentications _auth;
  late final AssetmanageRepo _assetmanageRepo;

  @override
  FutureOr<List<AssetmanageListModel>> build() async {
    _auth = ref.read(authProvider);
    _assetmanageRepo = ref.read(assetmanageRepo);

    if (_auth.isLogin) {
      final responseData = await _assetmanageRepo.getAssetList();
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
    final responseData = await _assetmanageRepo.getAssetList();
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

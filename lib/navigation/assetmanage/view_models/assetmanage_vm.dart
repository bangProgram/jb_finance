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
  late Authentications _auth;
  late AssetmanageRepo _assetmanageRepo;

  @override
  FutureOr<AssetmanageModel> build() async {
    _auth = ref.read(authProvider);
    _assetmanageRepo = ref.read(assetmanageRepo);

    print('vm 빌드 안하나? assetmanageProvider');
    if (_auth.isLogin) {
      final responseData = await _assetmanageRepo.getAssetAmount();
      final portfolioData = responseData['portAmountData'];
      print('vm 빌드 확인 : ${responseData['portAmountData']}');
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
    final responseData = await _assetmanageRepo.getAssetAmount();
    final portfolioData = responseData['portAmountData'];
    if (portfolioData != null) {
      state = AsyncValue.data(AssetmanageModel.fromJson(portfolioData));
    } else {
      state = AsyncValue.data(AssetmanageModel.empty());
    }
  }

  Future<void> mergeAssetAmount(
      BuildContext context, Map<String, dynamic> formData) async {
    state = await AsyncValue.guard(() async {
      final responseData = await _assetmanageRepo.mergeAssetAmount(formData);
      //true 일경우 update 성공
      final portfolioData = responseData['portAmountData'];
      if (portfolioData != null) {
        return AssetmanageModel.fromJson(portfolioData);
      } else {
        return AssetmanageModel.empty();
      }
    });

    if (state.hasError) {
      serverMessage(context, '자산 업데이트 오류');
    } else {
      successMessage(context, '저장되었습니다.');
    }
  }
}

final assetmanageProvider =
    AsyncNotifierProvider<AssetmanageVM, AssetmanageModel>(
  () => AssetmanageVM(),
);

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/navigation/finance/models/corporation_model.dart';
import 'package:jb_finance/navigation/finance/repos/corporation_repo.dart';
import 'package:jb_finance/navigation/finance/repos/interest_repo.dart';
import 'package:jb_finance/navigation/finance/view_models/corporation_vm.dart';
import 'package:jb_finance/navigation/planbook/view_models/planbook_vm.dart';
import 'package:jb_finance/utils.dart';

class InterestVM extends AsyncNotifier<List<CorporationModel>> {
  late InterestRepo _interestRepo;

  @override
  FutureOr<List<CorporationModel>> build() async {
    // TODO: implement build
    _interestRepo = ref.read(interestRepo);
    final resData = await _interestRepo.getCorpList({});
    final List<dynamic> fetchData = resData['corpList'];

    final corpList = fetchData.map((corpData) {
      return CorporationModel.fromJson(corpData);
    });

    print('interList : ${corpList.length}');
    if (resData['corpCnt'] > 0) {
      final List<dynamic> fetchData = resData['corpList'];

      print('test : ${fetchData.first.toString()}');

      final corpList = fetchData.map((corpData) {
        return CorporationModel.fromJson(corpData);
      });

      return corpList.toList();
    } else {
      return [CorporationModel.empty()];
    }
  }

  Future<void> getCorpList({Map<String, dynamic>? param}) async {
    print('getInter param : $param');

    state = await AsyncValue.guard(() async {
      final resData = await _interestRepo.getCorpList(param);
      if (resData['corpCnt'] > 0) {
        final List<dynamic> fetchData = resData['corpList'];

        print('test : ${fetchData.first.toString()}');

        final corpList = fetchData.map((corpData) {
          return CorporationModel.fromJson(corpData);
        });

        return corpList.toList();
      } else {
        return [CorporationModel.empty()];
      }
    });
  }

  Future<void> addInterest(Map<String, dynamic> param) async {
    await _interestRepo.addInterest(param);

    await getCorpList(param: {});

    //목표관리 리스트 초기화
    ref.read(planProvider.notifier).state = const AsyncValue.loading();
  }

  Future<void> delInterest(Map<String, dynamic> param) async {
    await _interestRepo.delInterest(param);

    await getCorpList(param: {});

    //목표관리 리스트 초기화
    ref.read(planProvider.notifier).state = const AsyncValue.loading();
  }

  Future<Map<String, dynamic>> initinterList() async {
    final initData = await _interestRepo.initinterList();
    return initData;
  }
}

final interProvider = AsyncNotifierProvider<InterestVM, List<CorporationModel>>(
  () => InterestVM(),
);

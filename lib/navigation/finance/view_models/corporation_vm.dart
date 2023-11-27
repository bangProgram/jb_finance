import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/navigation/finance/models/corporation_model.dart';
import 'package:jb_finance/navigation/finance/repos/corporation_repo.dart';
import 'package:jb_finance/utils.dart';

class CorporationVM extends AsyncNotifier<List<CorporationModel>> {
  late final CorporationRepo _corporationRepo;

  @override
  FutureOr<List<CorporationModel>> build() async {
    // TODO: implement build
    _corporationRepo = ref.read(corporationRepo);
    final resData = await _corporationRepo.getCorpList({});
    final List<dynamic> fetchData = resData['corpList'];

    final corpList = fetchData.map((corpData) {
      return CorporationModel.fromJson(corpData);
    });

    print('corpList : ${corpList.length}');
    return corpList.toList();
  }

  Future<void> getCorpList({Map<String, dynamic>? param}) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final resData = await _corporationRepo.getCorpList(param);
      final List<dynamic> fetchData = resData['corpList'];

      print('test : ${fetchData.first.toString()}');

      final corpList = fetchData.map((corpData) {
        return CorporationModel.fromJson(corpData);
      });

      return corpList.toList();
    });
  }
}

final corpProvider =
    AsyncNotifierProvider<CorporationVM, List<CorporationModel>>(
  () => CorporationVM(),
);

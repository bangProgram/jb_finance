import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/navigation/planbook/models/planbook_model.dart';
import 'package:jb_finance/navigation/planbook/repos/planbook_repo.dart';

//목표관리 프로바이더
class PlanbookVM extends AsyncNotifier<List<PlanbookModel>?> {
  late PlanbookRepo _planbookRepo;

  @override
  FutureOr<List<PlanbookModel>?> build() async {
    _planbookRepo = ref.read(planbookRepo);
    final resData = await _planbookRepo.getPlanbookList({});
    final List<dynamic> planbookList = resData['planbookList'];
    final int planbookCnt = resData['planbookCnt'];

    if (planbookCnt > 0) {
      final result = planbookList.map((planbook) {
        return PlanbookModel.fromJson(planbook);
      });

      return result.toList();
    } else {
      return null;
    }
  }

  Future<void> getPlanbookList() async {
    final resData = await _planbookRepo.getPlanbookList({});
    final List<dynamic> planbookList = resData['planbookList'];
    final int planbookCnt = resData['planbookCnt'];

    print('planbookList : $planbookList');
    if (planbookCnt > 0) {
      final result = planbookList.map((planbook) {
        return PlanbookModel.fromJson(planbook);
      });
      state = AsyncValue.data(result.toList());
    } else {
      state = const AsyncValue.data(null);
    }
  }
}

final planProvider = AsyncNotifierProvider<PlanbookVM, List<PlanbookModel>?>(
  () => PlanbookVM(),
);

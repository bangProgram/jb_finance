import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/navigation/planbook/models/planbook_model.dart';
import 'package:jb_finance/navigation/planbook/repos/planbook_repo.dart';

//목표관리 전체 프로바이더
class PlanbookVMAll extends AsyncNotifier<List<PlanbookModel>?> {
  late final PlanbookRepo _planbookRepo;

  @override
  FutureOr<List<PlanbookModel>?> build() async {
    _planbookRepo = ref.read(planbookRepo);
    final resData = await _planbookRepo.getPlanbookList({'pPeriodGubn': ''});
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
}

final planAllProvider =
    AsyncNotifierProvider<PlanbookVMAll, List<PlanbookModel>?>(
  () => PlanbookVMAll(),
);

//목표관리 단기 프로바이더
class PlanbookVMShort extends AsyncNotifier<List<PlanbookModel>?> {
  late final PlanbookRepo _planbookRepo;

  @override
  FutureOr<List<PlanbookModel>?> build() async {
    _planbookRepo = ref.read(planbookRepo);
    final resData =
        await _planbookRepo.getPlanbookList({'pPeriodGubn': '0601'});
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
}

final planShortProvider =
    AsyncNotifierProvider<PlanbookVMShort, List<PlanbookModel>?>(
  () => PlanbookVMShort(),
);

class PlanbookVMMedium extends AsyncNotifier<List<PlanbookModel>?> {
  late final PlanbookRepo _planbookRepo;

  @override
  FutureOr<List<PlanbookModel>?> build() async {
    _planbookRepo = ref.read(planbookRepo);
    final resData =
        await _planbookRepo.getPlanbookList({'pPeriodGubn': '0602'});
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
}

final planMediumProvider =
    AsyncNotifierProvider<PlanbookVMMedium, List<PlanbookModel>?>(
  () => PlanbookVMMedium(),
);

class PlanbookVMLong extends AsyncNotifier<List<PlanbookModel>?> {
  late final PlanbookRepo _planbookRepo;

  @override
  FutureOr<List<PlanbookModel>?> build() async {
    _planbookRepo = ref.read(planbookRepo);
    final resData =
        await _planbookRepo.getPlanbookList({'pPeriodGubn': '0603'});
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
}

final planLongProvider =
    AsyncNotifierProvider<PlanbookVMLong, List<PlanbookModel>?>(
  () => PlanbookVMLong(),
);

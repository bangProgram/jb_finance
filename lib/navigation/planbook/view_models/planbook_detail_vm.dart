import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/navigation/planbook/models/plan_detail_info_model.dart';
import 'package:jb_finance/navigation/planbook/models/plan_detail_memo_model.dart';
import 'package:jb_finance/navigation/planbook/repos/planbook_repo.dart';

class PlanDetailInfoVM
    extends FamilyAsyncNotifier<PlanDetailInfoModel, String> {
  late final PlanbookRepo _planbookRepo;

  @override
  FutureOr<PlanDetailInfoModel> build(String arg) async {
    _planbookRepo = ref.read(planbookRepo);

    final resData = await _planbookRepo.getPlanDetailInfo({'pCorpCode': arg});
    final planDetailInfo = resData['planDetailInfo'];

    final result = PlanDetailInfoModel.fromJson(planDetailInfo);

    return result;
  }

  Future<void> refreshState() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () async {
        final resData =
            await _planbookRepo.getPlanDetailInfo({'pCorpCode': arg});
        final planDetailInfo = resData['planDetailInfo'];
        return PlanDetailInfoModel.fromJson(planDetailInfo);
      },
    );
  }
}

final planDetailInfoProvider =
    AsyncNotifierProvider.family<PlanDetailInfoVM, PlanDetailInfoModel, String>(
  () => PlanDetailInfoVM(),
);

class PlanDetailMemoVM
    extends FamilyAsyncNotifier<List<PlanDetailMemoModel>?, String> {
  late final PlanbookRepo _planbookRepo;
  late final String _corpCode;

  @override
  FutureOr<List<PlanDetailMemoModel>?> build(String arg) async {
    _planbookRepo = ref.read(planbookRepo);
    _corpCode = arg;

    final resData = await _planbookRepo.getPlanDetailMemo({'pCorpCode': arg});
    final List<dynamic> memoList = resData['planDetailMemo'];
    final memoCnt = resData['planDetailMemoCnt'];

    if (memoCnt > 0) {
      final result = memoList.map((memoData) {
        return PlanDetailMemoModel.fromJson(memoData);
      });
      return result.toList();
    } else {
      return null;
    }
  }

  Future<void> addPlanMemo(String memo) async {
    Map<String, dynamic> param = {'pCorpCode': _corpCode, 'pMemo': memo};

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final resData = await _planbookRepo.addPlanMemo(param);
      final List<dynamic> memoList = resData['planDetailMemo'];
      final memoCnt = resData['planDetailMemoCnt'];

      if (memoCnt > 0) {
        final result = memoList.map((memoData) {
          return PlanDetailMemoModel.fromJson(memoData);
        });
        return result.toList();
      } else {
        return null;
      }
    });
  }

  Future<void> delPlanMemo(int seq) async {
    Map<String, dynamic> param = {'pCorpCode': _corpCode, 'pSeq': seq};

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final resData = await _planbookRepo.delPlanMemo(param);
      final List<dynamic> memoList = resData['planDetailMemo'];
      final memoCnt = resData['planDetailMemoCnt'];

      if (memoCnt > 0) {
        final result = memoList.map((memoData) {
          return PlanDetailMemoModel.fromJson(memoData);
        });
        return result.toList();
      } else {
        return null;
      }
    });
  }
}

final planDetailMemoProvider = AsyncNotifierProvider.family<PlanDetailMemoVM,
    List<PlanDetailMemoModel>?, String>(
  () => PlanDetailMemoVM(),
);

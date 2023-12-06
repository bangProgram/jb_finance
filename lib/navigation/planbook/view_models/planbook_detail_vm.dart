import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jb_finance/navigation/planbook/models/planbook_detail_model.dart';
import 'package:jb_finance/navigation/planbook/repos/planbook_repo.dart';

class PlanbookDetailVM
    extends FamilyAsyncNotifier<PlanbookDetailModel, String> {
  late final PlanbookRepo _planbookRepo;

  @override
  FutureOr<PlanbookDetailModel> build(String arg) async {
    _planbookRepo = ref.read(planbookRepo);

    final resData = await _planbookRepo.getPlanbookDetail({'pCorpCode': arg});
    final planbookDetail = resData['planbookDetail'];

    final result = PlanbookDetailModel.fromJson(planbookDetail);

    return result;
  }

  Future<void> refreshState() async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () async {
        final resData =
            await _planbookRepo.getPlanbookDetail({'pCorpCode': arg});
        final planbookDetail = resData['planbookDetail'];
        return PlanbookDetailModel.fromJson(planbookDetail);
      },
    );
  }
}

final planDetailProvider =
    AsyncNotifierProvider.family<PlanbookDetailVM, PlanbookDetailModel, String>(
  () => PlanbookDetailVM(),
);

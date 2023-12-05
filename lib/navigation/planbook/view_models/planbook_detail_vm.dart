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

    final resData = await _planbookRepo.getPlanbookList({'pCorpCode': arg});
    final planbookDetail = resData['planbookDetail'];

    final result = PlanbookDetailModel.fromJson(planbookDetail);

    return result;
  }
}

final planDetailProvider =
    AsyncNotifierProvider.family<PlanbookDetailVM, PlanbookDetailModel, String>(
  () => PlanbookDetailVM(),
);

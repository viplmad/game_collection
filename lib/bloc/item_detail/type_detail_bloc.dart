import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import '../item_detail_manager/item_detail_manager.dart';
import 'item_detail.dart';


class TypeDetailBloc extends ItemDetailBloc<PurchaseType> {
  TypeDetailBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
    required TypeDetailManagerBloc managerBloc,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository, managerBloc: managerBloc);

  @override
  Stream<PurchaseType?> getReadStream() {

    return iCollectionRepository.getTypeWithId(itemId);

  }
}
import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/collection_item.dart';
import 'package:game_collection/model/purchase.dart';

import 'item.dart';


class PurchaseBloc extends ItemBloc {

  PurchaseBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Purchase> createFuture() {

    return collectionRepository.insertPurchase('');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem event) {

    return collectionRepository.deletePurchase(event.item.ID);

  }

}
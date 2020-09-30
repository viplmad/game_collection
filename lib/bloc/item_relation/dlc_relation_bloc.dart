import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/bloc/item/item.dart';

import 'item_relation.dart';


class DLCRelationBloc<W extends CollectionItem> extends ItemRelationBloc<DLC, W> {

  DLCRelationBloc({
    @required int dlcID,
    @required DLCBloc itemBloc,
  }) : super(itemID: dlcID, itemBloc: itemBloc);

  @override
  Stream<List<W>> getRelationStream() {

    switch(W) {
      case Game:
        return collectionRepository.getBaseGameFromDLC(itemID).map<List<Game>>( (Game game) => game != null? [game] : [] ) as Stream<List<W>>;
      case Purchase:
        return collectionRepository.getPurchasesFromDLC(itemID) as Stream<List<W>>;
    }

    return super.getRelationStream();

  }

}
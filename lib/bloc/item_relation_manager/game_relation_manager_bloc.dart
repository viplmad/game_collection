import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_relation_manager.dart';


class GameRelationManagerBloc<W extends CollectionItem> extends ItemRelationManagerBloc<Game, W> {
  GameRelationManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddItemRelation<W> event) {

    int otherId = event.otherItem.id;

    switch(W) {
      case DLC:
        return iCollectionRepository.relateGameDLC(itemId, otherId);
      case Purchase:
        return iCollectionRepository.relateGamePurchase(itemId, otherId);
      case Platform:
        return iCollectionRepository.relateGamePlatform(itemId, otherId);
      case Tag:
        return iCollectionRepository.relateGameTag(itemId, otherId);
    }

    return super.addRelationFuture(event);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteItemRelation<W> event) {

    int otherId = event.otherItem.id;

    switch(W) {
      case DLC:
        return iCollectionRepository.deleteGameDLC(otherId);
      case Purchase:
        return iCollectionRepository.deleteGamePurchase(itemId, otherId);
      case Platform:
        return iCollectionRepository.deleteGamePlatform(itemId, otherId);
      case Tag:
        return iCollectionRepository.deleteGameTag(itemId, otherId);
    }

    return super.deleteRelationFuture(event);

  }
}

class GameTimeLogRelationManagerBloc extends RelationManagerBloc<Game, TimeLog> {
  GameTimeLogRelationManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddRelation<TimeLog> event) {

    return iCollectionRepository.relateGameTimeLog(itemId, event.otherItem.dateTime, event.otherItem.time);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteRelation<TimeLog> event) {

    return iCollectionRepository.deleteGameTimeLog(itemId, event.otherItem.dateTime);

  }
}

class GameFinishDateRelationManagerBloc extends RelationManagerBloc<Game, DateTime> {
  GameFinishDateRelationManagerBloc({
    required int itemId,
    required ICollectionRepository iCollectionRepository,
  }) : super(itemId: itemId, iCollectionRepository: iCollectionRepository);

  @override
  Future<dynamic> addRelationFuture(AddRelation<DateTime> event) {

    return iCollectionRepository.relateGameFinishDate(itemId, event.otherItem);

  }

  @override
  Future<dynamic> deleteRelationFuture(DeleteRelation<DateTime> event) {

    return iCollectionRepository.deleteGameFinishDate(itemId, event.otherItem);

  }
}
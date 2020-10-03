import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_list.dart';


class AllListBloc extends ItemListBloc<Game> {

  AllListBloc({
    @required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Stream<List<Game>> getReadAllStream() {

    return iCollectionRepository.getAll();

  }

  @override
  Future<Game> createFuture(AddItem event) {

    return iCollectionRepository.insertGame(event.title ?? '', '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Game> event) {

    return iCollectionRepository.deleteGame(event.item.ID);

  }

  @override
  Stream<List<Game>> getReadViewStream(UpdateView event) {

    GameView gameView = GameView.values[event.viewIndex];

    return iCollectionRepository.getAllWithView(gameView);

  }

}
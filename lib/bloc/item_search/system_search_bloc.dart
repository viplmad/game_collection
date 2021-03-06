import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_search.dart';


class SystemSearchBloc extends ItemSearchBloc<System> {
  SystemSearchBloc({
    required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<List<System>> getInitialItems() {

    return iCollectionRepository!.getSystemsWithView(SystemView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<System>> getSearchItems(String query) {

    return iCollectionRepository!.getSystemsWithName(query, super.maxResults).first;

  }
}
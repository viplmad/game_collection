import 'dart:async';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'item_search.dart';


class DLCSearchBloc extends ItemSearchBloc<DLC> {
  DLCSearchBloc({
    required ICollectionRepository iCollectionRepository,
  }) : super(iCollectionRepository: iCollectionRepository);

  @override
  Future<List<DLC>> getInitialItems() {

    return iCollectionRepository!.getDLCsWithView(DLCView.LastCreated, super.maxSuggestions).first;

  }

  @override
  Future<List<DLC>> getSearchItems(String query) {

    return iCollectionRepository!.getDLCsWithName(query, super.maxResults).first;

  }
}
import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_search/item_search.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'search.dart';


class DLCSearch extends ItemSearch<DLC, DLCSearchBloc, DLCListManagerBloc> {
  const DLCSearch({
    Key? key,
  }) : super(key: key);

  @override
  DLCSearchBloc searchBlocBuilder() {

    return DLCSearchBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

  }

  @override
  DLCListManagerBloc managerBlocBuilder() {

    return DLCListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

  }

  @override
  _DLCSearchBody<DLCSearchBloc> itemSearchBodyBuilder({required void Function() Function(BuildContext, DLC) onTap, required bool allowNewButton}) {

    return _DLCSearchBody<DLCSearchBloc>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class DLCLocalSearch extends ItemLocalSearch<DLC, DLCListManagerBloc> {
  const DLCLocalSearch({
    Key? key,
    required List<DLC> items,
  }) : super(key: key, items: items);

  @override
  final String detailRouteName = dlcDetailRoute;

  @override DLCListManagerBloc managerBlocBuilder() {

    return DLCListManagerBloc(
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

  }

  @override
  _DLCSearchBody<ItemLocalSearchBloc<DLC>> itemSearchBodyBuilder({required void Function() Function(BuildContext, DLC) onTap, required bool allowNewButton}) {

    return _DLCSearchBody<ItemLocalSearchBloc<DLC>>(
      onTap: onTap,
      allowNewButton: allowNewButton,
    );

  }
}

class _DLCSearchBody<K extends ItemSearchBloc<DLC>> extends ItemSearchBody<DLC, K, DLCListManagerBloc> {
  const _DLCSearchBody({
    Key? key,
    required void Function() Function(BuildContext, DLC) onTap,
    bool allowNewButton = false,
  }) : super(key: key, onTap: onTap, allowNewButton: allowNewButton);

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).dlcString;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).dlcsString;

  @override
  Widget cardBuilder(BuildContext context, DLC item) => DLCTheme.itemCard(context, item, onTap);
}
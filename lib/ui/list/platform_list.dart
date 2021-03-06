import 'package:flutter/material.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import 'list.dart';


class PlatformAppBar extends ItemAppBar<Platform, PlatformListBloc> {
  const PlatformAppBar({
    Key? key,
  }) : super(key: key);

  @override
  final Color themeColor = PlatformTheme.primaryColour;

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).platformsString;

  @override
  List<String> views(BuildContext context) => PlatformTheme.views(context);
}

class PlatformFAB extends ItemFAB<Platform, PlatformListManagerBloc> {
  const PlatformFAB({
    Key? key,
  }) : super(key: key);

  @override
  final Color themeColor = PlatformTheme.primaryColour;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).platformString;
}

class PlatformList extends ItemList<Platform, PlatformListBloc, PlatformListManagerBloc> {
  const PlatformList({
    Key? key,
  }) : super(key: key);

  @override
  final String detailRouteName = platformDetailRoute;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).platformString;

  @override
  _PlatformListBody itemListBodyBuilder({required List<Platform> items, required int viewIndex, required int viewYear, required void Function(Platform) onDelete, required ListStyle style}) {

    return _PlatformListBody(
      items: items,
      viewIndex: viewIndex,
      viewYear: viewYear,
      onDelete: onDelete,
      style: style,
    );

  }
}

class _PlatformListBody extends ItemListBody<Platform, PlatformListBloc> {
  const _PlatformListBody({
    Key? key,
    required List<Platform> items,
    required int viewIndex,
    required int viewYear,
    required void Function(Platform) onDelete,
    required ListStyle style,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
    viewYear: viewYear,
    onDelete: onDelete,
    style: style,
  );

  @override
  final String detailRouteName = platformDetailRoute;

  @override
  final String localSearchRouteName = platformLocalSearchRoute;

  @override
  final String statisticsRouteName = '';

  @override
  void Function() onStatisticsTap(BuildContext context) => () => {};

  @override
  String itemTitle(Platform item) => PlatformTheme.itemTitle(item);

  @override
  String viewTitle(BuildContext context) => PlatformTheme.views(context).elementAt(viewIndex);

  @override
  Widget cardBuilder(BuildContext context, Platform item) => PlatformTheme.itemCard(context, item, onTap);

  @override
  Widget gridBuilder(BuildContext context, Platform item) => PlatformTheme.itemGrid(context, item, onTap);
}
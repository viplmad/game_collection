import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';
import 'package:game_collection/model/app_tab.dart';

import 'package:game_collection/bloc/tab/tab.dart';
import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../theme/theme.dart';
import '../common/tabs_delegate.dart';
import '../common/year_picker_dialog.dart';
import '../statistics/statistics.dart';
import 'list.dart';


class GameAppBar extends StatelessWidget {
  const GameAppBar({
    Key? key,
    required this.gameTab,
  }) : super(key: key);

  final GameTab gameTab;

  @override
  Widget build(BuildContext context) {

    switch(gameTab) {
      case GameTab.all:
        return _AllAppBar();
      case GameTab.game:
        return _OwnedAppBar();
      case GameTab.rom:
        return _RomAppBar();
    }

  }
}

class _AllAppBar extends _GameAppBar<AllListBloc> {}
class _OwnedAppBar extends _GameAppBar<OwnedListBloc> {}
class _RomAppBar extends _GameAppBar<RomListBloc> {}

abstract class _GameAppBar<K extends ItemListBloc<Game>> extends ItemAppBar<Game, K> {
  const _GameAppBar({
    Key? key,
  }) : super(key: key);

  @override
  final Color themeColor = GameTheme.primaryColour;

  @override
  void Function(int) onSelected(BuildContext context, List<String> views) {

    return (int selectedViewIndex) async {

      if(selectedViewIndex == views.length - 1) {
        int? year = await showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            return Theme(
              data: GameTheme.themeData(context),
              child: YearPickerDialog(),
            );
          },
        );

        if(year != null) {
          BlocProvider.of<K>(context).add(UpdateYearView(selectedViewIndex, year));
        }
      } else {

        BlocProvider.of<K>(context).add(UpdateView(selectedViewIndex));

      }
    };

  }

  @override
  String typesName(BuildContext context) => GameCollectionLocalisations.of(context).gamesString;

  @override
  List<String> views(BuildContext context) => GameTheme.views(context);
}


class GameFAB extends StatelessWidget {
  const GameFAB({
    Key? key,
    required this.gameTab,
  }) : super(key: key);

  final GameTab gameTab;

  @override
  Widget build(BuildContext context) {

    switch(gameTab) {
      case GameTab.all:
        return _AllFAB();
      case GameTab.game:
        return _OwnedFAB();
      case GameTab.rom:
        return _RomFAB();
    }

  }
}

class _AllFAB extends _GameFAB<AllListManagerBloc> {}
class _OwnedFAB extends _GameFAB<OwnedListManagerBloc> {}
class _RomFAB extends _GameFAB<RomListManagerBloc> {}

abstract class _GameFAB<S extends ItemListManagerBloc<Game>> extends ItemFAB<Game, S> {
  const _GameFAB({
    Key? key,
  }) : super(key: key);

  @override
  final Color themeColor = GameTheme.primaryColour;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).gameString;
}

class GameTabs extends StatelessWidget {
  const GameTabs({
    Key? key,
    required this.gameTab,
  }) : super(key: key);

  final GameTab gameTab;

  @override
  Widget build(BuildContext context) {
    List<String> tabTitles = [
      GameCollectionLocalisations.of(context).allString,
      GameCollectionLocalisations.of(context).ownedString,
      GameCollectionLocalisations.of(context).romsString,
    ];

    return DefaultTabController(
      length: tabTitles.length,
      initialIndex: gameTab.index,
      child: Builder(
        builder: (BuildContext context) {
          DefaultTabController.of(context)!.addListener( () {
            GameTab newGameTab = GameTab.values.elementAt(DefaultTabController.of(context)!.index);

            BlocProvider.of<TabBloc>(context).add(UpdateGameTab(newGameTab));
          });

          return NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverPersistentHeader(
                  pinned: false,
                  floating: true,
                  delegate: TabsDelegate(
                    tabBar: TabBar(
                      tabs: tabTitles.map<Tab>( (String title) {
                        return Tab(
                          text: title,
                        );
                      }).toList(growable: false),
                    ),
                    color: GameTheme.accentColour,
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                _AllGameList(
                  tabTitle: tabTitles.elementAt(0),
                ),
                _OwnedGameList(
                  tabTitle: tabTitles.elementAt(1),
                ),
                _RomGameList(
                  tabTitle: tabTitles.elementAt(2),
                ),
              ],
            ),
          );
        },
      ),
    );

  }
}

class _AllGameList extends _GameList<AllListBloc, AllListManagerBloc> {
  const _AllGameList({
    required String tabTitle,
  }) : super(tabTitle: tabTitle);
}
class _OwnedGameList extends _GameList<OwnedListBloc, OwnedListManagerBloc> {
  const _OwnedGameList({
    required String tabTitle,
  }) : super(tabTitle: tabTitle);
}
class _RomGameList extends _GameList<RomListBloc, RomListManagerBloc> {
  const _RomGameList({
    required String tabTitle,
  }) : super(tabTitle: tabTitle);
}

abstract class _GameList<K extends ItemListBloc<Game>, S extends ItemListManagerBloc<Game>> extends ItemList<Game, K, S> {
  const _GameList({
    Key? key,
    required this.tabTitle,
  }) : super(key: key);

  final String tabTitle;

  @override
  final String detailRouteName = gameDetailRoute;

  @override
  String typeName(BuildContext context) => GameCollectionLocalisations.of(context).gameString;

  @override
  _GameListBody<K> itemListBodyBuilder({required List<Game> items, required int viewIndex, required int viewYear, required void Function(Game) onDelete, required ListStyle style}) {

    return _GameListBody<K>(
      items: items,
      viewIndex: viewIndex,
      viewYear: viewYear,
      onDelete: onDelete,
      style: style,
      tabTitle: tabTitle,
    );

  }
}

class _GameListBody<K extends ItemListBloc<Game>> extends ItemListBody<Game, K> {
  const _GameListBody({
    Key? key,
    required List<Game> items,
    required int viewIndex,
    required int viewYear,
    required void Function(Game) onDelete,
    required ListStyle style,
    required this.tabTitle,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
    viewYear: viewYear,
    onDelete: onDelete,
    style: style,
  );

  final String tabTitle;

  @override
  final String detailRouteName = gameDetailRoute;

  @override
  final String localSearchRouteName = gameLocalSearchRoute;

  @override
  final String statisticsRouteName = gameStatisticsRoute;

  void Function() onStatisticsTap(BuildContext context) {

    return () {
      Navigator.pushNamed(
        context,
        statisticsRouteName,
        arguments: GameStatisticsArguments(
          items: items,
          viewTitle: viewTitle(context),
          tabTitle: tabTitle,
        ),
      );
    };

  }

  @override
  String itemTitle(Game item) => GameTheme.itemTitle(item);

  @override
  String viewTitle(BuildContext context) => GameTheme.views(context).elementAt(viewIndex) + ((!viewYear.isNegative)? ' (' + GameCollectionLocalisations.of(context).yearString(viewYear) + ')' : '');

  @override
  Widget cardBuilder(BuildContext context, Game item) => GameTheme.itemCard(context, item, onTap);

  @override
  Widget gridBuilder(BuildContext context, Game item) => GameTheme.itemGrid(context, item, onTap);
}
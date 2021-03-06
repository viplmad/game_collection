import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/model/model.dart';
import 'package:game_collection/model/list_style.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_list_manager/item_list_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../common/item_view.dart';
import '../common/loading_icon.dart';
import '../common/show_snackbar.dart';
import '../detail/detail.dart';
import '../statistics/statistics.dart';


abstract class ItemAppBar<T extends CollectionItem, K extends ItemListBloc<T>> extends StatelessWidget with PreferredSizeWidget {
  const ItemAppBar({
    Key? key,
  }) : super(key: key);

  @override
  final Size preferredSize = const Size.fromHeight(kToolbarHeight);

  Color get themeColor;

  @override
  Widget build(BuildContext context) {

    return AppBar(
      title: Text(typesName(context)),
      backgroundColor: themeColor,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.sort_by_alpha),
          tooltip: GameCollectionLocalisations.of(context).changeOrderString,
          onPressed: () {
            BlocProvider.of<K>(context).add(UpdateSortOrder());
          },
        ),
        IconButton(
          icon: Icon(Icons.grid_on),
          tooltip: GameCollectionLocalisations.of(context).changeStyleString,
          onPressed: () {
            BlocProvider.of<K>(context).add(UpdateStyle());
          },
        ),
        _viewActionBuilder(
          context,
          views: views(context),
        ),
      ],
    );

  }

  Widget _viewActionBuilder(BuildContext context, {required List<String> views}) {

    return PopupMenuButton<int>(
      icon: Icon(Icons.view_carousel),
      tooltip: GameCollectionLocalisations.of(context).changeViewString,
      itemBuilder: (BuildContext context) {
        return views.map( (String view) {
          return PopupMenuItem<int>(
            child: ListTile(
              title: Text(view),
            ),
            value: views.indexOf(view),
          );
        }).toList(growable: false);
      },
      onSelected: onSelected(context, views),
    );

  }

  void Function(int) onSelected(BuildContext context, List<String> views) {

    return (int selectedViewIndex) {
      BlocProvider.of<K>(context).add(UpdateView(selectedViewIndex));
    };

  }

  String typesName(BuildContext context);
  List<String> views(BuildContext context);
}

abstract class ItemFAB<T extends CollectionItem, S extends ItemListManagerBloc<T>> extends StatelessWidget {
  const ItemFAB({
    Key? key,
  }) : super(key: key);

  Color get themeColor;

  @override
  Widget build(BuildContext context) {

    return FloatingActionButton(
      tooltip: GameCollectionLocalisations.of(context).newString(typeName(context)),
      child: Icon(Icons.add),
      backgroundColor: themeColor,
      onPressed: () {
        BlocProvider.of<S>(context).add(AddItem());
      },
    );

  }

  String typeName(BuildContext context);
}

abstract class ItemList<T extends CollectionItem, K extends ItemListBloc<T>, S extends ItemListManagerBloc<T>> extends StatelessWidget {
  const ItemList({
    Key? key,
  }) : super(key: key);

  String get detailRouteName;

  @override
  Widget build(BuildContext context) {
    String currentTypeString = typeName(context);

    return BlocListener<S, ItemListManagerState>(
      listener: (BuildContext context, ItemListManagerState state) {
        if(state is ItemAdded<T>) {
          String message = GameCollectionLocalisations.of(context).addedString(currentTypeString);
          showSnackBar(
            context,
            message: message,
            seconds: 2,
            snackBarAction: SnackBarAction(
              label: GameCollectionLocalisations.of(context).openString,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  detailRouteName,
                  arguments: DetailArguments(
                    item: state.item,
                  )
                );
              },
            ),
          );
        }
        if(state is ItemNotAdded) {
          String message = GameCollectionLocalisations.of(context).unableToAddString(currentTypeString);
          showSnackBar(
            context,
            message: message,
            seconds: 2,
            snackBarAction: dialogSnackBarAction(
              context,
              label: GameCollectionLocalisations.of(context).moreString,
              title: message,
              content: state.error,
            ),
          );
        }
        if(state is ItemDeleted<T>) {
          String message = GameCollectionLocalisations.of(context).deletedString(currentTypeString);
          showSnackBar(
            context,
            message: message,
            seconds: 2,
          );
        }
        if(state is ItemNotDeleted) {
          String message = GameCollectionLocalisations.of(context).unableToDeleteString(currentTypeString);
          showSnackBar(
            context,
            message: message,
            seconds: 2,
            snackBarAction: dialogSnackBarAction(
              context,
              label: GameCollectionLocalisations.of(context).moreString,
              title: message,
              content: state.error,
            ),
          );
        }
      },
      child: BlocBuilder<K, ItemListState>(
        builder: (BuildContext context, ItemListState state) {

          if(state is ItemListLoaded<T>) {

            return itemListBodyBuilder(
              items: state.items,
              viewIndex: state.viewIndex,
              viewYear: state.year,
              onDelete: (T item) {
                BlocProvider.of<S>(context).add(DeleteItem<T>(item));
              },
              style: state.style,
            );

          }
          if(state is ItemListNotLoaded) {

            return Center(
              child: Text(state.error),
            );

          }

          return LoadingIcon();

        },
      ),
    );

  }

  String typeName(BuildContext context);

  ItemListBody<T, K> itemListBodyBuilder({required List<T> items, required int viewIndex, required int viewYear, required void Function(T) onDelete, required ListStyle style});
}

abstract class ItemListBody<T extends CollectionItem, K extends ItemListBloc<T>> extends StatelessWidget {
  const ItemListBody({
    Key? key,
    required this.items,
    required this.viewIndex,
    required this.viewYear,
    required this.onDelete,
    required this.style,
  }) : super(key: key);

  final List<T> items;
  final int viewIndex;
  final int viewYear;
  final void Function(T) onDelete;
  final ListStyle style;

  String get detailRouteName;
  String get localSearchRouteName;
  String get statisticsRouteName;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Container(
          child: ListTile(
            title: Text(viewTitle(context)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  tooltip: GameCollectionLocalisations.of(context).searchInViewString,
                  onPressed: items.isNotEmpty? _onSearchTap(context) : null,
                ),
                statisticsRouteName.isNotEmpty?
                  IconButton(
                    icon: Icon(Icons.insert_chart),
                    tooltip: GameCollectionLocalisations.of(context).statsInViewString,
                    onPressed: items.isNotEmpty? onStatisticsTap(context) : null,
                  ) : Container(),
              ],
            ),
          ),
          color: Colors.grey,
        ),
        Expanded(
          child: Scrollbar(
            child: _listBuilder(context),
          ),
        ),
      ],
    );

  }

  Widget _confirmDelete(BuildContext context, T item) {

    return AlertDialog(
      title: Text(GameCollectionLocalisations.of(context).deleteString),
      content: ListTile(
        title: Text(GameCollectionLocalisations.of(context).deleteDialogTitle(itemTitle(item))),
        subtitle: Text(GameCollectionLocalisations.of(context).deleteDialogSubtitle),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          onPressed: () {
            Navigator.maybePop<bool>(context);
          },
        ),
        RaisedButton(
          child: Text(GameCollectionLocalisations.of(context).deleteString, style: TextStyle(color: Colors.white)),
          onPressed: () {
            Navigator.maybePop<bool>(context, true);
          },
          color: Colors.red,
        )
      ],
    );

  }

  Widget _listBuilder(BuildContext context) {

    switch(style) {
      case ListStyle.Card:
        return ItemCardView<T>(
          items: items,
          itemBuilder: cardBuilder,
          onDismiss: onDelete,
          confirmDelete: _confirmDelete,
        );
      case ListStyle.Grid:
        return ItemGridView<T>(
          items: items,
          itemBuilder: gridBuilder,
        );
    }

  }

  void Function() onTap(BuildContext context, T item) {

    return () {
      Navigator.pushNamed(
        context,
        detailRouteName,
        arguments: DetailArguments<T>(
          item: item,
          onUpdate: (T? updatedItem) {

            if(updatedItem != null) {

              BlocProvider.of<K>(context).add(UpdateListItem<T>(updatedItem));

            }

          },
        ),
      );
    };

  }

  void Function() _onSearchTap(BuildContext context) {

    return () {
      Navigator.pushNamed(
        context,
        localSearchRouteName,
        arguments: items,
      );
    };

  }

  void Function() onStatisticsTap(BuildContext context) {

    return () {
      Navigator.pushNamed(
        context,
        statisticsRouteName,
        arguments: StatisticsArguments<T>(
          items: items,
          viewTitle: viewTitle(context),
        ),
      );
    };

  }

  String itemTitle(T item);
  String viewTitle(BuildContext context);

  Widget cardBuilder(BuildContext context, T item);
  Widget gridBuilder(BuildContext context, T item);
}

class ItemCardView<T extends CollectionItem> extends StatelessWidget {
  const ItemCardView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.onDismiss,
    required this.confirmDelete,
  }) : super(key: key);

  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(T item) onDismiss;
  final Widget Function(BuildContext, T) confirmDelete;

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        T item = items[index];

        return DismissibleItem(
          dismissibleKey: item.id,
          itemWidget: itemBuilder(context, item),
          onDismissed: (DismissDirection direction) {
            onDismiss(item);
          },
          confirmDismiss: (DismissDirection direction) {

            return showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return confirmDelete(context, item);
              },
            ).then((bool? value) => value?? false);

          },
          dismissIcon: Icons.delete,
        );

      },
    );

  }
}

class ItemGridView<T extends CollectionItem> extends StatelessWidget {
  const ItemGridView({
    Key? key,
    required this.items,
    required this.itemBuilder,
  }) : super(key: key);

  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;

  @override
  Widget build(BuildContext context) {

    return GridView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (BuildContext context, int index) {
        T item = items[index];

        return itemBuilder(context, item);

      },
    );

  }
}
import 'package:flutter/material.dart';

import 'package:game_collection/bloc/item_list/item_list.dart';
import 'package:game_collection/bloc/item_detail/item_detail.dart';

import 'package:game_collection/model/list_style.dart';
import 'package:game_collection/model/bar_data.dart';
import 'package:game_collection/model/model.dart';

import '../theme/theme.dart';
import '../detail/detail.dart';
import '../statistics/statistics.dart';

import 'list.dart';


class DLCAppBar extends ItemAppBar<DLC, DLCListBloc> {

  @override
  BarData getBarData() {

    return dlcBarData;

  }

}

class DLCFAB extends ItemFAB<DLC, DLCListBloc> {

  @override
  BarData getBarData() {

    return dlcBarData;

  }

}

class DLCList extends ItemList<DLC, DLCListBloc> {

  @override
  ItemDetail<DLC, DLCDetailBloc> detailBuilder(DLC dlc) {

    return DLCDetail(
      item: dlc,
    );

  }

  @override
  _DLCListBody itemListBodyBuilder({@required List<DLC> items, @required int viewIndex, @required void Function(DLC) onDelete, @required ListStyle style}) {

    return _DLCListBody(
      items: items,
      viewIndex: viewIndex,
      onDelete: onDelete,
      style: style,
    );

  }

}

class _DLCListBody extends ItemListBody<DLC> {

  _DLCListBody({
    Key key,
    @required List<DLC> items,
    @required int viewIndex,
    @required void Function(DLC) onDelete,
    @required ListStyle style,
  }) : super(
    key: key,
    items: items,
    viewIndex: viewIndex,
    onDelete: onDelete,
    style: style,
  );

  @override
  String getViewTitle() {

    return dlcBarData.views.elementAt(viewIndex);

  }

  @override
  ItemDetail<DLC, DLCDetailBloc> detailBuilder(DLC dlc) {

    return DLCDetail(
      item: dlc,
    );

  }

  @override
  Widget statisticsBuilder() {

    return null;

  }

}
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_collection/entity/entity.dart';

import 'package:game_collection/model/model.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/bloc/item_detail/item_detail.dart';
import 'package:game_collection/bloc/item_detail_manager/item_detail_manager.dart';
import 'package:game_collection/bloc/item_relation/item_relation.dart';
import 'package:game_collection/bloc/item_relation_manager/item_relation_manager.dart';

import 'package:game_collection/localisations/localisations.dart';

import '../route_constants.dart';
import '../relation/relation.dart';
import '../theme/theme.dart';
import '../calendar/game_calendar.dart';
import 'item_detail.dart';
import 'finish_date_list.dart';

class GameDetail extends ItemDetail<Game, GameDetailBloc, GameDetailManagerBloc> {
  const GameDetail({
    Key? key,
    required Game item,
    void Function(Game? item)? onUpdate,
  }) : super(key: key, item: item, onUpdate: onUpdate);

  @override
  GameDetailBloc detailBlocBuilder(GameDetailManagerBloc managerBloc) {

    return GameDetailBloc(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
      managerBloc: managerBloc,
    );

  }

  @override
  GameDetailManagerBloc managerBlocBuilder() {

    return GameDetailManagerBloc(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

  }

  @override
  List<BlocProvider> relationBlocsBuilder() {

    GameRelationManagerBloc<Platform> _platformRelationManagerBloc = GameRelationManagerBloc<Platform>(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    GameRelationManagerBloc<Purchase> _purchaseRelationManagerBloc = GameRelationManagerBloc<Purchase>(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    GameRelationManagerBloc<DLC> _dlcRelationManagerBloc = GameRelationManagerBloc<DLC>(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    GameRelationManagerBloc<Tag> _tagRelationManagerBloc = GameRelationManagerBloc<Tag>(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    GameFinishDateRelationManagerBloc _finishRelationManagerBloc = GameFinishDateRelationManagerBloc(
      itemId: item.id,
      iCollectionRepository: ICollectionRepository.iCollectionRepository!,
    );

    return [
      blocProviderRelationBuilder<Platform>(_platformRelationManagerBloc),
      blocProviderRelationBuilder<Purchase>(_purchaseRelationManagerBloc),
      blocProviderRelationBuilder<DLC>(_dlcRelationManagerBloc),
      blocProviderRelationBuilder<Tag>(_tagRelationManagerBloc),

      BlocProvider<GameRelationManagerBloc<Platform>>(
        create: (BuildContext context) {
          return _platformRelationManagerBloc;
        },
      ),
      BlocProvider<GameRelationManagerBloc<Purchase>>(
        create: (BuildContext context) {
          return _purchaseRelationManagerBloc;
        },
      ),
      BlocProvider<GameRelationManagerBloc<DLC>>(
        create: (BuildContext context) {
          return _dlcRelationManagerBloc;
        },
      ),
      BlocProvider<GameRelationManagerBloc<Tag>>(
        create: (BuildContext context) {
          return _tagRelationManagerBloc;
        },
      ),

      BlocProvider<GameFinishDateRelationBloc>(
        create: (BuildContext context) {
          return GameFinishDateRelationBloc(
            itemId: item.id,
            iCollectionRepository: ICollectionRepository.iCollectionRepository!,
            managerBloc: _finishRelationManagerBloc,
          )..add(LoadRelation());
        },
      ),
      BlocProvider<GameFinishDateRelationManagerBloc>(
        create: (BuildContext context) {
          return _finishRelationManagerBloc;
        },
      ),
    ];

  }

  @override
  _GameDetailBody detailBodyBuilder() {

    return _GameDetailBody(
      itemId: item.id,
      onUpdate: onUpdate,
    );

  }

  BlocProvider<GameRelationBloc<W>> blocProviderRelationBuilder<W extends CollectionItem>(GameRelationManagerBloc<W> managerBloc) {

    return BlocProvider<GameRelationBloc<W>>(
      create: (BuildContext context) {
        return GameRelationBloc<W>(
          itemId: item.id,
          iCollectionRepository: ICollectionRepository.iCollectionRepository!,
          managerBloc: managerBloc,
        )..add(LoadItemRelation());
      },
    );

  }
}

// ignore: must_be_immutable
class _GameDetailBody extends ItemDetailBody<Game, GameDetailBloc, GameDetailManagerBloc> {
  _GameDetailBody({
    Key? key,
    required this.itemId,
    void Function(Game? item)? onUpdate,
  }) : super(key: key, onUpdate: onUpdate);

  final int itemId;

  @override
  String itemTitle(Game item) => GameTheme.itemTitle(item);

  @override
  List<Widget> itemFieldsBuilder(BuildContext context, Game game) {

    return [
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).nameFieldString,
        field: game_nameField,
        value: game.name,
      ),
      itemTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).editionFieldString,
        field: game_editionField,
        value: game.edition,
      ),
      itemYearField(
        context,
        fieldName: GameCollectionLocalisations.of(context).releaseYearFieldString,
        field: game_releaseYearField,
        value: game.releaseYear,
      ),
      itemChipField(
        context,
        fieldName: GameCollectionLocalisations.of(context).statusFieldString,
        field: game_statusField,
        value: game.status,
        possibleValues: [
          GameCollectionLocalisations.of(context).lowPriorityString,
          GameCollectionLocalisations.of(context).nextUpString,
          GameCollectionLocalisations.of(context).playingString,
          GameCollectionLocalisations.of(context).playedString,
        ],
        possibleValuesColours: GameTheme.statusColours,
      ),
      itemRatingField(
        context,
        fieldName: GameCollectionLocalisations.of(context).ratingFieldString,
        field: game_ratingField,
        value: game.rating,
      ),
      itemLongTextField(
        context,
        fieldName: GameCollectionLocalisations.of(context).thoughtsFieldString,
        field: game_thoughtsField,
        value: game.thoughts,
      ),
      itemURLField(
        context,
        fieldName: GameCollectionLocalisations.of(context).saveFolderFieldString,
        field: game_saveFolderField,
        value: game.saveFolder,
      ),
      itemURLField(
        context,
        fieldName: GameCollectionLocalisations.of(context).screenshotFolderFieldString,
        field: game_screenshotFolderField,
        value: game.screenshotFolder,
      ),
      itemBoolField(
        context,
        fieldName: GameCollectionLocalisations.of(context).backupFieldString,
        field: game_backupField,
        value: game.isBackup,
      ),
      ListTileTheme.merge(
        child: ListTile(
          title: Text(GameCollectionLocalisations.of(context).calendarViewString),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.pushNamed(
              context,
              gameCalendarRoute,
              arguments: GameCalendarArguments(
                itemId: itemId,
                onUpdate: () {

                  BlocProvider.of<GameDetailBloc>(context).add(ReloadItem());

                },
              ),
            );
          },
        ),
      ),
      itemDurationField(
        context,
        fieldName: GameCollectionLocalisations.of(context).timeLogsFieldString,
        value: game.time,
      ),
      GameFinishDateList(
        fieldName: GameCollectionLocalisations.of(context).finishDatesFieldString,
        value: game.finishDate,
        relationTypeName: GameCollectionLocalisations.of(context).finishDateFieldString,
        onUpdate: () {
          BlocProvider.of<GameDetailBloc>(context).add(ReloadItem());
        },
      ),
    ];

  }

  @override
  List<Widget> itemRelationsBuilder(BuildContext context) {

    return [
      GamePlatformRelationList(
        relationName: GameCollectionLocalisations.of(context).platformsString,
        relationTypeName: GameCollectionLocalisations.of(context).platformString,
      ),
      GamePurchaseRelationList(
        relationName: GameCollectionLocalisations.of(context).purchasesString,
        relationTypeName: GameCollectionLocalisations.of(context).purchaseString,
      ),
      GameDLCRelationList(
        relationName: GameCollectionLocalisations.of(context).dlcsString,
        relationTypeName: GameCollectionLocalisations.of(context).dlcString,
      ),
      GameTagRelationList(
        relationName: GameCollectionLocalisations.of(context).tagsString,
        relationTypeName: GameCollectionLocalisations.of(context).tagString,
      ),
    ];

  }
}

// ignore: must_be_immutable
class GameFinishDateList extends FinishDateList<Game, GameFinishDateRelationBloc, GameFinishDateRelationManagerBloc> {
  GameFinishDateList({
    Key? key,
    required String fieldName,
    required DateTime? value,
    required String relationTypeName,
    required void Function() onUpdate,
  }) : super(key: key, fieldName: fieldName, value: value, relationTypeName: relationTypeName, onUpdate: onUpdate);
}
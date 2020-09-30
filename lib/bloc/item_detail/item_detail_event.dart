import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemDetailEvent extends Equatable {
  const ItemDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadItem extends ItemDetailEvent {
  const LoadItem(this.ID);

  final int ID;

  @override
  List<Object> get props => [ID];

  @override
  String toString() => 'LoadItem { '
      'ID: $ID'
      ' }';
}

class UpdateItem<T extends CollectionItem> extends ItemDetailEvent {
  const UpdateItem(this.item);

  final T item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'UpdateItem { '
      'item: $item'
      ' }';
}
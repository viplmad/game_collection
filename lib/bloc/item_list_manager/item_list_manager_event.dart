import 'package:equatable/equatable.dart';

import 'package:game_collection/model/model.dart';


abstract class ItemListManagerEvent extends Equatable {
  const ItemListManagerEvent();

  @override
  List<Object> get props => [];
}

class AddItem extends ItemListManagerEvent {
  const AddItem([this.title = '']);

  final String title;

  @override
  List<Object> get props => [title];

  @override
  String toString() => 'AddItem { '
      'title: $title'
      ' }';
}

class DeleteItem<T extends CollectionItem> extends ItemListManagerEvent {
  const DeleteItem(this.item);

  final T item;

  @override
  List<Object> get props => [item];

  @override
  String toString() => 'DeleteItem { '
      'item: $item'
      ' }';
}
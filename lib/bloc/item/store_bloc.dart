import 'dart:async';

import 'package:meta/meta.dart';

import 'package:game_collection/repository/icollection_repository.dart';

import 'package:game_collection/model/model.dart';

import 'item.dart';


class StoreBloc extends ItemBloc<Store> {

  StoreBloc({
    @required ICollectionRepository collectionRepository,
  }) : super(collectionRepository: collectionRepository);

  @override
  Future<Store> createFuture(AddItem event) {

    return collectionRepository.insertStore(event.title ?? '');

  }

  @override
  Future<dynamic> deleteFuture(DeleteItem<Store> event) {

    return collectionRepository.deleteStore(event.item.ID);

  }

  @override
  Future<Store> updateFuture(UpdateItemField<Store> event) {

    return collectionRepository.updateStore(event.item.ID, event.field, event.value);

  }

  @override
  Future<Store> addImage(AddItemImage<Store> event) {

    return collectionRepository.uploadStoreIcon(event.item.ID, event.imagePath, event.oldImageName);

  }

  @override
  Future<Store> updateImageName(UpdateItemImageName<Store> event) {

    return collectionRepository.renameStoreIcon(event.item.ID, event.oldImageName, event.newImageName);

  }

  @override
  Future<Store> deleteImage(DeleteItemImage<Store> event) {

    return collectionRepository.deleteStoreIcon(event.item.ID, event.imageName);

  }

  @override
  Future<dynamic> addRelationFuture<W extends CollectionItem>(AddItemRelation<Store, W> event) {

    int storeID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return collectionRepository.insertStorePurchase(storeID, otherID);
    }

    return super.addRelationFuture<W>(event);

  }

  @override
  Future<dynamic> deleteRelationFuture<W extends CollectionItem>(DeleteItemRelation<Store, W> event) {

    int storeID = event.item.ID;
    int otherID = event.otherItem.ID;

    switch(W) {
      case Purchase:
        return collectionRepository.deleteStorePurchase(otherID);
    }

    return super.deleteRelationFuture<W>(event);

  }

}
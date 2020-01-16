import 'package:flutter/material.dart';

import 'package:game_collection/persistence/db_conector.dart';
import 'package:game_collection/persistence/postgres_connector.dart';
import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/type.dart';
import 'package:game_collection/entity/purchase.dart' as purchaseEntity;

import 'entity_view.dart';

class TypeView extends EntityView {
  TypeView({Key key, @required PurchaseType type}) : super(key: key, entity: type);

  @override
  State<EntityView> createState() => _TypeViewState();
}

class _TypeViewState extends EntityViewState {
  final DBConnector _db = PostgresConnector.getConnector();

  @override
  PurchaseType getEntity() => widget.entity as PurchaseType;

  @override
  Future<dynamic> getUpdateFuture<T>(String fieldName, T newValue) => _db.updateType(getEntity().ID, fieldName, newValue);

  @override
  List<Widget> getListFields() {

    return [
      attributeBuilder(
        fieldName: IDField,
        value: getEntity().ID.toString(),
      ),
      modifyTextAttributeBuilder(
        fieldName: nameField,
        value: getEntity().name,
      ),
      Divider(),
      headerRelationText(
        fieldName: purchaseEntity.purchaseTable + 's',
      ),
      streamBuilderEntities(
        entityStream: _db.getPurchasesFromType(getEntity().ID),
        tableName: purchaseEntity.purchaseTable,
        newRelationFuture: (int addedPurchaseID) => _db.insertPurchaseType(addedPurchaseID, getEntity().ID),
        deleteRelationFuture: (int deletedPurchaseID) => _db.deletePurchaseType(deletedPurchaseID, getEntity().ID),
      ),
    ];

  }

}
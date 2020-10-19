import 'package:meta/meta.dart';


abstract class ISQLConnector {
  Future<dynamic> open();
  Future<dynamic> close();
  bool isOpen();
  bool isClosed();
  bool isUpdating();

  void reconnect();

  //#region CREATE
  Future<List<Map<String, Map<String, dynamic>>>> insertRecord({@required String tableName, Map<String, dynamic> fieldAndValues, List<String> returningFields});
  Future<dynamic> insertRelation({@required String leftTableName, @required String rightTableName, @required int leftTableId, @required int rightTableId});
  //#endregion CREATE

  //#region READ
  Future<List<Map<String, Map<String, dynamic>>>> readTable({@required String tableName, List<String> selectFields, Map<String, dynamic> whereFieldsAndValues, List<String> sortFields, int limitResults});
  Future<List<Map<String, Map<String, dynamic>>>> readRelation({@required String leftTableName, @required String rightTableName, @required bool leftResults, @required int relationId, List<String> selectFields, List<String> sortFields});
  Future<List<Map<String, Map<String, dynamic>>>> readWeakRelation({@required String primaryTable, @required String subordinateTable, @required String relationField, @required int relationId, bool primaryResults, List<String> selectFields, List<String> sortFields});
  Future<List<Map<String, Map<String, dynamic>>>> readTableSearch({@required String tableName, @required String searchField, @required String query, List<String> fieldNames, int limitResults});
  //#endregion READ

  //#region UPDATE
  Future<List<Map<String, Map<String, dynamic>>>> updateTable<T>({@required String tableName, @required int id, @required String fieldName, @required T newValue, List<String> returningFields});
  //#endregion UPDATE

  //#region DELETE
  Future<dynamic> deleteTable({@required String tableName, @required int id});
  Future<dynamic> deleteRelation({@required String leftTableName, @required String rightTableName, @required int leftId, @required int rightId});
  //#endregion DELETE
}
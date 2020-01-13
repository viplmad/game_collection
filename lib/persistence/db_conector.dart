import 'package:game_collection/entity/entity.dart';
import 'package:game_collection/entity/game.dart';
import 'package:game_collection/entity/dlc.dart';
import 'package:game_collection/entity/type.dart';
import 'package:game_collection/entity/purchase.dart';
import 'package:game_collection/entity/platform.dart';
import 'package:game_collection/entity/store.dart';
import 'package:game_collection/entity/system.dart';
import 'package:game_collection/entity/tag.dart';

abstract class DBConnector {

  Future<dynamic> open();
  Future<dynamic> close();

  Stream<List<Game>> getAllGames();
  Stream<List<Platform>> getPlatformsFromGame(int ID);
  Stream<List<Purchase>> getPurchasesFromGame(int ID);
  Stream<List<DLC>> getDLCsFromGame(int ID);
  Stream<List<Tag>> getTagsFromGame(int ID);

  Stream<List<DLC>> getAllDLCs();
  Stream<Game> getBaseGameFromDLC(int baseGameID);
  Stream<List<Purchase>> getPurchasesFromDLC(int ID);

  Stream<List<Platform>> getAllPlatforms();
  Stream<List<Game>> getGamesFromPlatform(int ID);
  Stream<List<System>> getSystemsFromPlatform(int ID);

  Stream<List<Purchase>> getAllPurchases();
  Stream<Store> getStoreFromPurchase(int storeID);
  Stream<List<Game>> getGamesFromPurchase(int ID);
  Stream<List<DLC>> getDLCsFromPurchase(int ID);
  Stream<List<PurchaseType>> getTypesFromPurchase(int ID);

  Stream<List<Store>> getAllStores();
  Stream<List<Purchase>> getPurchasesFromStore(int ID);

  Stream<List<System>> getAllSystems();
  Stream<List<Platform>> getPlatformsFromSystem(int ID);

  Stream<List<Tag>> getAllTags();
  Stream<List<Game>> getGamesFromTag(int ID);

  Stream<List<PurchaseType>> getAllTypes();
  Stream<List<Purchase>> getPurchasesFromType(int ID);

  Future<dynamic> updateDescriptionPurchase(int ID, String newText);

  Future<dynamic> insertGamePurchase(int gameID, int purchaseID);
  Future<dynamic> deleteGamePurchase(int gameID, int purchaseID);

  Future<dynamic> insertDLC();
  Future<dynamic> insertPurchase();

  Future<dynamic> insertGameDLC(int gameID, int dlcID);
  Future<dynamic> deleteGameDLC(int dlcID);


  Stream<List<Entity>> getSearchStream(String tableName, String query);
  Stream<List<Game>> getGamesWithName(String name);

  Future<dynamic> updateStringDLC(int ID, String fieldName, String newText);
  Future<dynamic> updateNumberDLC(int ID, String fieldName, int newNumber);
  Future<dynamic> updateDateDLC(int ID, String fieldName, DateTime newDate);

}
import 'package:meta/meta.dart';

import 'collection_item_entity.dart';


const purchaseTable = "Purchase";

const List<String> purchaseFields = [
  IDField,
  purc_descriptionField,
  purc_priceField,
  purc_externalCreditField,
  purc_dateField,
  purc_originalPriceField,
  purc_storeField,
];

const String purc_descriptionField = 'Description';
const String purc_priceField = 'Price';
const String purc_externalCreditField = 'External Credit';
const String purc_dateField = 'Date';
const String purc_originalPriceField = 'Original Price';

const String purc_storeField = 'Store';

class PurchaseEntity extends CollectionItemEntity {

  PurchaseEntity({
    @required int ID,
    this.description,
    this.price,
    this.externalCredit,
    this.date,
    this.originalPrice,

    this.store,
  }) : super(ID: ID);

  final String description;
  final double price;
  final double externalCredit;
  final DateTime date;
  final double originalPrice;

  final int store;

  static PurchaseEntity fromDynamicMap(Map<String, dynamic> map) {

    return PurchaseEntity(
      ID: map[IDField],
      description: map[purc_descriptionField],
      price: map[purc_priceField],
      externalCredit: map[purc_externalCreditField],
      date: map[purc_dateField],
      originalPrice: map[purc_originalPriceField],

      store: map[purc_storeField],
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      IDField : ID,
      purc_descriptionField : description,
      purc_priceField : price,
      purc_externalCreditField : externalCredit,
      purc_dateField : date,
      purc_originalPriceField : originalPrice,

      purc_storeField : store,
    };

  }

  static List<PurchaseEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<PurchaseEntity> purchasesList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> map) {
      Map<String, dynamic> _tempFixMap = Map.from(map[purchaseTable]);
      _tempFixMap.addAll(
        map[null],
      );

      PurchaseEntity purchase = PurchaseEntity.fromDynamicMap(_tempFixMap);
      //Purchase purchase = Purchase.fromDynamicMap(map[purchaseTable]);

      purchasesList.add(purchase);
    });

    return purchasesList;

  }

  @override
  List<Object> get props => [
    ID,
    description,
    price,
    externalCredit,
    date,
    originalPrice,
  ];

  @override
  String toString() {

    return '{$purchaseTable}Entity { '
        '$IDField: $ID, '
        '$purc_descriptionField: $description, '
        '$purc_priceField: $price, '
        '$purc_externalCreditField: $externalCredit, '
        '$purc_dateField: $date, '
        '$purc_originalPriceField: $originalPrice'
        ' }';

  }

}
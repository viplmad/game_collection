import 'package:meta/meta.dart';

import 'entity.dart';


const String systemTable = "System";

const List<String> systemTables = [
  IDField,
  sys_nameField,
  sys_iconField,
  sys_generationField,
  sys_manufacturerField,
];

const String sys_nameField = 'Name';
const String sys_iconField = 'Icon';
const String sys_generationField = 'Generation';
const String sys_manufacturerField = 'Manufacturer';

List<String> manufacturers = [
  "Nintendo",
  "Sony",
  "Microsoft",
  "Sega",
];

class SystemEntity extends CollectionItemEntity {

  SystemEntity({
    @required int id,
    this.name,
    this.iconFilename,
    this.generation,
    this.manufacturer
  }) : super(id: id);

  final String name;
  final String iconFilename;
  final int generation;
  final String manufacturer;

  static SystemEntity fromDynamicMap(Map<String, dynamic> map) {

    return SystemEntity(
      id: map[IDField],
      name: map[sys_nameField],
      iconFilename: map[sys_iconField],
      generation: map[sys_generationField],
      manufacturer: map[sys_manufacturerField],
    );

  }

  @override
  Map<String, dynamic> toDynamicMap() {

    return <String, dynamic> {
      IDField : id,
      sys_nameField : name,
      sys_iconField : iconFilename,
      sys_generationField : generation,
      sys_manufacturerField : manufacturer,
    };

  }

  static List<SystemEntity> fromDynamicMapList(List<Map<String, Map<String, dynamic>>> listMap) {

    List<SystemEntity> systemsList = [];

    listMap.forEach( (Map<String, Map<String, dynamic>> manyMap) {
      SystemEntity system = SystemEntity.fromDynamicMap( CollectionItemEntity.combineMaps(manyMap, systemTable) );

      systemsList.add(system);
    });

    return systemsList;

  }

  @override
  List<Object> get props => [
    id,
    name,
    iconFilename,
    generation,
    manufacturer,
  ];

  @override
  String toString() {

    return '{$systemTable}Entity { '
        '$IDField: $id, '
        '$sys_nameField: $name, '
        '$sys_iconField: $iconFilename, '
        '$sys_generationField: $generation, '
        '$sys_manufacturerField: $manufacturer'
        ' }';

  }

}
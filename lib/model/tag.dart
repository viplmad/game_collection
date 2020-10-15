import 'package:meta/meta.dart';

import 'package:game_collection/entity/entity.dart';

import 'model.dart';


enum TagView {
  Main,
  LastCreated,
}

class Tag extends CollectionItem {

  Tag({
    @required int id,
    this.name
  }) : super(id: id);

  final String name;

  static Tag fromEntity(TagEntity entity) {

    return Tag(
      id: entity.id,
      name: entity.name,
    );

  }

  @override
  TagEntity toEntity() {

    return TagEntity(
      id: this.id,
      name: this.name,
    );

  }

  @override
  Tag copyWith({
    String name,
  }) {

    return Tag(
      id: id,
      name: name?? this.name,
    );

  }

  @override
  String getUniqueID() {

    return 'Tg' + this.id.toString();

  }

  @override
  String getTitle() {

    return this.name;

  }

  @override
  List<Object> get props => [
    id,
    name,
  ];

  @override
  String toString() {

    return '$tagTable { '
        '$IDField: $id, '
        '$tag_nameField: $name'
        ' }';

  }

}

class TagsData {

  TagsData({
    this.tags,
  });

  final List<Tag> tags;

}
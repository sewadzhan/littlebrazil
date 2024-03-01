//Class for group modifier of product in Iiko Menu
import 'package:equatable/equatable.dart';
import 'package:littlebrazil/data/models/group_children_modifier.dart';

class GroupModifier extends Equatable {
  final String name;
  final String id;
  final List<GroupChildrenModifier> childModifiers;

  const GroupModifier(
      {required this.name, required this.id, required this.childModifiers});

  factory GroupModifier.fromMapIiko(
      Map<String, dynamic> group, List<dynamic> products) {
    //Retrieving modifiers for certain group modifier
    var modifiers = products
        .where((element) => element['parentGroup'] == group['id'])
        .toList();

    return GroupModifier(
        name: group['name'],
        id: group['id'],
        childModifiers: modifiers
            .map((e) => GroupChildrenModifier.fromMapIiko(e, group))
            .toList());
  }

  GroupModifier copyWith({
    String? name,
    String? id,
    List<GroupChildrenModifier>? childModifiers,
  }) {
    return GroupModifier(
        name: name ?? this.name,
        id: id ?? this.id,
        childModifiers: childModifiers ?? this.childModifiers);
  }

  @override
  String toString() {
    return "id: $id, name: $name, childModifiers: $childModifiers";
  }

  @override
  List<Object?> get props => [name, id, childModifiers];
}

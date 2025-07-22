import 'dart:convert';

List<ChartsOfAccountListModel> chartsOfAccountListModelFromJson(String str) =>
    List<ChartsOfAccountListModel>.from(
        json.decode(str).map((x) => ChartsOfAccountListModel.fromJson(x)));

String chartsOfAccountListModelToJson(List<ChartsOfAccountListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChartsOfAccountListModel {
  final int? accountTypeCode;
  final String? accountTypeName;
  final List<NodesList>? nodesList;

  ChartsOfAccountListModel({
    this.accountTypeCode,
    this.accountTypeName,
    this.nodesList,
  });

  factory ChartsOfAccountListModel.fromJson(Map<String, dynamic> json) =>
      ChartsOfAccountListModel(
        accountTypeCode: json["account_type_code"],
        accountTypeName: json["account_type_name"],
        nodesList: json["nodesList"] == null
            ? []
            : List<NodesList>.from(
                json["nodesList"]!.map((x) => NodesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "account_type_code": accountTypeCode,
        "account_type_name": accountTypeName,
        "nodesList": nodesList == null
            ? []
            : List<dynamic>.from(nodesList!.map((x) => x.toJson())),
      };
}

class NodesList {
  final int? id;
  final String? name;
  final int? code;
  final String? description;
  final int? parentId;
  final String? parentName;
  final String? accountName;
  final int? accountCode;
  final List<NodesList>? nodeListChildren;

  NodesList({
    this.id,
    this.name,
    this.code,
    this.description,
    this.parentId,
    this.parentName,
    this.accountName,
    this.accountCode,
    this.nodeListChildren,
  });

  factory NodesList.fromJson(Map<String, dynamic> json) => NodesList(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        description: json["description"],
        parentId: json["parent_id"],
        parentName: json["parent_name"],
        accountName: json["account_name"],
        accountCode: json["account_code"],
        nodeListChildren: json["children"] == null
            ? []
            : List<NodesList>.from(
                json["children"]!.map((x) => NodesList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "description": description,
        "parent_id": parentId,
        "parent_name": parentName,
        "account_name": accountName,
        "account_code": accountCode,
        "children": nodeListChildren == null
            ? []
            : List<dynamic>.from(nodeListChildren!.map((x) => x.toJson())),
      };
}

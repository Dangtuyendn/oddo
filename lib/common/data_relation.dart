enum TypeMode { m2o, m2m, o2m }

class DataRelation {
  String? parentModel;
  int? parentId;
  int? m2oId;
  List<int>? m2mIds;
  List<int>? o2mIds;
  List? domain;
  TypeMode? type;
  dynamic dataCallback;

  DataRelation(
      {this.parentModel,
      this.parentId,
      this.m2oId,
      this.m2mIds,
      this.o2mIds,
      this.domain,
      this.type,
      this.dataCallback});
}

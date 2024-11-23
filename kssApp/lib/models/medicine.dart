class Medicine {
  int? id;
  String? name;
  String? frequency;
  String? hungerSituation;

  Medicine(this.name, this.frequency, this.hungerSituation);

  Medicine.withId(this.id, this.name, this.frequency, this.hungerSituation);

  Medicine.fromObject(dynamic obj) {
    id = obj["id"];
    name = obj["name"];
    frequency = obj["frequency"];
    hungerSituation = obj["hungerSituation"];
  }

  Map<String, dynamic>? toMap() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["frequency"] = frequency;
    map["hungerSituation"] = hungerSituation;
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }
}

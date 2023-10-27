class CartridgeData {
  CartridgeData({
    this.isBase = false,
    this.name = "Slot",
    this.minDrops = 0,
    this.drops = 0
  });

  bool isBase;
  String name;
  int minDrops;
  int drops;

  factory CartridgeData.fromJsonMap(Map<String, dynamic> json) {
    return CartridgeData(
      isBase: json["isBase"],
      name: json["name"],
      minDrops: json["minDrops"],
      drops: json["drops"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "isBase": isBase,
      "name": name,
      "minDrops": minDrops,
      "drops": drops,
    };
  }
}

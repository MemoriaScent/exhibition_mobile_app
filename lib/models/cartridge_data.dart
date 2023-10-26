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
}

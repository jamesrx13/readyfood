class PlateModel {
  String id;
  String description;
  String imageUrl;
  String name;
  int price;
  bool isSpecial;
  bool hasStock;

  PlateModel({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.hasStock,
    required this.isSpecial,
  });
}

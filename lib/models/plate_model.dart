class PlateModel {
  String id;
  String description;
  String imageUrl;
  String name;
  int price;
  int countSold;
  bool isSpecial;
  bool hasStock;

  PlateModel({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.countSold,
    required this.price,
    required this.hasStock,
    required this.isSpecial,
  });
}

class OrderModel {
  String id;
  String date;
  String dateEnd;
  String description;
  String nameOrNumber;
  String workerId;

  OrderModel({
    required this.id,
    required this.date,
    required this.dateEnd,
    required this.description,
    required this.nameOrNumber,
    required this.workerId,
  });
}

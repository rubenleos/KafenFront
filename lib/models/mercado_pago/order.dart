class Order {
  final String id;
  final double total;
  // Aquí puedes añadir más campos que necesites, como:
  // final List<Product> products;
  // final String userId;

  Order({
    required this.id,
    required this.total,
  });

  // Este método es útil para convertir la orden a un formato JSON
  // que puedes enviar a tu backend.
  Map<String, dynamic> toJson() => {
    'id': id,
    'total': total,
  };
}
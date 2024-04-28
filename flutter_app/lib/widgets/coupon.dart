class Coupon {
  final int? id; // Nullable ID since it will be assigned by the database
  final String code;
  final String description;
  final int restaurantID;

  Coupon({
    this.id,
    required this.code,
    required this.description,
    required this.restaurantID,
  });

  // Convert a Coupon object to a map (for database operations)
  Map<String, dynamic> toMap() {
    return {
      'id': id, // ID can be null for inserts (assigned by database)
      'code': code,
      'description': description,
      'restaurantID': restaurantID,
    };
  }

  // Factory method to create a Coupon object from a map
  factory Coupon.fromMap(Map<String, dynamic> map) {
    return Coupon(
      id: map['id'],
      code: map['code'],
      description: map['description'],
      restaurantID: map['restaurantID'],
    );
  }

  @override
  String toString() {
    return 'Coupon{id: $id, code: $code, description: $description, restaurantID: $restaurantID}';
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Coupon {
  final String? id; // Nullable ID since it will be assigned by the database
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
      'code': code,
      'description': description,
      'restaurantID': restaurantID,
    };
  }

  // Factory method to create a Coupon object from a map
  factory Coupon.fromMap(Map<String, dynamic> map, String id) {
    return Coupon(
      id: id,
      code: map['code'],
      description: map['description'],
      restaurantID: map['restaurantID'],
    );
  }

  // Convert a Coupon object to a Firebase Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'code': code,
      'description': description,
      'restaurantID': restaurantID,
    };
  }

  // Factory method to create a Coupon object from a Firebase Firestore document
  factory Coupon.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Coupon(
      id: doc.id,
      code: data['code'],
      description: data['description'],
      restaurantID: data['restaurantID'],
    );
  }

  @override
  String toString() {
    return 'Coupon{id: $id, code: $code, description: $description, restaurantID: $restaurantID}';
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class CouponService {
  final CollectionReference couponsCollection =
      FirebaseFirestore.instance.collection('Coupons');

  Future<void> addCoupon(String title, String description, int restaurantID) async {
    
    try {
      await couponsCollection.add({
        'Code': title,
        'description': description,
        'restaurantID': restaurantID,
      });
      print('Coupon added successfully!');
    } catch (e) {
      print('Error adding coupon: $e');
      // Handle error
    }
  }
}
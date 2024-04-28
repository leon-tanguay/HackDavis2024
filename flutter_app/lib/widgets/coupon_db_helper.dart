import 'package:cloud_firestore/cloud_firestore.dart';
import 'coupon.dart';

class CouponDatabaseHelper {

  static final CollectionReference couponsCollection = FirebaseFirestore.instance.collection('coupons');

  static Future<void> insertCoupon(Coupon coupon) async {
    await couponsCollection.add(coupon.toFirestore());
  }

  static Future<List<Coupon>> getCoupons() async {
    QuerySnapshot querySnapshot = await couponsCollection.get();
    return querySnapshot.docs.map((doc) => Coupon.fromFirestore(doc)).toList();
  }

  static Future<void> deleteCoupon(String id) async {
    await couponsCollection.doc(id).delete();
  }

  static Future<int> getCouponsCount() async {
    QuerySnapshot querySnapshot = await couponsCollection.get();
    return querySnapshot.size;
  }
}

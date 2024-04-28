import 'package:flutter/material.dart';
import '../widgets/coupon_db_helper.dart';
import '../widgets/coupon.dart';

class RestaurantCouponPage extends StatefulWidget {
  @override
  _RestaurantCouponPageState createState() => _RestaurantCouponPageState();
}

class _RestaurantCouponPageState extends State {
  List < Coupon > coupons = [];

  @override
  void initState() {
    super.initState();
    _loadCoupons();
  }

  Future < void > _loadCoupons() async {
    // Retrieve coupons from the database
    List < Coupon > loadedCoupons = await CouponDatabaseHelper.getCoupons();
    // Update the state with the loaded coupons
    setState(() {
      coupons = loadedCoupons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Davis Deals',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFA8DAF9),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        final coupon = coupons[index];
        return CouponTile(
          coupon: coupon,
        );
      },
    );
  }
}

class CouponTile extends StatelessWidget {
  final Coupon coupon;

  const CouponTile({
    Key ? key,
    required this.coupon
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Coupon Code: ${coupon.code}',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 8.0),
            Text(
              'Description: ${coupon.description}',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            SizedBox(height: 8.0),
            Text(
              'Restaurant ID: ${coupon.restaurantID}',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
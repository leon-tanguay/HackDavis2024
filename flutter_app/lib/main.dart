import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Coupons',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RestaurantCouponPage(),
    );
  }
}

class RestaurantCouponPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Coupons'),
      ),
      body: CouponList(),
    );
  }
}

class CouponList extends StatefulWidget {
  @override
  _CouponListState createState() => _CouponListState();
}

class _CouponListState extends State<CouponList> {
  List<String> coupons = [];

  @override
  void initState() {
    super.initState();
    // Generate initial list of random coupons
    coupons = generateCoupons(15);
  }

  List<String> generateCoupons(int count) {
    // Generate random coupon codes
    return List.generate(count, (index) => WordPair.random().asString.toUpperCase());
  }

  void verifyCoupon(String couponCode) {
    // Simulate coupon verification process
    // Here you can implement actual logic to verify the coupon code
    // For demo purpose, we'll just print the coupon code as verified
    print('Coupon Verified: $couponCode');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        final couponCode = coupons[index];
        return CouponTile(
          couponCode: couponCode,
          onPressed: () {
            verifyCoupon(couponCode);
          },
        );
      },
    );
  }
}

class CouponTile extends StatefulWidget {
  final String couponCode;
  final VoidCallback onPressed;

  const CouponTile({
    Key? key,
    required this.couponCode,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CouponTileState createState() => _CouponTileState();
}

class _CouponTileState extends State<CouponTile> {
  bool isVerified = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          'Coupon Code: ${widget.couponCode}',
          style: TextStyle(fontSize: 16.0),
        ),
        trailing: InkWell(
          onTap: () {
            setState(() {
              isVerified = !isVerified;
            });
            widget.onPressed(); // Call onPressed callback when verified status changes
          },
          child: isVerified
              ? Icon(Icons.check_circle, color: Colors.green)
              : Icon(Icons.check_circle_outline),
        ),
      ),
    );
  }
}

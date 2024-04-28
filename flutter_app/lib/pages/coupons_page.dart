import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'map_page.dart';
import 'login_page.dart';
import '../widgets/bottom_bar.dart';
import 'dart:math';

class RestaurantCouponPage extends StatefulWidget {
  @override
  _RestaurantCouponPageState createState() => _RestaurantCouponPageState();
}

class _RestaurantCouponPageState extends State
{
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {'title': 'Coupons', 'icon': Icons.local_offer},
    {'title': 'Map', 'icon': Icons.map},
    {'title': 'Login', 'icon': Icons.login},
  ];

  List<String> coupons = [];
  List<int> discounts = [];

  @override
  void initState() {
    super.initState();
    // Generate initial list of random coupons and discounts
    coupons = generateCoupons(15);
    discounts = generateDiscounts(15);
  }

  List<int> generateDiscounts(int count) {
  // Generate random discount percentages
  Random random = Random();
  return List.generate(count, (int index) => random.nextInt(50) + 1); // Add a semicolon at the end
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
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_currentIndex]['title']),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return CouponGrid(coupons: coupons, discounts: discounts, onPressed: verifyCoupon);
      case 1:
        return MapScreen();
      case 2:
        return LoginScreen();
      default:
        return SizedBox.shrink();
    }
  }
}

class CouponGrid extends StatelessWidget {
  final List<String> coupons;
  final List<int> discounts;
  final Function(String) onPressed;

  const CouponGrid({Key? key, required this.coupons, required this.discounts, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns in the grid
        crossAxisSpacing: 8.0, // Spacing between columns
        mainAxisSpacing: 8.0, // Spacing between rows
      ),
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        final couponCode = coupons[index];
        final discount = discounts[index];
        return CouponTile(
          couponCode: couponCode,
          discount: discount,
          onPressed: () {
            onPressed(couponCode);
          },
        );
      },
    );
  }
}

class CouponTile extends StatelessWidget {
  final String couponCode;
  final int discount;
  final VoidCallback onPressed;

  const CouponTile({Key? key, required this.couponCode, required this.discount, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Coupon Code: $couponCode',
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Discount: $discount% off',
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

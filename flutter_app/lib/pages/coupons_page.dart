import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'map_page.dart';
import 'login_page.dart';
import '../widgets/bottom_bar.dart';
import 'dart:math';

import 'package:flutter/material.dart';

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
  }

  void verifyCoupon(String couponCode) {
    // Simulate coupon verification process
    // Here you can implement actual logic to verify the coupon code
    // For demo purpose, we'll just print the coupon code as verified
    print('Coupon Verified: $couponCode');
  }

  void addCoupon(String couponCode, int discount) {
    // Add the new coupon to the list
    setState(() {
      coupons.add(couponCode);
      discounts.add(discount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_currentIndex]['title']),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _pages.map((page) {
          return BottomNavigationBarItem(
            icon: Icon(page['icon']),
            label: page['title'],
          );
        }).toList(),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                _showAddCouponDialog(context);
              },
              child: Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return CouponGrid(
          coupons: coupons,
          discounts: discounts,
          onPressed: verifyCoupon,
        );
      // You can add cases for other pages if needed
      default:
        return SizedBox.shrink();
    }
  }

  Future<void> _showAddCouponDialog(BuildContext context) async {
    String couponCode = '';
    int discount = 0;

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Coupon'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Coupon Code'),
                  onChanged: (value) {
                    couponCode = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Discount Percentage'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    discount = int.tryParse(value) ?? 0;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (couponCode.isNotEmpty && discount > 0) {
                  addCoupon(couponCode, discount);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Please enter valid coupon details.'),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './map_page.dart';

class Coupon {
  final String code;
  final String description;
  final int restaurantID;

  Coupon({
    required this.code,
    required this.description,
    required this.restaurantID,
  });
}

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
    }
  }

  Future<void> deleteCoupon(String couponId) async {
    try {
      await couponsCollection.doc(couponId).delete();
      print('Coupon deleted successfully!');
    } catch (e) {
      print('Error deleting coupon: $e');
    }
  }

  Future<List<Coupon>> getAllCoupons() async {
    try {
      QuerySnapshot querySnapshot = await couponsCollection.get();
      return querySnapshot.docs.map((doc) {
        return Coupon(
          code: doc['Code'],
          description: doc['description'],
          restaurantID: doc['restaurantID'],
        );
      }).toList();
    } catch (e) {
      print('Error getting coupons: $e');
      return [];
    }
  }
}

class RestaurantCouponPage extends StatefulWidget {
  @override
  _RestaurantCouponPageState createState() => _RestaurantCouponPageState();
}

class _RestaurantCouponPageState extends State {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {'title': 'Coupons', 'icon': Icons.local_offer},
    {'title': 'Map', 'icon': Icons.map},
  ];

  List<Coupon> coupons = [];

  final CouponService _couponService = CouponService();

  @override
  void initState() {
    super.initState();
    _loadCoupons();
  }

  void deleteCoupon(Coupon coupon) async {
    try {
      await _couponService.deleteCoupon(coupon.code);
      _loadCoupons(); // Reload coupons after deletion
    } catch (e) {
      print('Error deleting coupon: $e');
    }
  }

  Future<void> _loadCoupons() async {
    try {
      List<Coupon> loadedCoupons = await _couponService.getAllCoupons();
      setState(() {
        coupons = loadedCoupons;
      });
    } catch (e) {
      print('Error loading coupons: $e');
    }
  }

  void verifyCoupon(Coupon coupon) {
    print('Coupon Verified: ${coupon.code}');
    // Add your verification logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/Logo.png',
              height: 32,
            ),
            SizedBox(width: 8),
            Text(
              'Davis Deals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Color(0xFFA8DAF9),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Handle search action
              },
            ),
          ),
        ],
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

  Future<void> _showAddCouponDialog(BuildContext context) async {
    String couponCode = '';
    int discount = 0;

    showDialog(
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
              onPressed: () async {
                if (couponCode.isNotEmpty && discount > 0) {
                  try {
                    await _couponService.addCoupon(couponCode, 'Discount of $discount%', 1);
                    Navigator.of(context).pop();
                    _loadCoupons();
                  } catch (e) {
                    print('Error adding coupon: $e');
                  }
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

  Widget _buildBody() {
  switch (_currentIndex) {
    case 0:
      return CouponGrid(
        key: UniqueKey(), // Use UniqueKey to force rebuild on state change
        coupons: coupons,
        onPressed: verifyCoupon,
        onDeletePressed: deleteCoupon,
      );
    case 1:
      return MapScreen();
    // Add cases for other pages if needed
    default:
      return SizedBox.shrink();
  }
}
}

class CouponGrid extends StatelessWidget {
  final List<Coupon> coupons;
  final Function(Coupon) onPressed;
  final Function(Coupon) onDeletePressed;

  // Remove the const keyword from the constructor
  CouponGrid({
    Key? key,
    required this.coupons,
    required this.onPressed,
    required this.onDeletePressed,
  }) : super(key: key ?? UniqueKey());

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
        final coupon = coupons[index];
        return CouponTile(
          coupon: coupon,
          onPressed: () {
            onPressed(coupon);
          },
          onDeletePressed: () {
            onDeletePressed(coupon);
          },
        );
      },
    );
  }
}

class CouponTile extends StatelessWidget {
  final Coupon coupon;
  final VoidCallback onPressed;
  final VoidCallback onDeletePressed;

  const CouponTile({Key? key, required this.coupon, required this.onPressed, required this.onDeletePressed})
      : super(key: key);

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
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: onDeletePressed,
                child: Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
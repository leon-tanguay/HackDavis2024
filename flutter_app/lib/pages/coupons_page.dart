import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_map/flutter_map.dart';
import 'map_page.dart';
import 'login_page.dart';
import '../widgets/bottom_bar.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/coupon_db_helper.dart';
import '../widgets/coupon.dart';



class RestaurantCouponPage extends StatefulWidget {
  @override
  _RestaurantCouponPageState createState() => _RestaurantCouponPageState();
}

class _RestaurantCouponPageState extends State
{
  int _currentIndex = 0;
  static int _nextId = 0;

  final List<Map<String, dynamic>> _pages = [
    {'title': 'Coupons', 'icon': Icons.local_offer},
    {'title': 'Map', 'icon': Icons.map},
    {'title': 'Login', 'icon': Icons.login},
  ];

  List<Coupon> coupons = [];
  List<int> discounts = [];

  @override
  void initState() {
    super.initState();
    _loadCoupons();
    _setNextIdFromDatabase();
  }

   Future<void> _setNextIdFromDatabase() async {
    // Fetch the count of coupons from the database using CouponDatabaseHelper
    int count = await CouponDatabaseHelper.getCouponsCount();
    // Set _nextId to the count retrieved from the database
    setState(() {
      _nextId = count;
    });
  }

  void deleteCoupon(Coupon coupon) async {
  // Delete coupon from database
  await CouponDatabaseHelper.deleteCoupon(coupon.id!);
  // Reload coupons after deletion
  _loadCoupons();
}


  Future<void> _loadCoupons() async {
  // Retrieve coupons from the database
  List<Coupon> loadedCoupons = await CouponDatabaseHelper.getCoupons();
  // Update the state with the loaded coupons
  setState(() {
    coupons = loadedCoupons;
  });
}

  void verifyCoupon(Coupon coupon) {
  // Your verification logic here
  // For example:
  print('Coupon Verified: ${coupon.code}');
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/Logo.png',  // Path to your image file
              height: 32,  // Adjust height as needed
            ),
            SizedBox(width: 8),  // Optional spacing between image and title
            Text(
              'Davis Deals',  // Custom title
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Color(0xFFA8DAF9),  // Set the background color
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),  // Adjust the right-side buffer as needed
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                //NOTHING YET
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

  Widget _buildBody() {
  switch (_currentIndex) {
    case 0:
      return CouponGrid(
        coupons: coupons, // Pass the list of Coupon objects
        onPressed: verifyCoupon,
        onDeletePressed: deleteCoupon,
      );
    case 1: 
      return MapScreen();
    case 2:
      return LoginScreen();
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
            onPressed: () async {
              if (couponCode.isNotEmpty && discount > 0) {
                // Insert coupon into database
                await CouponDatabaseHelper.insertCoupon(
                  Coupon(
                    id: _nextId++,
                    code: couponCode,
                    description: 'Discount of $discount%',
                    restaurantID: 1, // Assuming restaurantID is 1
                  ),
                );
                Navigator.of(context).pop();
                _loadCoupons();
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
  final List<Coupon> coupons; // Updated to use Coupon objects
  final Function(Coupon) onPressed; // Updated to pass Coupon object instead of string
  final Function(Coupon) onDeletePressed; // Callback for delete button

  const CouponGrid({Key? key, required this.coupons, required this.onPressed, required this.onDeletePressed}) : super(key: key);

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
        final coupon = coupons[index]; // Get the Coupon object at the current index
        return CouponTile(
          coupon: coupon, // Pass the Coupon object to CouponTile
          onPressed: () {
            onPressed(coupon); // Pass the Coupon object to the onPressed callback
          },
          onDeletePressed: () {
            onDeletePressed(coupon); // Pass the Coupon object to the onDeletePressed callback
          },
        );
      },
    );
  }
}


class CouponTile extends StatelessWidget {
  final Coupon coupon; // Updated to use Coupon object instead of string and int
  final VoidCallback onPressed;
  final VoidCallback onDeletePressed; // Callback for delete button

  const CouponTile({Key? key, required this.coupon, required this.onPressed, required this.onDeletePressed}) : super(key: key);

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
                'Coupon Code: ${coupon.code}', // Accessing code property of the Coupon object
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(height: 8.0),
              Text(
                'Description: ${coupon.description}', // Accessing description property of the Coupon object
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              SizedBox(height: 8.0),
              Text(
                'Restaurant ID: ${coupon.restaurantID}', // Accessing restaurantID property of the Coupon object
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: onDeletePressed, // Trigger delete callback
                child: Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

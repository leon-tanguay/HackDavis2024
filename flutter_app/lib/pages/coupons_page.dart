import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'map_page.dart';
import 'login_page.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/coupon_db_helper.dart';
import '../widgets/coupon.dart';

class RestaurantCouponPage extends StatefulWidget {
  @override
  _RestaurantCouponPageState createState() => _RestaurantCouponPageState();
}

class _RestaurantCouponPageState extends State {
  int _currentIndex = 0;
  static int _nextId = 0;

  final List < Map < String, dynamic >> _pages = [{
      'title': 'Coupons',
      'icon': Icons.local_offer
    },
    {
      'title': 'Map',
      'icon': Icons.map
    },
    {
      'title': 'Login',
      'icon': Icons.login
    },
  ];

  List < Coupon > coupons = [];

  @override
  void initState() {
    super.initState();
    _loadCoupons();
    _setNextIdFromDatabase();
  }

  Future < void > _setNextIdFromDatabase() async {
    int count = await CouponDatabaseHelper.getCouponsCount();
    setState(() {
      _nextId = count;
    });
  }

  void deleteCoupon(Coupon coupon) async {
    await CouponDatabaseHelper.deleteCoupon(coupon.id!);
    _loadCoupons();
  }

  Future < void > _loadCoupons() async {
    List < Coupon > loadedCoupons = await CouponDatabaseHelper.getCoupons();
    setState(() {
      coupons = loadedCoupons;
    });
  }

  void verifyCoupon(Coupon coupon) {
    print('Coupon Verified: ${coupon.code}');
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
              onPressed: () {},
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
      floatingActionButton: _currentIndex == 0 ?
      FloatingActionButton(
        onPressed: () {
          _showAddCouponDialog(context);
        },
        child: Icon(Icons.add),
      ) :
      null,
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return CouponGrid(
          coupons: coupons,
          onPressed: verifyCoupon,
          onDeletePressed: deleteCoupon,
        );
      case 1:
        return MapScreen();
      case 2:
        return LoginScreen();
      default:
        return SizedBox.shrink();
    }
  }

  Future < void > _showAddCouponDialog(BuildContext context) async {
    String couponCode = '';
    int discount = 0;
    return showDialog < void > (
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Coupon'),
          content: SingleChildScrollView(
            child: Column(
              children: < Widget > [
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
          actions: < Widget > [
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                if (couponCode.isNotEmpty && discount > 0) {
                  await CouponDatabaseHelper.insertCoupon(
                    Coupon(
                      id: (_nextId++).toString(), // Converting _nextId to String
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
  final List < Coupon > coupons;
  final Function(Coupon) onPressed;
  final Function(Coupon) onDeletePressed;

  const CouponGrid({
    Key ? key,
    required this.coupons,
    required this.onPressed,
    required this.onDeletePressed
  }): super(key: key);

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

  const CouponTile({
    Key ? key,
    required this.coupon,
    required this.onPressed,
    required this.onDeletePressed
  }): super(key: key);

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
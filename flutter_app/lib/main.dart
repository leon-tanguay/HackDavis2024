import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;

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
            icon: Icon(page['icon'] as IconData),
            label: page['title'] as String,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return CouponList(coupons: coupons, onPressed: verifyCoupon);
      case 1:
        return MapScreen();
      case 2:
        return LoginScreen();
      default:
        return SizedBox.shrink();
    }
  }
}

class CouponList extends StatelessWidget {
  final List<String> coupons;
  final Function(String) onPressed;

  const CouponList({Key? key, required this.coupons, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: coupons.length,
      itemBuilder: (context, index) {
        final couponCode = coupons[index];
        return CouponTile(
          couponCode: couponCode,
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
  final VoidCallback onPressed;

  const CouponTile({Key? key, required this.couponCode, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(
          'Coupon Code: $couponCode',
          style: TextStyle(fontSize: 16.0),
        ),
        trailing: InkWell(
          onTap: onPressed,
          child: Icon(Icons.check_circle_outline),
        ),
      ),
    );
  }
}

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: latLng.LatLng(51.509364, -0.128928),
              initialZoom: 3.2,
            ),
            children: [
              TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State
{
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() {
    setState(() {
      _isLoading = true;
    });

    // Simulated authentication process (replace with actual logic)
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Simulated validation (replace with actual validation logic)
    bool isValidCredentials = validateCredentials(username, password);

    if (isValidCredentials) {
      // Print "login valid" upon successful validation
      print('Login valid');
    } else {
      setState(() {
        _isLoading = false;
      });
      // Show error message or toast for invalid credentials
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Invalid username or password'),
        backgroundColor: Colors.red,
      ));
    }
  }

  bool validateCredentials(String username, String password) {
    // Simulated validation (replace with actual validation logic)
    return username == 'admin' && password == 'password';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
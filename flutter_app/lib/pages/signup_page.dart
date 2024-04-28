import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>{

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int _success=1;
  late String? _userEmail;
  bool _isLoading = false;
  String _errorMessage ='';

void _register() async {
  setState(() {
    _isLoading = true;
    _errorMessage = '';  // Clear previous errors when starting a new registration attempt
  });

  try {
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text
    )).user;

    if (user != null) {
      setState(() {
        _success = 2;
        _userEmail = user.email;
        _isLoading = false;
      });
      // Optionally, navigate away from the registration page or clear the form
    }
  } on FirebaseAuthException catch (e) {
    setState(() {
      _success = 3;
      _isLoading = false;
      _errorMessage = e.code == 'email-already-in-use' 
                      ? 'This email is already in use.'
                      : 'An error occurred. Please try again.';
    });
  }
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
                    Container(
            child:Stack(
              children:<Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(15,110,0,0),
                    child:Text("Sign up Page",
                    style:TextStyle(
                      fontSize:40,fontWeight: FontWeight.bold
                    ))
                )
              ]
            )
          ),
          Container(padding:EdgeInsets.only(top:35,left:20,right:30),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _emailController,
                decoration:InputDecoration(
                  labelText:'EMAIL',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color:Colors.grey
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color:Colors.green),
                  )
                )
              ),
              SizedBox(height:20,),
                TextField(
                  controller: _passwordController,
                decoration:InputDecoration(
                  labelText:'PASSWORD',
                  labelStyle: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color:Colors.grey
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color:Colors.green),
                  )
                ),
                obscureText: true,
              ),
              SizedBox(height:5.0,),
              Container(
                alignment: Alignment.center,
                padding:const EdgeInsets.symmetric(horizontal: 16),
                child:Text(
                  _success==1
                  ? ''
                  :(
                    _success==2
                    ? 'Successfully Registered New Account!' : 'Something went wrong, please try again!'),
                    style:TextStyle(color: _success == 2 ? Colors.green : (_success == 3 ? Colors.red : Colors.black),
),
                )
              ),
              SizedBox(height:40,),
              Container(
                height: 40,
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  shadowColor: Colors.greenAccent,
                  color: Colors.black,
                  elevation: 7,
                  child: InkWell(
                    onTap: _isLoading ? null : _register,  // Disable tap when loading
                    child: Center(
                      child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)  // Show loading spinner
                        : Text(
                            'SIGN UP',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                    ),
                  ),
                ),
              ),
              SizedBox(height:15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                        Navigator.of(context).pop();
                    },
                    child:Text(
                      'Go back to Login',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration:TextDecoration.underline
                      ),
                    )
                  )
                ],
              )
            ],
          )
          )
        ]
      )
    );
  }
}
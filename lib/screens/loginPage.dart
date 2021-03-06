import 'package:bus_tracking_system/admin/adminPage.dart';
import 'package:bus_tracking_system/brand_colors.dart';
import 'package:bus_tracking_system/helpers/helperMethods.dart';
import 'package:bus_tracking_system/screens/mainPageDriver.dart';
import 'package:bus_tracking_system/screens/mainpage.dart';
import 'package:bus_tracking_system/screens/registrationPage.dart';
import 'package:bus_tracking_system/widgets/ProgressDialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../globalVariables.dart';

class LoginPage extends StatefulWidget {

  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();

  void showSnackBar(String title){
    final snackbar = SnackBar(
      content: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void login() async{

    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Logging you in..',),
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      if(userCredential.user != null) {
        // verify login
        DatabaseReference userRef = FirebaseDatabase.instance.reference().child(
            'passengers/${userCredential.user.uid}');
        userRef.once().then((DataSnapshot snapshot) {
          if (snapshot.value != null) {
            //isDriver = false;
            //HelperMethods.getPassengerInfo();
            HelperMethods.getTime();
            Navigator.pushNamedAndRemoveUntil(
                context, MainPage.id, (route) => false);
          } else {
            DatabaseReference userRef = FirebaseDatabase.instance.reference().child('drivers/${userCredential.user.uid}');
            userRef.once().then((DataSnapshot snapshot) {
              if(snapshot.value != null){
                //isDriver = false;
                currentUser = userCredential.user.uid;
                HelperMethods.getDriverInfo();
                Navigator.pushNamedAndRemoveUntil(context, MainPageDriver.id, (route) => false);
              } else{
                Navigator.pushNamedAndRemoveUntil(
                    context, AdminPage.id, (route) => false);
              }
            });
          }
        });
      }
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context);
    if (e.code == 'user-not-found') {
      showSnackBar('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      showSnackBar('Wrong password provided for that user.');
    }
  }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 80,),
                Image(
                  alignment: Alignment.center,
                  height: 150.0,
                  width: 150,
                  image: AssetImage('images/logoBus.png'),
                ),

                SizedBox(height: 20,),

                Text('Bus Tracking System App',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontFamily: 'Brand-Bold'),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[

                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email address',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 10.0,),

                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0,
                            )
                        ),
                        style: TextStyle(fontSize: 14),
                      ),

                      SizedBox(height: 40,),

                      RaisedButton(
                        onPressed: () async{

                          //check network availability

                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('No internet connection!');
                            return;
                          }

                          if(!emailController.text.contains('@')){
                            showSnackBar('Please enter a vaild email address.');
                            return;
                          }

                          if(passwordController.text.length < 5){
                            showSnackBar('Please enter a vaild password');
                            return;
                          }

                          login();

                        },
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25)
                        ),
                        color: BrandColors.colorAccent,
                        textColor: Colors.white,
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                FlatButton(
                  onPressed: (){
                    Navigator.pushNamedAndRemoveUntil(context, RegistrationPage.id, (route) => false);
                },
                  child: Text('Don\'t have an account, sign in here.')
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}

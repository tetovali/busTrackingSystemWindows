import 'package:bus_tracking_system/brand_colors.dart';
import 'package:bus_tracking_system/globalVariables.dart';
import 'package:bus_tracking_system/screens/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:bus_tracking_system/widgets/ProgressDialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bus_tracking_system/helpers/helperMethods.dart';

class ProfileTab extends StatefulWidget {

  static const String id = 'profile';

  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {

  final GlobalKey<ScaffoldState> scaffoldKey= new GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title, textAlign: TextAlign.center, style: TextStyle(fontSize: 15),),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  void logout() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(status: 'Logging out...'),
    );

    auth.signOut();
    print(auth.currentUser.email);
    Navigator.pushNamedAndRemoveUntil(context, LoginPage.id, (route) => false);
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
                SizedBox(height: 40,),

                Text('Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontFamily: 'Brand-Bold'),
                ),

                SizedBox(height: 20,),

                Image(
                  alignment: Alignment.center,
                  height: 150.0,
                  width: 150,
                  image: AssetImage('images/user_icon.png'),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: fullNamePassenger,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          hintText: "Full Name",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(height: 20.0,),

                      TextFormField(
                        initialValue: auth.currentUser.email,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          hintText: "Email",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(height: 20,),

                      TextFormField(
                        initialValue: phonePassenger,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Phone number",
                          hintText: "Phone",
                          border: OutlineInputBorder(),
                        ),
                      ),

                      SizedBox(height: 20,),

                      RaisedButton(
                        onPressed: () async{

                          //check network availability
                          var connectivityResult = await Connectivity().checkConnectivity();
                          if(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('No internet connection!');
                            return;
                          }
                          logout();

                        },
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(25)
                        ),
                        color: BrandColors.colorTextLight,
                        textColor: Colors.white,
                        child: Container(
                          height: 50,
                          child: Center(
                            child: Text(
                              'LOGOUT',
                              style: TextStyle(fontSize: 18, fontFamily: 'Brand-Bold'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

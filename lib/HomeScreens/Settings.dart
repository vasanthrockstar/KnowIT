import 'package:know_it_master/HomeScreens/SettingsOptions/how_to_use.dart';
import 'package:know_it_master/HomeScreens/SettingsOptions/privacy_policy.dart';
import 'package:know_it_master/HomeScreens/SettingsOptions/terms_conditions.dart';
import 'package:know_it_master/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:know_it_master/common_widgets/offline_widgets/offline_widget.dart';
import 'package:know_it_master/common_widgets/platform_alert/platform_alert_dialog.dart';
//import 'package:knowitapp/firebase/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:know_it_master/firebase/auth.dart';
import 'package:provider/provider.dart';

Future<void> _signOut(BuildContext context) async {
  try {
    final auth = Provider.of<AuthBase>(context, listen: false);
    await auth.signOut();
//    Navigator.of(context).pop();
  } catch (e) {
    print(e.toString());
  }
}

Future<void> _confirmSignOut(BuildContext context) async {
  final didRequestSignOut = await PlatformAlertDialog(
    title: 'Logout',
    content: 'Are you sure that you want to logout?',
    defaultActionText: 'Logout',
    cancelActionText: 'Cancel',
  ).show(context);
  if (didRequestSignOut == true) {
    _signOut(context);
  }
}

class SettingsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_SettingsPage(),
    );
  }
}

class F_SettingsPage extends StatefulWidget {

  @override
  _F_SettingsPageState createState() => _F_SettingsPageState();
}

class _F_SettingsPageState extends State<F_SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return offlineWidget( context );
  }

  Widget offlineWidget(BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB( 0,0,0,0 ),
        child: Scaffold(
          backgroundColor: Colors.white,

          appBar:
          PreferredSize(
            preferredSize: Size.fromHeight(130),
            child: CustomAppBar(
              leftActionBar: Container(
                child: Icon(
                  Icons.arrow_back,
                  size: 40,
                  color: Colors.white70,
                ),
              ),
              leftAction: () {
                Navigator.pop(context, true);
              },
              rightActionBar: Padding(
                padding: const EdgeInsets.only(top:15.0,),
                child: Container(
                    child: FlatButton(
                      onPressed: () {
                        print('clearing notification');
                      },
                      child: Text(
                        "",
                      ),
                    )),
              ),
              rightAction: () {
                print('right action bar is pressed in appbar');
              },
              primaryText: null,
              secondaryText: 'Settings',
              tabBarWidget: null,
            ),
          ),
          body: _buildContent( context ),
        ),
      ),

    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Center(

        child:
        Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB( 10,0,10,0 ),
                child: Column(

                  children: <Widget>[
                    SizedBox( height: 5.0 ),
                    _reportAnIssue( ),
                    _howToUse( ),
                    _privacyPolicy( ),
                    _termsAndConditions( ),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.fromLTRB( 30,20,30,20 ),
                child: Column(

                  children: <Widget>[

                    RaisedButton(
                      onPressed: () => _confirmSignOut(context),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular( 80.0 ) ),
                      padding: const EdgeInsets.all( 0.0 ),
                      child: Ink(
                        decoration: const BoxDecoration(
                          color: Color(0xFF222222),
                          borderRadius: BorderRadius.all( Radius.circular(
                              10 ) ),
                        ),
                        child: Container(
                          constraints: const BoxConstraints( minWidth: 88.0,
                              minHeight: 50.0 ),
                          // min sizes for Material buttons
                          alignment: Alignment.center,
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                              color: Color(0xFF71DB77),
                              letterSpacing: 1.5,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox( height: 10, ),
                    Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Colors.black45,
                        fontFamily: 'Montserrat',
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportAnIssue() {
    return Container(
      width: double.infinity,
      child: FlatButton(
        onPressed: () => print( 'Report an Issue Button Pressed' ),
        padding: EdgeInsets.all( 15.0 ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular( 0.0 ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text( 'Report an Issue',
                  style: TextStyle(
                    color: Colors.black87,
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    //fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],

            ),
            Column(
              children: <Widget>[
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black54,
                  size: 30,
                ),
              ],

            ),

          ],

        ),
      ),

    );
  }

  Widget _privacyPolicy() {
    return Container(
      width: double.infinity,
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PrivacyPolicy( ) ),
          );
        },
        padding: EdgeInsets.all( 15.0 ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular( 0.0 ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text( 'Privacy Policy',
                  style: TextStyle(
                    color: Colors.black87,
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    //fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],

            ),
            Column(
              children: <Widget>[
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black54,
                  size: 30,
                ),
              ],

            ),

          ],

        ),
      ),

    );
  }

  Widget _howToUse() {
    return Container(
      width: double.infinity,
      child: FlatButton(

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HowToUse( ) ),
          );
        },

        padding: EdgeInsets.all( 15.0 ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular( 0.0 ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[

                Text( 'How To Use',
                  style: TextStyle(
                    color: Colors.black87,
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    //fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],

            ),
            Column(
              children: <Widget>[
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black54,
                  size: 30,
                ),
              ],

            ),

          ],

        ),
      ),

    );
  }

  Widget _termsAndConditions() {
    return Container(
      width: double.infinity,
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TermsAndServices( ) ),
          );
        },
        padding: EdgeInsets.all( 15.0 ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular( 0.0 ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[

                Text( 'Terms & Conditions',
                  style: TextStyle(
                    color: Colors.black87,
                    letterSpacing: 1.5,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    //fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],

            ),
            Column(
              children: <Widget>[
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black54,
                  size: 30,
                ),
              ],

            ),

          ],

        ),
      ),

    );
  }
}
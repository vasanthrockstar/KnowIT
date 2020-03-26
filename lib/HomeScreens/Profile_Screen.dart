import 'package:flutter/material.dart';
import 'package:know_it_master/Database_models/UserDetails.dart';
import 'package:know_it_master/HomeScreens/ProfileScreen2.dart';
import 'package:know_it_master/HomeScreens/Profile_Tabs/my_links.dart';
import 'package:know_it_master/HomeScreens/Profile_Tabs/my_media.dart';
import 'package:know_it_master/HomeScreens/Profile_Tabs/my_reactions.dart';
import 'package:know_it_master/HomeScreens/Settings.dart';
import 'package:know_it_master/HomeScreens/SettingsOptions/how_to_use.dart';
import 'package:know_it_master/HomeScreens/SettingsOptions/privacy_policy.dart';
import 'package:know_it_master/HomeScreens/SettingsOptions/terms_conditions.dart';
import 'package:know_it_master/common_variables/app_colors.dart';
import 'package:know_it_master/common_variables/app_fonts.dart';
import 'package:know_it_master/common_variables/app_functions.dart';
import 'package:know_it_master/common_widgets/button_widget/to_do_button.dart';
import 'package:know_it_master/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:know_it_master/common_widgets/offline_widgets/offline_widget.dart';
import 'package:know_it_master/common_widgets/platform_alert/platform_alert_dialog.dart';
import 'package:know_it_master/firebase/auth.dart';
import 'package:know_it_master/firebase/database.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:provider/provider.dart';
import 'categories_tab.dart';

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


class ProfilePage extends StatelessWidget {
  ProfilePage({@required this.database});
  Database database;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_ProfilePage(database: database,),
    );
  }
}

class F_ProfilePage extends StatefulWidget {
  F_ProfilePage({@required this.database});
  Database database;

  @override
  _F_ProfilePageState createState() => _F_ProfilePageState();
}

class _F_ProfilePageState extends State<F_ProfilePage> {

  TextStyle selectedLabel = new TextStyle(
      color: Color(0xFF1F4B6E),
      fontFamily: 'Quicksand',
      fontWeight: FontWeight.w600,
      fontSize: 25.0);

  TextStyle unselectedLabel = new TextStyle(
      color: Color(0xFF1F4B6E),
      fontFamily: 'Quicksand',
      fontWeight: FontWeight.w500,
      fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget(BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Scaffold(
          body: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return StreamBuilder<UserDetails>(
        stream: widget.database.readUser(USER_ID),
        builder: (context, snapshot) {
          final user = snapshot.data;
          PopupMenu.context = context;
          return new MaterialApp(
            debugShowCheckedModeBanner: false,
            home: new Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(130),

                  //preferredSize : Size(double.infinity, 100),
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
                    rightActionBar: Container(
                      child:IconButton(
                          icon: Icon(
                            Icons.power_settings_new,
                            size: 35,
                            color: Colors.white70,
                          ),
                          onPressed: () =>_confirmSignOut(context)
                      ),
                    ),
                    rightAction: () {
                      print('right action bar is pressed in appbar');
                    },
                    primaryText: null,
                    secondaryText: 'Profile',
                  ),
                ),
              body: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: (user != null ? user.userImagePath : "") != null ? CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.grey[200],
                              backgroundImage:
                              NetworkImage((user != null ? user.userImagePath : "")),
                            ) : CircleAvatar(
                              radius: 40.0,
                              backgroundColor: Colors.grey[200],
                            ),
                          ),

                          SizedBox(height: 10,),
                          Text(user != null ? user.phoneNumber : 'loading...',style: descriptionStyleDarkBlur,),
                          SizedBox(height: 10,),
                          Text(user != null ? user.username : 'loading...',style: subTitleStyle,),
                          SizedBox(height: 10,),
                          Divider(
                            color: Colors.black.withOpacity(0.9),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(width: 10,),
                              Column(
                                children: <Widget>[
                                  Text("Links",style: descriptionStyle),
                                  Text(user != null ? user.totalLinks.toString() : "-",style: subTitleStyleLight,)
                                ],
                              ),
                              Column(children: <Widget>[
                                Text("Media",style: descriptionStyle),
                                Text(user != null ? user.totalMedia.toString() : '-',style: subTitleStyleLight,)
                              ],),
                              Column(children: <Widget>[
                                Text("Reacted",style: descriptionStyle),
                                Text(user != null ? user.totalReactions.toString() : '-',style: subTitleStyleLight,)
                              ],),
                              SizedBox(width: 10,),
                            ],
                          ),
                          Divider(
                            color: Colors.black.withOpacity(0.9),
                          ),
                          SizedBox(height: 5,),
                          ToDoButton(
                            assetName: 'images/googl-logo.png',
                            text: 'Check your Media',
                            textColor: subBackgroundColor,
                            backgroundColor: backgroundColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowMediaPage() ),
                              );
                            }
                          ),
                          SizedBox(height: 5,),
                          Divider(
                            color: Colors.black.withOpacity(0.9),
                          ),
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
                                      SizedBox( height: 10.0 ),
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
//                              Container(
//                                child: Padding(
//                                  padding: EdgeInsets.fromLTRB( 30,20,30,20 ),
//                                  child: Column(
//
//                                    children: <Widget>[
//
//                                      RaisedButton(
//                                        onPressed: () => _confirmSignOut(context),
//                                        shape: RoundedRectangleBorder(
//                                            borderRadius: BorderRadius.circular( 80.0 ) ),
//                                        padding: const EdgeInsets.all( 0.0 ),
//                                        child: Ink(
//                                          decoration: const BoxDecoration(
//                                            color: Color(0xFF222222),
//                                            borderRadius: BorderRadius.all( Radius.circular(
//                                                10 ) ),
//                                          ),
//                                          child: Container(
//                                            constraints: const BoxConstraints( minWidth: 88.0,
//                                                minHeight: 50.0 ),
//                                            // min sizes for Material buttons
//                                            alignment: Alignment.center,
//                                            child: Text(
//                                              'Sign Out',
//                                              style: TextStyle(
//                                                color: Color(0xFF71DB77),
//                                                letterSpacing: 1.5,
//                                                fontSize: 18.0,
//                                                fontWeight: FontWeight.w600,
//                                                fontFamily: 'Montserrat',
//                                              ),
//                                            ),
//                                          ),
//                                        ),
//                                      ),
//                                      SizedBox( height: 10, ),
//                                      Text(
//                                        'Version 1.0.0',
//                                        style: TextStyle(
//                                          color: Colors.black45,
//                                          fontFamily: 'Montserrat',
//                                          fontSize: 15.0,
//                                          fontWeight: FontWeight.w600,
//                                        ),
//                                      ),
//
//
//                                    ],
//                                  ),
//                                ),
//                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              ),
          );
        }
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

import 'package:flutter/material.dart';
import 'package:know_it_master/Database_models/UserDetails.dart';
import 'package:know_it_master/HomeScreens/Profile_Tabs/my_links.dart';
import 'package:know_it_master/HomeScreens/Profile_Tabs/my_media.dart';
import 'package:know_it_master/HomeScreens/Profile_Tabs/my_reactions.dart';
import 'package:know_it_master/HomeScreens/Settings.dart';
import 'package:know_it_master/common_variables/app_colors.dart';
import 'package:know_it_master/common_variables/app_fonts.dart';
import 'package:know_it_master/common_variables/app_functions.dart';
import 'package:know_it_master/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:know_it_master/common_widgets/offline_widgets/offline_widget.dart';
import 'package:know_it_master/firebase/database.dart';
import 'categories_tab.dart';


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
        return new MaterialApp(
          debugShowCheckedModeBanner: false,
          home: new DefaultTabController(
            length: categories.length,
            child: new Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(460),
                //preferredSize : Size(double.infinity, 100),
                child: CustomAppBar(
                  leftActionBar: Container(
                    child: Icon(
                      Icons.arrow_back,
                      size: 40,
                      color: Colors.black38,
                    ),
                  ),
                  leftAction: () {
                    Navigator.pop(context, true);
                  },
                  rightActionBar: Container(
                    child:IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: 40,
                        color: backgroundColor,
                      ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage() ),
                          );
                        }
                    ),
                  ),
                  rightAction: () {
                    print('right action bar is pressed in appbar');
                  },
                  primaryText: null,
                  secondaryText: 'Profile',
                  profile: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Positioned(
                              child: (user != null ? user.userImagePath : "") != null ? CircleAvatar(
                                radius: 40.0,
                                backgroundColor: Colors.grey[200],
                                backgroundImage:
                                NetworkImage((user != null ? user.userImagePath : "")),
                              ) : CircleAvatar(
                                radius: 30.0,
                                backgroundColor: Colors.grey[200],
                              ),
                            ),

                            SizedBox(height: 10,),
                            Text(user != null ? user.phoneNumber : 'loading...',style: descriptionStyleDarkBlur,),
                            SizedBox(height: 10,),
                            Text(user != null ? user.username : 'loading...',style: subTitleStyle,),
                            SizedBox(height: 10,),
                            Divider(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SizedBox(width: 10,),
                                Column(
                                  children: <Widget>[
                                    Text("Links",style: descriptionStyleDark),
                                    Text("01",style: subTitleStyleLight,)
                                  ],
                                ),
                                Column(children: <Widget>[
                                  Text("Media",style: descriptionStyleDark),
                                  Text("02",style: subTitleStyleLight,)
                                ],),
                                Column(children: <Widget>[
                                  Text("Reacted",style: descriptionStyleDark),
                                  Text("03",style: subTitleStyleLight,)
                                ],),
                                SizedBox(width: 10,),
                              ],
                            ),
                            Divider(
                              color: Colors.black.withOpacity(0.5),
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  tabBarWidget: Center(
                    child: new TabBar(
                      labelColor: backgroundColor,
                      labelStyle: selectedLabel,
                      unselectedLabelStyle: unselectedLabel,
                      isScrollable: true,
                      tabs: categories.map((Category choice) {
                        return new Tab(
                          text: choice.name,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              body: new TabBarView(
                children: categories.map((Category choice) {
                  if (choice.name == 'My Links') {
                    return new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new MyLinksPage(choice: choice, database: widget.database,),
                    );
                  } else if (choice.name == 'My Media') {
                    return new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new MyMediaPage(choice: choice, database: widget.database,),
                    );
                  }
                  else{
                    return new Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new MyReactionsPage(choice: choice),
                    );
                  }
                }).toList(),
              ),
            ),
          ),
        );
      }
    );
  }
}
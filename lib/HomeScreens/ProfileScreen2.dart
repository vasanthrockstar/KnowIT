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


class ShowMediaPage extends StatelessWidget {
  ShowMediaPage({@required this.database});
  Database database;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_ShowMediaPage(database: database,),
    );
  }
}

class F_ShowMediaPage extends StatefulWidget {
  F_ShowMediaPage({@required this.database});
  Database database;

  @override
  _F_ShowMediaPageState createState() => _F_ShowMediaPageState();
}

class _F_ShowMediaPageState extends State<F_ShowMediaPage> {

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
              appBar: new PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
          child: new Container(
          color: backgroundColor,
          child: new SafeArea(
          child: Column(
          children: <Widget>[
          new    TabBar(
          indicatorColor: subBackgroundColor,
          labelColor: Colors.white,
          labelStyle: selectedLabel,
          unselectedLabelStyle: unselectedLabel,
          isScrollable: true,
          tabs: categories.map((Category choice) {
          return new Tab(
          text: choice.name,
          );
          }).toList(),
          ),
          ],
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
                        child: new MyReactionsPage(choice: choice,database: widget.database,),
                      );
                    }
                  }).toList(),
                ),
                floatingActionButton: new Row(
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                    ),
                    new FloatingActionButton(
                      elevation: 90,
                      backgroundColor: backgroundColor,
                      child: new Icon(Icons.arrow_back,color: subBackgroundColor,),
                      onPressed: () {
                  Navigator.pop(context, true);
                    },
                    ),
                    new Padding(
                      padding: new EdgeInsets.symmetric(
                        horizontal: 134.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}
import'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:know_it_master/AuthenticationScreens/SignUp_Screen.dart';
import 'package:know_it_master/HomeScreens/Profile_Screen.dart';
import 'package:know_it_master/HomeScreens/categories_tab.dart';
import 'package:know_it_master/common_variables/app_colors.dart';
import 'package:know_it_master/common_variables/app_fonts.dart';
import 'package:know_it_master/common_widgets/button_widget/to_do_button.dart';
import 'package:know_it_master/common_widgets/loading_page.dart';
import 'package:know_it_master/common_widgets/offline_widgets/offline_widget.dart';
import 'package:provider/provider.dart';

class MyLinksPage extends StatelessWidget {
  const MyLinksPage(
      {Key key,
        this.choice,}): super(key: key);
  final Category choice;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_MyLinksPage(),
    );
  }
}

class F_MyLinksPage extends StatefulWidget {
  @override
  _F_MyLinksPageState createState() => _F_MyLinksPageState();
}

class _F_MyLinksPageState extends State<F_MyLinksPage> {
  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget (BuildContext context) {
    return CustomOfflineWidget(
      onlineChild: Padding(
        padding: const EdgeInsets.fromLTRB( 0, 0, 0, 0 ),
        child: Scaffold(
          backgroundColor: Colors.red,
          body: SingleChildScrollView(child: _buildContent( context )),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                FeedCard("VG","Vasanth","https://herms&touth.com/home/dot","Typically used with a user's profile image, or, in the absence of such an image, the user's initials.","15","7","images/concert.jpg","21 Feb,10.30am"),
                FeedCard("VG","Vasanth","https://herms&touth.com/home/dot","Typically used with a user's profile image, or, in the absence of such an image, the user's initials.","15","7","images/music.jpg","21 Feb,10.30am"),
                FeedCard("VG","Vasanth","https://herms&touth.com/home/dot","Typically used with a user's profile image, or, in the absence of such an image, the user's initials.","15","7","images/jake.jpg","21 Feb,10.30am"),
              ],
            ),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }

}

Widget FeedCard(String initial,String name,String weblink,String description,String correctCount,String wrongCount,String imgLink,String date)
{
  return Card(
    child: Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            CircleAvatar(
                              child: Text(initial,style: subTitleStyleLight,),
                              radius: 25.0,
                              backgroundColor: backgroundColor.withOpacity(.9),),
                          ],
                        ),
                        SizedBox(width: 30,),
                        Column(
                          children: <Widget>[
                            Text(name,style: subTitleStyle,)
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    InkWell(
                        child: Icon(Icons.more_horiz,
                          color: backgroundColor,
                          size: 30,
                        ),
                        onTap: () {
                        }
                    ),

                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        image: AssetImage(imgLink), fit: BoxFit.fill))
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: InkWell(
                child: Text(weblink,style: descriptionStyleDarkBlur,),
                onTap: () {}
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              description,style: subTitleStyle,
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.check,color: Colors.greenAccent,),
                                Text("Correct",style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),),
                              ],
                            ),
                            Text(correctCount,style: TextStyle(
                                color: Colors.greenAccent,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0),),
                          ],
                        ),
                        SizedBox(width: 20,),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.close,color: Colors.redAccent,),
                                Text("Wrong",style: TextStyle(
                                    color: Colors.redAccent,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0),),
                              ],
                            ),
                            Text(wrongCount,style: TextStyle(
                                color: Colors.redAccent,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0),),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text(date,style: descriptionStyleDarkBlur,),
                  ],
                ),
              ],
            ),
          )
        ],


      ),

    ),

  );

}
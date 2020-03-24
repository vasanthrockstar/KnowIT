import 'package:know_it_master/common_variables/app_colors.dart';
import 'package:know_it_master/common_variables/app_fonts.dart';
import 'package:know_it_master/common_widgets/button_widget/add_to_cart_button.dart';
import 'package:know_it_master/common_widgets/custom_appbar_widget/custom_app_bar.dart';
import 'package:know_it_master/common_widgets/offline_widgets/offline_widget.dart';
import 'package:know_it_master/common_widgets/platform_alert/platform_exception_alert_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddFeed extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: F_AddFeed(

      ),
    );
  }
}

class F_AddFeed extends StatefulWidget {
  F_AddFeed();

  @override
  _F_AddFeedState createState() => _F_AddFeedState();
}

class _F_AddFeedState extends State<F_AddFeed> {
  final TextEditingController _TitleController = TextEditingController();
  String _Title;
  final _formKey = GlobalKey<FormState>();

  String _itemUsageDescription;

  bool _validateAndSaveForm(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async{
//    if(_validateAndSaveForm()) {
//      try{
//        final _cartEntry = Cart(itemDescription : _itemUsageDescription);
//        final _inventryEntry = ItemInventry(itemDescription : _itemUsageDescription);
//        widget.database.updateCartDetails(_cartEntry, widget.cartID);
//        widget.database.updateInventryDetails(_inventryEntry, widget.cartID);
//
//        Navigator.of(context).pop();
//      }on PlatformException catch (e){
//        PlatformExceptionAlertDialog(
//          title: 'Operation failed',
//          exception: e,
//        ).show(context);
//      }
//    }
  }

  @override
  Widget build(BuildContext context) {
    return offlineWidget(context);
  }

  Widget offlineWidget(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar:
      PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: CustomAppBar(
          leftActionBar: Container(
            child: Icon(Icons.arrow_back, size: 40,color: Colors.black38,),
          ),
          leftAction: (){
            Navigator.pop(context,true);
          },
          primaryText: null,
          secondaryText: 'Add Feed',
          tabBarWidget: null,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildContent(),
            Container(
              child:  AnimatedButton(
                onTap: _submit,
                animationDuration: const Duration(milliseconds: 1000),
                initialText: "Add your Feed",
                finalText: "Feed Added",
                iconData: Icons.check,
                iconSize: 30.0,
                buttonStyle: ButtonStyle(
                  primaryColor: backgroundColor,
                  secondaryColor: Colors.white,
                  elevation: 10.0,
                  initialTextStyle: TextStyle(
                    fontSize: 20.0,
                    color: subBackgroundColor,
                  ),
                  finalTextStyle: TextStyle(
                    fontSize: 20.0,
                    color: backgroundColor,
                  ),
                  borderRadius: 10.0,
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }
  List<Widget>_buildFormChildren() {

    return [
      new TextFormField(
        keyboardType: TextInputType.text,
        controller: _TitleController,
        onSaved: (value) => _Title = value,
        onChanged: (value) {
          setState(() {
            _Title = value.toString();
          });
        } ,
        textInputAction: TextInputAction.done,
        obscureText: false,
        decoration: new InputDecoration(
          prefixIcon: Icon(
            Icons.title,
            color: backgroundColor,
          ),
          labelText: "Enter Title",
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(15.0),
            borderSide: new BorderSide(
            ),
          ),
        ),

        validator: (val) {
          if(val.length==0) {
            return "Title cannot be empty";
          }else{
            return null;
          }
        },
        style: new TextStyle(
          fontFamily: "Montserrat",
        ),
      ),
      SizedBox(height: 20,),
      GestureDetector(
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(
              width: 0.5, //                   <--- border width here
            ),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(10.0),
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Add Image",style: subTitleStyle,),
              Icon(Icons.add_photo_alternate,size: 40,)
            ],

          ),
        ),
        onTap: ()=> print("select image"),
      ),
      SizedBox(height: 20,),
      TextField(
        onChanged: (value) => _itemUsageDescription = value,
        minLines: 5,
        maxLines: 10,
        autocorrect: true,
        decoration: InputDecoration(
          hintText: 'Please write your description.',
          filled: true,
          fillColor: Colors.grey[100],
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey[100]),
          ),
        ),
        style: descriptionStyleDark,
        keyboardType: TextInputType.text,
        keyboardAppearance: Brightness.dark,
      ),
    ];
  }
}




import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/services.dart';
import 'package:know_it_master/HomeScreens/contact/contacts_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _count = 0;

  String codeArea;
  String phoneNumberForm;
  String guestName;

  //Contacts
  Iterable<Contact> _contacts;
  Contact _actualContact;


  TextEditingController phoneTextFieldController = TextEditingController();
  TextEditingController guestnameTextFieldController = TextEditingController();

  final  GlobalKey<FormState> form = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Picker Demo'),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {
          _count++;
        }),
        tooltip: 'Increment Counter',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBody()
  {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50.0,horizontal: 30.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
                key: form,
                child: ListView(
                  //padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width*.9,
                            padding:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white,
                                boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),
                            child: TextFormField(

                              controller: phoneTextFieldController,
                              validator: (val) {
                                return val != '' ? null : 'Por favor ingrese un número';
                              },
                              decoration: new InputDecoration(
                                  border: InputBorder.none,

                                  labelText: 'Teléfono invitado',
                                  prefixText: '     ',
                                  suffixStyle: const TextStyle(color: Colors.green)
                              ),
                              onSaved: (value) {
                                phoneNumberForm = value;
                              },
                            )
                        ),
                        Positioned(
                            right: 10.0,
                            top: 3.0,
                            //alignment: Alignment.topRight,
                            child: Tooltip(
                                message: "Libreta de contactos",
                                child: _buildSelectContactButton(Icons.perm_contact_calendar, Colors.white)
                            )
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    Container(
                      padding:
                      EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 0.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          boxShadow: [BoxShadow(blurRadius: 10.0, color: Colors.black12)]),

                      child: TextFormField(
                        controller: guestnameTextFieldController,
                        validator: (val) {
                          return val != '' ? null : 'Por favor ingrese nombre de invitado';
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: false,
                          counterText: "",
                          icon: const Icon(
                            Icons.person_outline,
                          ),
                          labelText: "Nombre Contacto",
                        ),
                        onSaved: (value) {
                          guestName = value;
                        },
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30.0)),
                    buttonCustom(
                      color: Color(0xFF4458be),
                      heigth: 50.0,
                      txt: "Agregar",
                      ontap: () {
                        print(phoneTextFieldController.text);
                      },
                    ),
                  ],
                )
            ),
          ),
        ),
      ),

    );

  }

  RawMaterialButton _buildSelectContactButton(IconData iconButton, Color colorButton) {

    return RawMaterialButton(
      constraints: const BoxConstraints(
          minWidth: 40.0, minHeight: 40.0
      ),
      onPressed: () => {
        _showContactList(context)

      },
      child: Icon(
        // Conditional expression:
        // show "favorite" icon or "favorite border" icon depending on widget.inFavorites:
        iconButton,
        color: Theme.of(context).primaryColorLight,
      ),
      elevation: 0.5,
      fillColor: colorButton,
      shape: CircleBorder(),
    );



  }
  // Getting list of contacts from AGENDA
  refreshContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      var contacts = await ContactsService.getContacts();
      setState(() {
        _contacts = contacts;
      });
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  // Asking Contact permissions
  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted && permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ?? PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  // Managing error when you don't have permissions
  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.disabled) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  // Showing contact list.
  Future<Null> _showContactList(BuildContext context) async {

    List<Contact> favoriteElements = [];
    final InputDecoration searchDecoration = const InputDecoration();

    refreshContacts();
    if (_contacts != null)
    {
      showDialog(
        context: context,
        builder: (_) =>
            SelectionDialogContacts(
              _contacts.toList(),
              favoriteElements,
              showCountryOnly: false,
              emptySearchBuilder: null,
              searchDecoration: searchDecoration,
            ),
      ).then((e) {
        if (e != null) {
          setState(() {
            _actualContact = e;
          });

          guestnameTextFieldController.text = _actualContact.middleName;
          phoneTextFieldController.text = _actualContact.phones.first.value;


        }
      });


    }

  }
}


/// Class For Custom Button
class buttonCustom extends StatelessWidget {
  String txt;
  Color color;
  GestureTapCallback ontap;
  double heigth;

  buttonCustom({this.txt, this.color, this.ontap, this.heigth});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        height: heigth,
        width: 300.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(
              const Radius.circular(30.0)
          ),
        ),
        child: Center(
            child: Text(
              txt,
              style: TextStyle(
                color: Colors.white,
              ),
            )),
      ),
    );
  }
}
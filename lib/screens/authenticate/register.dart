import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:sublin/screens/authenticate/sign_in.dart';
import 'package:sublin/services/auth_service.dart';
import 'package:sublin/utils/is_geolocation_permission_granted.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  String firstName = '';

  String email = '';
  String password = '';
  String type = 'user';
  String providerName = '';
  bool textFocus = false;
  bool firstNameProvided = false;
  bool emailProvided = false;
  bool providerChecked = false;
  // String providerAddress = '';
  // String providerType = 'Taxi- oder Mietwagenunternehmen';
  final _formKey = GlobalKey<FormState>();
  TextEditingController _providerAddressFieldController =
      TextEditingController();
  TextEditingController _emailFieldController = TextEditingController();
  RegExp regExpEmail = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  @override
  void initState() {
    super.initState();
    _getCurrentCoordinates();
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return Scaffold(
        // appBar: PreferredSize(
        //     preferredSize: Size.fromHeight(100.0), // here the desired height
        //     child: AppBar(
        //       title: Text('Registrierung',
        //           style: Theme.of(context).textTheme.headline1),
        //       backgroundColor: Colors.black12,
        //       elevation: 0,
        //     )),
        body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                textFocus = false;
              });
            },
            child: Stack(
              children: <Widget>[
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.only(top: 70, left: 15, right: 15),
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Hallo $firstName ',
                            style: Theme.of(context).textTheme.headline1,
                            textAlign: TextAlign.left,
                          ),
                          if (firstNameProvided)
                            Icon(
                              emailProvided
                                  ? Icons.sentiment_very_satisfied
                                  : Icons.sentiment_satisfied,
                              size: 30,
                            )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Wir sind in der Testphase. Bitte hilf uns, dieses Service auch in deinen Regionen verfügbar zu machen. Melde dich an und gib deine Plätze bekannt, die du ohne eigenes Auto erreichen willst. Damit können wir gezielter dort beginnen, wo die Nachfrage am größten ist.',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(top: (textFocus) ? 120 : 300),
                  duration: Duration(milliseconds: 100),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            TextFormField(
                                validator: (val) => val.length < 2
                                    ? 'Bitte gib einen Vornamen ein'
                                    : null,
                                onTap: () {
                                  textFocus = true;
                                },
                                onChanged: (val) {
                                  setState(() {
                                    firstName = val;
                                    if (val.length > 0) {
                                      firstNameProvided = true;
                                    } else {
                                      firstNameProvided = false;
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Dein Vorname',
                                  prefixIcon: Icon(Icons.person,
                                      color: firstNameProvided
                                          ? Theme.of(context).accentColor
                                          : null),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                onTap: () {
                                  setState(() {
                                    textFocus = true;
                                  });
                                },
                                onChanged: (val) {
                                  setState(() {
                                    email = val;
                                    if (regExpEmail.hasMatch(val)) {
                                      emailProvided = true;
                                    } else {
                                      emailProvided = false;
                                    }
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  filled: Theme.of(context)
                                      .inputDecorationTheme
                                      .filled,
                                  border: Theme.of(context)
                                      .inputDecorationTheme
                                      .border,
                                  focusedBorder: Theme.of(context)
                                      .inputDecorationTheme
                                      .focusedBorder,
                                  fillColor: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: emailProvided
                                        ? Theme.of(context).accentColor
                                        : null,
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    providerChecked = !providerChecked;
                                    if (providerChecked) {
                                      type = 'provider';
                                    } else {
                                      type = 'user';
                                    }
                                    print(type);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  color: Color.fromRGBO(245, 245, 245, 1),
                                  child: Row(
                                    children: <Widget>[
                                      (type == 'provider')
                                          ? _checked(context)
                                          : _unchecked(context),
                                      SizedBox(
                                        width: 13,
                                      ),
                                      Text(
                                        'Ich biete Fahrtendienste an',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RaisedButton(
                                  onPressed: () async {
                                    try {
                                      if (_formKey.currentState.validate()) {
                                        await _auth.register(
                                          email: email,
                                          password: 'asdfasdflköasdfkajflkj',
                                          firstName: firstName,
                                          type: type,
                                          // providerName: providerName,
                                          // providerAddress: providerAddress,
                                          // providerType: providerType,
                                        );
                                      }
                                    } catch (e) {
                                      print(e);
                                    }
                                  },
                                  child: Text('Registrieren'),
                                ),
                                FlatButton(
                                    textColor: Theme.of(context).accentColor,
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignIn())),
                                    child: Text('Du bist schon registriert?')),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }

  Icon _checked(context) {
    return Icon(
      Icons.check_box,
      color: Theme.of(context).accentColor,
    );
  }

  Icon _unchecked(context) {
    return Icon(
      Icons.check_box_outline_blank,
      color: Colors.black12,
    );
  }

  Future<void> _getCurrentCoordinates() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    try {
      print(await isLocationPermissionGranted());
      await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } catch (e) {
      print('_getCurrentCoordinates: $e');
    }
  }
}

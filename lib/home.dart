import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scqr/firestore_module.dart';
import 'package:scqr/users/admin.dart';
import 'package:scqr/users/scanners.dart';
import 'users/apmcCollector.dart';

class HomePage extends StatelessWidget {
  String userType = "Guest";
  HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Container(margin: EdgeInsets.all(30), child: LoginForm()));
  }
}

class LoginForm extends StatefulWidget {
  var changeState;
  //LoginForm({Key? key,required this.changeState}) : super(key: key);
  LoginForm({this.changeState});
  @override
  LoginFormState createState() {
    return LoginFormState(changeState: this.changeState);
  }
}

class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<LoginFormState>.
  var changeState;
  LoginFormState({this.changeState});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passController = new TextEditingController();
  String _currentSelectedValue = 'Admin';
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/finalLogo.PNG'),
                        fit: BoxFit.fill)),
              ),
              Text("Trace Fruit",
                  style: TextStyle(
                    fontSize: 30.0,
                    color: Colors.white,
                    fontFamily: "roboto",
                  )),
              SizedBox(
                height: 50,
              ),
              DropdownButtonFormField<String>(
                value: _currentSelectedValue,
                dropdownColor: Color.fromARGB(190, 15, 4, 89),
                items: [
                  'Admin',
                  'APMCCollector',
                  'Manufacturer',
                  'Wholesaler',
                  'Shipping',
                  'Retailer',
                  'Vendor'
                ]
                    .map((label) => DropdownMenuItem(
                          child: Text(label,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                              )),
                          value: label,
                        ))
                    .toList(),
                hint: Text('User Type'),
                onChanged: (value) {
                  setState(() {
                    _currentSelectedValue = value ?? '';
                  });
                },
                onSaved: (val) {
                  print('onSaved drowndownformfield $val');
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email ID ",
                  hintText: 'abc@apmc.com',
                  focusColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.white, fontSize: 15.0),
                  hintStyle:
                      TextStyle(color: Color.fromARGB(200, 255, 255, 255)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: passController,
                decoration: InputDecoration(
                  labelText: "Password ",
                  hintText: 'secure passcode',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 15.0),
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 87, right: 55, bottom: 2, left: 38),
                width: 300,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: MaterialButton(
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 15, 4, 89)),
                  ),
                  elevation: 4,
                  onPressed: () async {
                    //firebase auth
                    try {
                      var userType = await getUserType(emailController.text);
                      final credential = await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passController.text);

                      if (userType == _currentSelectedValue) {
                        if (_currentSelectedValue == 'APMCCollector') {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const APMCCollectorPage(),
                          ));
                        } else if (_currentSelectedValue == 'Admin') {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => AdminPage(),
                          ));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ScannersPage(
                                _currentSelectedValue, emailController.text),
                          ));
                        }
                      } else {
                        //alert box
                        throw FirebaseAuthException(code: 'invalid user type');
                      }
                    } on FirebaseAuthException catch (e) {
                      String errorMsg = 'Bad Login';
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                        errorMsg = 'No user found for that email.';
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                        errorMsg = 'Wrong password provided for that user.';
                      } else if (e.code == 'invalid user type') {
                        print('Please select the correct user type');
                        errorMsg = 'Please select the correct user type.';
                      }
                      print("Invalid Login");
                      return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: Text("Please Try Again"),
                                content: Text(
                                    "Input Information can't be validated. Please retry"),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: Text("OKAY"),
                                  ),
                                ],
                              ));
                    }
                  }, //validateForm,
                ),
              ),
              MaterialButton(
                child: Text("Continue as Guest? ",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.white,
                      fontFamily: "roboto",
                    )),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScannersPage("Guest", "Guest"),
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

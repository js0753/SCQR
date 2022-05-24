import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scqr/firestore_module.dart';
import 'package:scqr/users/scanners.dart';

class AdminPage extends StatelessWidget {
  String userType = "Guest";
  AdminPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 4, 89),
      body: Container(
          width: double.infinity,
          child: Container(margin: EdgeInsets.all(30), child: RegisterForm())),
    );
  }
}

class RegisterForm extends StatefulWidget {
  var changeState;
  //RegisterForm({Key? key,required this.changeState}) : super(key: key);
  RegisterForm({this.changeState});
  @override
  RegisterFormState createState() {
    return RegisterFormState(changeState: this.changeState);
  }
}

class RegisterFormState extends State<RegisterForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<RegisterFormState>.
  var changeState;
  RegisterFormState({this.changeState});
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
            children: <Widget>[
              // Add TextFormFields and ElevatedButton here.
              SizedBox(
                height: 50,
              ),
              Text("Administration ",
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
                                fontSize: 20.0,
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
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20.0),
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
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20.0),
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: 87, right: 55, bottom: 63, left: 38),
                width: 282,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: MaterialButton(
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                        fontSize: 20, color: Color.fromARGB(255, 15, 4, 89)),
                  ),
                  elevation: 4,
                  onPressed: () async {
                    //create user
                    var message = await addUser(emailController.text,
                        passController.text, _currentSelectedValue);
                    // print(message[0]);
                    return showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              title: Text(
                                "Success!",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 15, 4, 89)),
                              ),
                              content:
                                  Text("New participant added to the Network"),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text("OKAY"),
                                ),
                              ],
                            ));
                  }, //validateForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

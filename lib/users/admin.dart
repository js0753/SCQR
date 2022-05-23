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
  String _currentSelectedValue = 'Guest';
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          DropdownButtonFormField<String>(
            value: _currentSelectedValue,
            items: [
              'Admin',
              "Guest",
              'APMCCollector',
              'Manufacturer',
              'Wholesaler',
              'Shipping',
              'Retailer',
              'Vendor'
            ]
                .map((label) => DropdownMenuItem(
                      child: Text(label),
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
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'EmailId',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          TextFormField(
            controller: passController,
            decoration: InputDecoration(
              hintText: 'password',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 87, right: 55, bottom: 63, left: 38),
            width: 282,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: MaterialButton(
              child: Text(
                'Register',
                style: TextStyle(fontSize: 16, color: Colors.white),
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
                          title: Text("Message"),
                          content: Text(message),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("okay"),
                            ),
                          ],
                        ));
              }, //validateForm,
            ),
          ),
        ],
      ),
    );
  }
}

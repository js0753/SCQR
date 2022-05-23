import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

class HomeButton extends StatelessWidget {
  String text;
  var onTap;
  HomeButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25),
      color: Colors.black,
      child: InkWell(
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        onTap: this.onTap,
      ),
    );
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
              'Retailer',
              'Shipping',
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
                'Login',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              elevation: 4,
              onPressed: () async {
                //firebase auth
                try {
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passController.text);
                  if (_currentSelectedValue == 'APMCCollector') {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const APMCCollectorPage(),
                    ));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ScannersPage(
                          _currentSelectedValue, emailController.text),
                    ));
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    print('No user found for that email.');
                  } else if (e.code == 'wrong-password') {
                    print('Wrong password provided for that user.');
                  }
                }
              }, //validateForm,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:scqr/firestore_module.dart';

class FarmerForm extends StatefulWidget {
  var changeState;
  FarmerForm({Key? key}) : super(key: key);
  @override
  FarmerFormState createState() {
    return FarmerFormState();
  }
}

class FarmerFormState extends State<FarmerForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<FarmerFormState>.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController phnController = new TextEditingController();
  final TextEditingController addrController = new TextEditingController();
  final TextEditingController cityController = new TextEditingController();
  final TextEditingController stateController = new TextEditingController();
  final TextEditingController pinController = new TextEditingController();
  String userID="";
  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(60),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text("Enter Your Details : "),
              // Add TextFormFields and ElevatedButton here.
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Full Name',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: phnController,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: addrController,
                minLines: 2,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Address',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  hintText: 'City',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: stateController,
                decoration: InputDecoration(
                  hintText: 'State',
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: pinController,
                decoration: InputDecoration(
                  hintText: 'PIN',
                  hintStyle: TextStyle(color: Colors.grey),
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
                  color: Colors.purple,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: MaterialButton(
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  elevation: 4,
                  onPressed: () async {
                    userID = await addFarmer(
                        nameController.text,
                        phnController.text,
                        addrController.text,
                        cityController.text,
                        stateController.text,
                        pinController.text);

                    setState(() {
                      print("User Added : " + userID);
                    });
                  }, //validateForm,
                ),
              ),
              userID!=""?Text("Farmer ID :\n",style: TextStyle(fontSize: 15),):Container(),
              Text(userID,style: TextStyle(color: Colors.purple,fontSize: 20),)
            ],
          ),
        ),
      ),
    );
  }
}

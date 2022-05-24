import 'package:flutter/material.dart';
import 'package:scqr/home.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    _loadingInProgress = true;
    _loadData();
  }

  bool _loadingInProgress = true;

  Future _loadData() async {
    await new Future.delayed(new Duration(seconds: 3));
    _dataLoaded();
  }

  void _dataLoaded() {
    setState(() {
      _loadingInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
              backgroundColor: Color.fromARGB(255, 15, 4, 89),
              body: Container(
                child: Text("Something Went Wrong"),
              )));
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized || _loadingInProgress) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.limeAccent[300],
            ),
            textTheme:
                const TextTheme(bodyText2: TextStyle(color: Colors.white)),
          ),
          home: Scaffold(
              backgroundColor: Color.fromARGB(255, 15, 4, 89),
              body: IntroPage()));
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Color.fromARGB(255, 15, 4, 89), body: HomePage()));
  }
}

class IntroPage extends StatefulWidget {
  @override
  MyIntroState createState() => MyIntroState();
}

class MyIntroState extends State {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              image: DecorationImage(
                  image: AssetImage('assets/finalLogo.PNG'), fit: BoxFit.fill)),
        ),
        SizedBox(
          height: 50.0,
        ),
        Text("Trace Fruit",
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              fontFamily: "roboto",
            )),
      ],
    ));
  }
}

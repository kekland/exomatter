import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'homeFuncs.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: AuthCheck(),
    );
  }
}


class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {

  var reged;
  checkAuth()async{
   final user =  await FirebaseAuth.instance.currentUser();
   if(user!=null){
     await getUserDoc();
     reged = true;
   }else{
     reged = false;
   }
   Future.delayed(Duration(milliseconds: 200), (){
     setState((){});
   });
  }


  @override
  void initState() {
    checkAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
          child: reged!=null?(reged?HomePage():Authorization()):Scaffold(
        backgroundColor: Colors.teal,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(Icons.assignment, color: Colors.white, size: 50),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text('Exotic Matter', style: TextStyle(
                      color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold, 
                    )),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}





class Authorization extends StatefulWidget {
  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}
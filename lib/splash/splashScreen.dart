import 'package:flutter/material.dart';

//screens

import 'package:chatapp/splash/animation/fadeanimation.dart';
import 'package:chatapp/helper/helperfunction.dart';
import 'package:chatapp/views/chatRoomScreen.dart';
import 'package:chatapp/helper/authentication.dart';



//modules
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
	@override
	_SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{
	
  AnimationController _scaleController;
  AnimationController _scale2Controller;
  AnimationController _widthController;
  AnimationController _positionController;

  Animation<double> _scaleAnimation;
  Animation<double> _scale2Animation;
  Animation<double> _widthAnimation;
  Animation<double> _positionAnimation;

  Widget defaultHome;
  
  bool hideIcon = false;


  Future _getUser() async {
   
    
    var status = await HelperFunction.getUserLoggedInSharedPreference();
    print(status);
    if(status){

      setState((){
          defaultHome = ChatRoom();
      });
    }else {
      setState((){
          defaultHome = Authenticate();
      });
    }
     
  }

  
  @override
  void initState()  {
    // TODO: implement initState
     _getUser();
      print('done');
    super.initState();
     
   

    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350)
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0, end: 0.8
    ).animate(_scaleController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _widthController.forward();
      }
    });

    _widthController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600)
    );

    _widthAnimation = Tween<double>(
      begin: 80.0,
      end: 300.0
    ).animate(_widthController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _positionController.forward();
      }
    });

    _positionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
    );

    _positionAnimation = Tween<double>(
      begin: 0.0,
      end: 215.0
    ).animate(_positionController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          hideIcon = true;
        });
       _scale2Controller.forward();
      }
    });

    _scale2Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200)
    );
   _scaleController.forward();

    _scale2Animation = Tween<double>(
      begin: 1.0,
      end: 32.0
    ).animate(_scale2Controller)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
				//Navigator.push(context, PageTransition(type: PageTransitionType.fade, child: Home() ));
      	Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => defaultHome));
      }
    });
  }
 

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Container(
        height: height,
        width: width,
        child: Stack(
          children: <Widget>[
            Container(
             
              child: FadeAnimation(1, Container(
                width: width,
                height: height,
                child: Center(
                  child:Image.asset(
                    'image/logo.png',
                    height:300,
                    width:300
                  )
              )),
            ),
           )
          
          ],
        ),
      ),
    );
  }
}
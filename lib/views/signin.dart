import 'package:flutter/material.dart';
//screen
import 'package:chatapp/widgets/widget.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';

import 'package:chatapp/views/chatRoomScreen.dart';
import 'package:chatapp/views/signup.dart';

import 'package:chatapp/helper/helperfunction.dart';

import 'package:cloud_firestore/cloud_firestore.dart';




//modules
import 'package:firebase_auth/firebase_auth.dart';



class SignIn extends StatefulWidget {
  
	@override
	_SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

	bool isLoading = false;
	bool hidePassword = true;


	final GlobalKey<FormState> formKey = GlobalKey<FormState>();

	TextEditingController emailTextEditingController = new TextEditingController();
	TextEditingController passwordTextEditingController = new TextEditingController();
	
	AuthMethods authMethods = new AuthMethods();
	DatabaseMethods databaseMethods = new DatabaseMethods();

	QuerySnapshot snapshotUserInfo;

	signMeIn(BuildContext context) {
		if(formKey.currentState.validate()){

			HelperFunction.saveUserEmailSharedPreference(emailTextEditingController.text);
			
			databaseMethods.getUserByEmail(emailTextEditingController.text)
			.then((val){
				snapshotUserInfo = val;
				HelperFunction
					.saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
			
			});
			setState((){
				isLoading = true;
			});

			authMethods.signInwithEmailAndPassword(
				emailTextEditingController.text, passwordTextEditingController.text
			).then((val){
				if(val !=null){
					
					HelperFunction.saveUserLoggedInSharedPreference(true);
					Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom() ));
				} else {
					String msg = 'Username and password mismatch\nTry Again with correct credential';
					_showMyDialog(context, msg);
				}
			});


		}
	}

	signInWithGoogle() async {
		FirebaseUser user = await authMethods.signInWithGoogle();
		if(user!=null){
			Map<String, String> userInfoMap = {
					"name": user.displayName,
					"email": user.email,
				};
			HelperFunction.saveUserEmailSharedPreference(user.email);
			HelperFunction.saveUserNameSharedPreference(user.displayName);
			HelperFunction.saveUserLoggedInSharedPreference(true);
			Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom() ));
			
		}

	}

	changeHidePassword() {
		setState((){
			hidePassword = !hidePassword;
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: appBarMain(context),
			body: Container(
				padding: EdgeInsets.symmetric(horizontal:24),
				child: ListView(
					children: <Widget>[
					  Padding(
					  	padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.30)
					  ),
						Form(
					  	key: formKey,
					  	child: Column(
					  		children: <Widget>[
					  		Container(
									child: Row(
										children: <Widget>[	
											Container(
												width: MediaQuery.of(context).size.width*0.70,
													child:TextFormField(
														validator: emailValidator,
														controller: emailTextEditingController,
														style: simpleTextStyle(),
														decoration: textFieldInputDecoration('email'),
													),
												),
												GestureDetector(
													child:Container(
														padding: EdgeInsets.only(left:20,top:20),
														child: Icon(Icons.email,color:Colors.white54),
													)
												),
											]
										)
									),
									Container(
										child: Row(
											children: <Widget>[	
												Container(
													width: MediaQuery.of(context).size.width*0.70,
													child:TextFormField(
														obscureText: hidePassword,
														validator: (val){
															return val.isEmpty || val.length <6 ? "Enter atleast 6 character" : null;
														},
														controller: passwordTextEditingController,
														style: simpleTextStyle(),
														decoration: textFieldInputDecoration('password'),
													),
												),
												GestureDetector(
													child:Container(
														padding: EdgeInsets.only(left:20,top:20),
														child: Icon(hidePassword ? Icons.lock : Icons.lock_open,color:Colors.white54),
													),
													onTap: (){
														changeHidePassword();
													}
												),
											]
										)
									),
								]
							)
						),
						SizedBox(height:8),
						GestureDetector(
							child:Container(
								alignment: Alignment.centerRight,
								child: Container(
									padding: EdgeInsets.symmetric(horizontal:24,vertical:8),
									child:Text('Forgot password?',style:simpleTextStyle())
								)
							),
							onTap:(){
								sendTextWidget(context);
							}
						),	
						SizedBox(height:12),
						GestureDetector(
							child:Container(
								alignment: Alignment.center,
								width: MediaQuery.of(context).size.width,
								padding: EdgeInsets.symmetric(vertical: 20),
								decoration: BoxDecoration(
									gradient: LinearGradient(
										colors: [
										  const Color(0xff007EF4),
										  const Color(0xff2A750C)
											]
										),
									borderRadius: BorderRadius.circular(30),
									),
								child: Text("Sign In", style:TextStyle(
									color: Colors.white,
									fontSize: 17,
									)
								)
							),
							onTap: () {
								signMeIn(context);
							}
						),
						SizedBox(height:12),
						GestureDetector(
							child:Container(
								alignment: Alignment.center,
								width: MediaQuery.of(context).size.width,
								padding: EdgeInsets.symmetric(vertical: 20),
								decoration: BoxDecoration(
									color: Colors.white,
									borderRadius: BorderRadius.circular(30),
									),
								child: Text("Sign In with Google", style:TextStyle(
									color: Colors.black,
									fontSize: 17,
									)
								)
							),
							onTap:(){
								signInWithGoogle();
							}
						),
						SizedBox(height:16),
						Container(
							child: Row(
								mainAxisAlignment: MainAxisAlignment.center,
								children: <Widget>[
									Text("Don't have account? " ,style:simpleTextStyle()),
									GestureDetector(
										child:Text("Register now" ,style:TextStyle(
												color: Colors.white,
												fontSize:17,
												decoration: TextDecoration.underline,

											)
										),
										onTap: (){
											//widget.toggle();
											Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp() ));
										}
									)
								]
							)
						)

					]
				)//Column
			)//Container
		);//Scaffold
	}
	String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return '*Required';
    if (!regex.hasMatch(value))
      return '*Enter a valid email';
    else
      return null;
  }

  Future<void> _showMyDialog(BuildContext context,String msg) async {
	  return showDialog<void>(
	    context: context,
	    barrierDismissible: true, // user must tap button!
	    builder: (BuildContext context) {
	      return AlertDialog(

	        title: Text('HEY!'),
	        shape: RoundedRectangleBorder(
	          borderRadius:
	              BorderRadius.circular(20.0)),
	        content: SingleChildScrollView(
	          child: ListBody(
	            children: <Widget>[
	              Text(msg), 
	            ],
	          ),
	        ),
	        actions: <Widget>[       
	          FlatButton(
	            child: Center(
	              child:Text('Back',
	                style: TextStyle(color: Colors.red,fontSize:20),
	              ),
	            ),
	            onPressed: () {
	              Navigator.of(context).pop();
	            },
	          ),
	        ],
	      );
	    },
	  );
	}
}
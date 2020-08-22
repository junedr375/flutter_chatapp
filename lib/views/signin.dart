import 'package:flutter/material.dart';
//screen
import 'package:chatapp/widgets/widget.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';

import 'package:chatapp/views/chatRoomScreen.dart';

import 'package:chatapp/helper/authentication.dart';
import 'package:chatapp/helper/helperfunction.dart';

import 'package:cloud_firestore/cloud_firestore.dart';




//modules

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

	@override
	_SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

	bool isLoading = false;


	final GlobalKey<FormState> formKey = GlobalKey<FormState>();

	TextEditingController emailTextEditingController = new TextEditingController();
	TextEditingController passwordTextEditingController = new TextEditingController();
	
	AuthMethods authMethods = new AuthMethods();
	DatabaseMethods databaseMethods = new DatabaseMethods();

	QuerySnapshot snapshotUserInfo;

	signMeIn() {
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
				}
			});

		}
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
									TextFormField(
										validator: emailValidator,
										controller: emailTextEditingController,
										style: simpleTextStyle(),
										decoration: textFieldInputDecoration('email'),
									),
									TextFormField(
										obscureText: true,
										validator: (val){
											return val.isEmpty || val.length <6 ? "Enter atleast 6 character" : null;
										},
										controller: passwordTextEditingController,
										style: simpleTextStyle(),
										decoration: textFieldInputDecoration('password')
									),
								]
							)
						),
						SizedBox(height:8),
						Container(
							alignment: Alignment.centerRight,
							child: Container(
								padding: EdgeInsets.symmetric(horizontal:24,vertical:8),
								child:Text('Forgot password?',style:simpleTextStyle())
							)
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
								signMeIn();
							}
						),
						SizedBox(height:12),
						Container(
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
											widget.toggle();
											//Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp() ));
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
}
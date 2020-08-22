import 'package:flutter/material.dart';

//screen
import 'package:chatapp/widgets/widget.dart';

import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';

import 'package:chatapp/views/chatRoomScreen.dart';

import 'package:chatapp/helper/authentication.dart';
import 'package:chatapp/helper/helperfunction.dart';



//modules


class SignUp extends StatefulWidget {

	final Function toggle;
  SignUp(this.toggle);


	@override
	_SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

	bool isLoading = false;


	final GlobalKey<FormState> formKey = GlobalKey<FormState>();

	TextEditingController usernameTextEditingController = new TextEditingController();
	TextEditingController emailTextEditingController = new TextEditingController();
	TextEditingController passwordTextEditingController = new TextEditingController();
	
	AuthMethods authMethods = new AuthMethods();
	DatabaseMethods databaseMethods = new DatabaseMethods();

	signMeUp() {
		if(formKey.currentState.validate()){
			Map<String, String> userInfoMap = {
					"name": usernameTextEditingController.text,
					"email": emailTextEditingController.text,
				};
			HelperFunction.saveUserNameSharedPreference(usernameTextEditingController.text);
			HelperFunction.saveUserEmailSharedPreference(emailTextEditingController.text);
			

			setState((){
				isLoading = true;
			});

			authMethods.signUpwithEmailAndPassword(
				emailTextEditingController.text, passwordTextEditingController.text
			).then((val){
		  	databaseMethods.uploadUserInfo(userInfoMap);
			
				HelperFunction.saveUserLoggedInSharedPreference(true);
				Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom() ));
			});

		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: appBarMain(context),
			body: (isLoading)
			? Center(
					child:CircularProgressIndicator(
				)
			)
			:Container(
				padding: EdgeInsets.symmetric(horizontal:24),
				child: ListView(
					children: <Widget>[
					  Padding(
					  	padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.20)
					  ),
					  Form(
					  	key: formKey,
					  	child: Column(
					  		children: <Widget>[
									TextFormField(
										validator: (val){
											return val.isEmpty || val.length <4 ? "Enter more than 4 letter" : null;
										},
										controller: usernameTextEditingController,
										style: simpleTextStyle(),
										decoration: textFieldInputDecoration('username'),
									),
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
								child: Text("Sign Up", style:TextStyle(
									color: Colors.white,
									fontSize: 17,
									)
								)
							),
							onTap: (){
								signMeUp();
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
							child: Text("Sign Up with Google", style:TextStyle(
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
									Text("Already have account? " ,style:simpleTextStyle()),
									GestureDetector(
										child:Text("Sign In" ,style:TextStyle(
											color: Colors.white,
											fontSize:17,
											decoration: TextDecoration.underline,
											)
										),
										onTap:(){
											widget.toggle();
												//Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn() ));
										}
									)
								]
							)
						)

					]
				)//Column
			)//Container
		);
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
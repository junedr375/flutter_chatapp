import 'package:flutter/material.dart';


Widget appBarMain(BuildContext context) {
	return AppBar(
		title: Text('ChatApp', style:TextStyle(color:Colors.white,fontSize:20, fontWeight:FontWeight.w700)),

	);
} 


InputDecoration textFieldInputDecoration(String hintText) {
	return InputDecoration(
		hintText: hintText,
		hintStyle: TextStyle(
			color: Colors.white54,
		),//TextStyle
		focusedBorder: UnderlineInputBorder(
			borderSide: BorderSide(color:Colors.blue),
		),
		enabledBorder: UnderlineInputBorder(
			borderSide: BorderSide(color:Colors.white),
		),
	);	
}

TextStyle simpleTextStyle() {
	return TextStyle(
		color: Colors.white,
		fontSize:18,
	);
}
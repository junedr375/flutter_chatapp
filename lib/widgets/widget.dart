import 'package:flutter/material.dart';
import 'package:chatapp/services/auth.dart';


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

 
 
Future<void> loader(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(

        title: Text('Loading...'),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(25.0)),
        content: SingleChildScrollView(
          child: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
              ),
          ) 
        ),
      );

    },
  );
}



String email;
AuthMethods authMethods = new AuthMethods();
Future<void> sendTextWidget(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(

        title: Text('Reset password Email'),
        shape: RoundedRectangleBorder(
          borderRadius:
             BorderRadius.circular(20.0)),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Container(
              	height: 70,
	             	decoration:BoxDecoration(
	                border: Border(bottom: BorderSide(color: Colors.blue)),
	                color: Colors.white.withOpacity(0.3),
	              ),
	              child: TextFormField(
	                decoration: InputDecoration(

	                  border: InputBorder.none,
	                  labelStyle: TextStyle(color: Colors.black),
	                  labelText: 'Enter Email'
	              ),
                style: TextStyle(color: Colors.black),
                onChanged: (value) {
                  email = value;
                },
                validator: (value) => value.isEmpty ? "*Required" : null,  
              ),

            ),
            ],
          ),
        ),
        actions: <Widget>[       
          FlatButton(
            child: Center(
              child:Text('SEND',
                style: TextStyle(color: Colors.blue,fontSize:20),
              ),
            ),
            onPressed: () {
           		if(email==null){
           			String msg = 'Enter valid email';
           			 _showMyDialog(context,msg);
           		} else {
           			print(email);
           			authMethods.resetPassword(email);
           			Navigator.of(context).pop();
           			String msg = 'Done, Check your mail';
           			 _showMyDialog(context,msg);

           		}
            },
          ),
          FlatButton(
            child: Center(
              child:Text('BACK',
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
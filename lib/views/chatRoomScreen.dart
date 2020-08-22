import 'package:flutter/material.dart';

//screen
import 'package:chatapp/widgets/widget.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
//import 'package:chatapp/views/signin.dart';
import 'package:chatapp/views/search.dart';
import 'package:chatapp/views/conversationScreen.dart';

import 'package:chatapp/helper/authentication.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunction.dart';
//modules



class ChatRoom extends StatefulWidget {
	@override
	_ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

	AuthMethods authMethods = new AuthMethods();
	DatabaseMethods databaseMethods = new DatabaseMethods();
	Stream chatRoomStream;

	Widget chatRoomList(){
		return StreamBuilder(
			stream: chatRoomStream,
			builder: (context,snapshot){
				return snapshot.hasData ? 
					ListView.builder(
						itemCount: snapshot.data.documents.length,
						itemBuilder: (context, index){
							return ChatRoomTile(
								snapshot.data.documents[index]["chatroomid"]
									.toString().replaceAll("_","").replaceAll(Contants.myName,""),
								snapshot.data.documents[index]["chatroomid"]
							);
						}
					)
				: Container();
			}
		);
	}

	@override
	void initState(){
		getUserInfo();
		

		super.initState();
	}
	getUserInfo() async {
		Contants.myName = await HelperFunction.getUserNameSharedPreference();
		print(Contants.myName);

		databaseMethods.getChatRooms(Contants.myName).then((value){
			setState((){
				chatRoomStream = value;
			});
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text('ChatApp', style:TextStyle(color:Colors.white,fontSize:20, fontWeight:FontWeight.w700)),
				actions: [
					GestureDetector(
						child:Container(
							padding: EdgeInsets.only(right:16),
							child:Icon(Icons.exit_to_app)
						),
						onTap: (){
							authMethods.signOut();
							HelperFunction.saveUserLoggedInSharedPreference(false);
						  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate() ));
						}
					)
				]
			),//AppBar

			body: chatRoomList(),
			floatingActionButton: FloatingActionButton(
				child: Icon(Icons.search),
				onPressed: () {
					 Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen() ));
				}
			),	
		);//Scaffold
	}
}

class ChatRoomTile extends StatelessWidget {
	final String userName;
	final String chatRoomId;
	ChatRoomTile(this.userName,this.chatRoomId);

	@override
	Widget build(BuildContext context) {
		return GestureDetector(
			child: Container(
				color: Colors.grey[800],
				padding: EdgeInsets.symmetric(horizontal:24,vertical:10),
				child: Row(
					children: <Widget>[
						Container(
							height:40,
							width:40,
							child: Center(
								child:Text("${userName.substring(0,1).toUpperCase()}", style:simpleTextStyle()),
							),
							decoration: BoxDecoration(
								color: Colors.blue,
								borderRadius:BorderRadius.circular(40),
							)
						),
						SizedBox(width:8),
						Text(userName, style:simpleTextStyle()),

					]
				)
			),
			onTap:(){
			  Navigator.push(context, MaterialPageRoute(builder: (context) =>ConversationScreen(chatRoomId) ));
			}
		);
	}
}

import 'package:flutter/material.dart';
//screen
import 'package:chatapp/widgets/widget.dart';
import 'package:chatapp/views/conversationScreen.dart';

//services
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';

//helper
import 'package:chatapp/helper/constants.dart';

//modules
import 'package:cloud_firestore/cloud_firestore.dart';


class SearchScreen extends StatefulWidget {
	@override
	_SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

	TextEditingController searchTextEditingController = new TextEditingController();
	DatabaseMethods databaseMethods = new DatabaseMethods();

	QuerySnapshot searchSnapshot;

	initiateSearch() {
		databaseMethods.getUserByUsername(searchTextEditingController.text)
		.then((val){
			setState((){
				searchSnapshot = val;
			});
		});
										
	}

	Widget searchList(){
		return (searchSnapshot !=null) ? ListView.builder(
			itemCount: searchSnapshot.documents.length,
			shrinkWrap: true,
			itemBuilder: (context,index){
				return searchTile(
					userName: searchSnapshot.documents[index].data["name"],
					userEmail: searchSnapshot.documents[index].data["email"],
				);
			}
		) 
		: Container();
	}

	createChatRoomAndStartCoversation(String userName){

		if(userName != Contants.myName){
			String chatRoomId = getChatRoomId(userName, Contants.myName);

			List<String> users = [userName,Contants.myName];
			Map<String, dynamic> chatRoomMap = {
				"users": users,
				"chatroomid": chatRoomId,
			};

			DatabaseMethods().createChatRoom(chatRoomId,chatRoomMap);
			Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId) ));
		}	else {
			print('Yoou cant send message to youself');
		}
	}

	Widget searchTile({String userName,String userEmail}){
		return Container(
			padding: EdgeInsets.symmetric(horizontal:24,vertical:16),
			child: Row(
				children: <Widget>[
					Container(
						child:Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: <Widget>[
								Text(userName,style:simpleTextStyle()),
								Text(userEmail,style:simpleTextStyle()),
							]
						)
					),
					Spacer(),
					GestureDetector(
						child:Container(
							padding: EdgeInsets.symmetric(horizontal:16,vertical:8),
							decoration: BoxDecoration(
								color: Colors.blue,
								borderRadius: BorderRadius.circular(30),
							),
							child: Text("Message",style:simpleTextStyle()),
						),
						onTap:() {
							createChatRoomAndStartCoversation(userName);
						},
					),
				]
			)
		);
	}
	

	@override
	void initState(){
		initiateSearch();
		print(Contants.myName);
		super.initState();
	}


	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: appBarMain(context),
			body: Container(
				height: MediaQuery.of(context).size.height,
				child: ListView(
					children: <Widget>[
						Container(
							padding: EdgeInsets.symmetric(horizontal:24,vertical:16),
							color:Colors.grey[800],
							child:Row(
								children: <Widget>[
									Expanded(
										child:TextField(
											controller: searchTextEditingController,
											style: simpleTextStyle(),
											decoration: textFieldInputDecoration('Search...'),
									
										),
									),
									GestureDetector(
										child:Container(
											height:40,
											width:40,
											decoration: BoxDecoration(
												gradient: LinearGradient(
													colors:[
														const Color(0x36FFFFFF),
														const Color(0x0fFFFFFF)
													]
												),
												borderRadius: BorderRadius.circular(40),
											),
											child: Icon(Icons.search,color:Colors.white),
										),
										onTap:(){
											initiateSearch();
										}
									),
								]
							)//Row
						),//Container
						searchList(),

					]
				)//ListView
			)//conatainer
		);//Scaffold
	}

	getChatRoomId(String a, String b){
		if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
			return "$b\_$a";
		} else {
			return "$a\_$b";
		}
	}


}

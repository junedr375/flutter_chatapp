import 'package:flutter/material.dart';

//screen
import 'package:chatapp/widgets/widget.dart';

import 'package:chatapp/services/database.dart';
import 'package:chatapp/helper/constants.dart';


class ConversationScreen extends StatefulWidget {
	final String roomName;
	final String chatRoomId;
	ConversationScreen(this.roomName,this.chatRoomId);
	@override
	_ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
	
	TextEditingController messageController = new TextEditingController();
	DatabaseMethods databaseMethods = new DatabaseMethods();

	Stream chatMessageStream;
	ScrollController _scrollController = new ScrollController();

	Widget ChatMessageList(){
		return StreamBuilder(
			stream: chatMessageStream,
			builder: (context, snapshot){
				return snapshot.hasData ? Container( 
					height: MediaQuery.of(context).size.height*0.78,
					child:ListView.builder(
					//reverse: true,
					//shrinkWrap: true,
					controller: _scrollController,
				  itemCount: snapshot.data.documents.length,
					itemBuilder: (context,index){
						return MessageTile(snapshot.data.documents[index].data["message"],
							snapshot.data.documents[index].data["sendBy"] == Contants.myName
						);
					}
				) ): Container();
			}
		);
	}

	sendMessage(){

		if(messageController.text.isNotEmpty){
				Map<String, dynamic> messageMap = {
				"message": messageController.text,
				"sendBy": Contants.myName,
				"time": DateTime.now().millisecondsSinceEpoch,
			};	

			databaseMethods.addConversationMessages(widget.chatRoomId,messageMap);
			messageController.text = "";
			_scrollController.animateTo(_scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 1), curve: Curves.easeOut);
		}
	}	

	@override
	void initState(){
		print(widget.chatRoomId);
		print(Contants.myName);

	  databaseMethods.getConversationMessages(widget.chatRoomId)
	  	.then((value){
				setState((){
	  			chatMessageStream = value;
	  		});
	  	});
  		
	 	super.initState();
	}

	scrollDown(){
		_scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 100),
    );
	}
		

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text(widget.roomName, style:TextStyle(color:Colors.white,fontSize:20, fontWeight:FontWeight.w700)),
			),
			body: Stack(
				children: <Widget>[
					ChatMessageList(),
					Container(
						height: MediaQuery.of(context).size.height*0.10,
						//padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.10),
						alignment: Alignment.center,
						child: GestureDetector(
							child: Container(
								height:50,
								width:50,
								padding: EdgeInsets.only(bottom:5,top:5),
								child:Center(child:Icon(Icons.keyboard_arrow_down,size:50),),
								decoration: BoxDecoration(
									borderRadius: BorderRadius.circular(40),
									color: Colors.white.withOpacity(0.3),
								)
							),

							onTap: () {
								scrollDown();
							}
						),	
					),
					Container(
						alignment: Alignment.bottomCenter,
						child:Container(
							height: MediaQuery.of(context).size.height*0.10,
							padding: EdgeInsets.symmetric(horizontal:24,vertical:16),
							color:Colors.grey[800],
							child:Row(
								children: <Widget>[
									Expanded(
										child:TextField(
											controller: messageController,
											style: simpleTextStyle(),
											decoration: textFieldInputDecoration('Message...'),
									
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
											child: Icon(Icons.send,color:Colors.white),
										),
										onTap:(){
											sendMessage();
										}
									),
								]
							)//Row
						),//Container
					),


				]
			),
		//	floatingActionButton: 
		);
	}
}


class MessageTile extends StatelessWidget {
	final String message;
	final bool isSendByMe;
	MessageTile(this.message,this.isSendByMe);
	@override
	Widget build(BuildContext context) {
		return Container(
			padding: EdgeInsets.only(left: isSendByMe? 0:10, right: isSendByMe? 10:0),
			margin: EdgeInsets.symmetric(vertical:2),
			width:MediaQuery.of(context).size.width,
			alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
			child:Container(
				padding: EdgeInsets.symmetric(horizontal:24,vertical:16),
				decoration: BoxDecoration(
					gradient: LinearGradient(
						colors: isSendByMe ? [
							const Color(0xff007EF4),
							const Color(0Xff00AEBC),
							] : [
							const Color(0x1AFFFFFF),
							const Color(0Xff2A75CC),
							]
					),
					borderRadius: isSendByMe ?
						BorderRadius.only(
							topLeft: Radius.circular(23),
							topRight: Radius.circular(23),
							bottomLeft: Radius.circular(23)
						) : 
						BorderRadius.only(
							topLeft: Radius.circular(23),
							topRight: Radius.circular(23),
							bottomRight: Radius.circular(23)
						)
				),
				child: Text(message,
					style: TextStyle(
						color: Colors.white,
						fontSize:18
					),
				),
			),
		);
	}
}

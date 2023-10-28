import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/screens/profile_screen.dart';
import 'package:we_chat/widgets/chat_user_card.dart';

import '../api/apis.dart';
import '../main.dart';
import '../models/chat_user.dart';
class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false ;


  @override
  void initState() {
    super.initState();
    APIs.getSelfinfo();
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap:()=>FocusScope.of(context).unfocus() ,
      child: WillPopScope(
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
            title:_isSearching ?  TextField(
              decoration:const InputDecoration(
                border: InputBorder.none,hintText: 'Name,email,...'
              ),
              autofocus: true ,
              style: TextStyle(fontSize: 17,letterSpacing: 0.5),
              onChanged: (val){
                _searchList.clear();
                for(var i in _list){
                  if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())){
                    _searchList.add(i);
                  }
                  setState(() {
                    _searchList;
                  });
                }
              },
            ): const Text('We Chat'),
            actions: [IconButton(onPressed: (){
                setState(() {
                  _isSearching = !_isSearching;
                });
            },icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid:Icons.search),),
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(user: APIs.me)));
            },icon: Icon(Icons.more_vert),)],      ),
           // floatingActionButton: Padding(
             // padding: const EdgeInsets.only(bottom: 10),
    //   child: FloatingActionButton(onPressed: () async {
    //          await APIs.auth.signOut();
    //          await GoogleSignIn().signOut();
          //        },child: Icon(Icons.add_comment_rounded),),
          // ),
            body: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context,snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator(),);
                  case ConnectionState.active:
                  case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??[];
                  if(_list.isNotEmpty){
                    return ListView.builder(itemCount:_isSearching ? _searchList.length:_list.length ,
                        padding: EdgeInsets.only(top: mq.height * .01),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context,index){

                         return  ChatUserCard(user:_isSearching?_searchList[index] :_list[index],);
                          // return Text('Name :${_list[index]}');
                        });
                  }else{
                    return Center(
                      child: Text("No Connection found",style: TextStyle(fontSize: 20),),
                    );

                  }
                    break;
                  default:
                    return const Center(child: Text('Something went wrong.')); // Ajout de cette ligne
                }
              }
            ),
        ),
      ),
    );
  }
}
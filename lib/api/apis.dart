import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:we_chat/models/chat_user.dart';

import '../models/message.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;

  static ChatUser me = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using We Chat!",
      image: user.photoURL.toString(),
      createdAt: '',
      isOnline: 'false',
      lastActive: '',
      pushToken: '');
  static get user => auth.currentUser!;

  static Future<bool> userExists() async {
    return (await fireStore
            .collection('users')
            .doc(user.uid)
            .get())
        .exists;
  }




  static Future<void> getSelfinfo() async {
    return (await fireStore
        .collection('users')
        .doc(user.uid)
        .get()
        .then((user){
          if(user.exists){
            me= ChatUser.fromJson(user.data()!);
          }else{
            createUser().then((value) => getSelfinfo());
          }
    }));
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: user.uid,
        name: user.displayName.toString(),
        email: user.email.toString(),
        about: "Hey, I'm using We Chat!",
        image: user.photoURL.toString(),
        createdAt: time,
        isOnline: 'false',
        lastActive: time,
        pushToken: '');

    return await fireStore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return fireStore.collection('users').where('id',isNotEqualTo: user.uid).snapshots();
  }


  static Future<void> updateUserInfo() async {
    await fireStore
        .collection('users')
        .doc(user.uid)
        .update({'name':me.name,
      'about':me.about,});
  }


  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    print('Extension:$ext');
    final ref =storage.ref().child('profile_pictures/${user.uid}');
    await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0){
      print('Data Transferred:${p0.bytesTransferred /1000} kb');
    });
    me.image =await ref.getDownloadURL();
    await fireStore
        .collection('users')
        .doc(user.uid)
        .update({'image':me.image,
      });
  }


  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return fireStore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent',descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();


    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = fireStore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }


  static Future<void> updateMessageReadStatus(Message message) async{
    fireStore.collection('chats/${getConversationID(message.fromId)}/messages')
        .doc(message.sent).update({'read':DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return fireStore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent',descending: true)
        .limit(1)
        .snapshots();
  }


  static Future<void> sendChatImage(ChatUser chatUser,File file) async {
    final ext = file.path.split('.').last;
    print('Extension:$ext');
    final ref =storage.ref().child('images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0){
      print('Data Transferred:${p0.bytesTransferred /1000} kb');
    });
    final imageUrl=await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }


}

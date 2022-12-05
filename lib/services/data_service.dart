import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  Future updateUserData(
      {required String fullName, required String email}) async {
    final userCollection =
        await firebaseFirestore.collection('users').doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "uid": uid,
    });

    return userCollection;
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot = await firebaseFirestore
        .collection('users')
        .where("email", isEqualTo: email)
        .get();

    return snapshot;
  }

// ------------------------------------------------------------------------------------------------
// Getting user data

  getUserGroups() async {
    return firebaseFirestore.collection("users").doc(uid).snapshots();
  }

  // ----------------------------------------------------------------------------------------------------
  // Creating a group

  Future createGroup(String userName, String id, String groupname) async {
    print('admin $userName');
    DocumentReference groupdocumentReference =
        await firebaseFirestore.collection("groups").add({
      "groupname": groupname,
      "groupicon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupID": " ",
      "recentMessage": "",
      "recentMessageSender": "",
      "recentMessageTime": ""
    });
    await groupdocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupID": groupdocumentReference.id,
    });
    DocumentReference userDocumentReference =
        firebaseFirestore.collection("users").doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupdocumentReference.id}_$groupname"])
    });
  }

// Getting the chats and assign the group ID
  getChat(String groupID) async {
    return firebaseFirestore
        .collection('groups')
        .doc(groupID)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getGroupAdmin(String groupID) async {
    DocumentReference d = firebaseFirestore.collection("groups").doc(groupID);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["admin"];
  }

  // get group members here
  getGroupMembers(groupID) async {
    return firebaseFirestore.collection("groups").doc(groupID).snapshots();
  }

  // search for groups in list by Name
  searchByName(String groupName) {
    return firebaseFirestore
        .collection('groups')
        .where("groupname", isEqualTo: groupName)
        .get();
  }

  // function will return bool
  // Will check whether the current user is available in group or not
  Future<bool> isUserJoined(
      String groupName, String groupID, String userName) async {
    DocumentReference userDocumentreference =
        firebaseFirestore.collection('users').doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentreference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupID}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join/exit
  Future toggleGroupJoin(
      String groupID, String userName, String groupname) async {
    DocumentReference userDocumentReference =
        firebaseFirestore.collection('users').doc(uid);
    DocumentReference groupDocumentReference =
        firebaseFirestore.collection('groups').doc(groupID);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

// if user has our groups => then remove or add
    if (groups.contains("${groupID}_$groupname")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupID}_$groupname"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupID}_$groupname"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  // Here we are sending the message to other user and start conservation
  sendMessage(String groupID, Map<String, dynamic> chatMessageData) async {
    firebaseFirestore
        .collection('groups')
        .doc(groupID)
        .collection('messages')
        .add(chatMessageData);
    firebaseFirestore.collection('groups').doc(groupID).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
}

import 'package:chatsystem/Screens/ChatScreen.dart';
import 'package:chatsystem/services/data_service.dart';
import 'package:chatsystem/widgets/grouptile.dart';
import 'package:chatsystem/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatsystem/Helper/helper_functions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController seachrcontroller = TextEditingController();
  bool _isloading = false;
  QuerySnapshot? searchsnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  bool _isjoined = false;

  @override
  void initState() {
    getCurrentUserIdandName();
    super.initState();
  }

  getCurrentUserIdandName() async {
    await HelperFunctions.getUserNamefromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getAdminName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getMemberID(String r) {
    return r.substring(0, r.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Search",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: seachrcontroller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Groups.....",
                      hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                )),
                GestureDetector(
                  onTap: () {
                    initiateSearchMethod();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(40)),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          _isloading
              ? const Center(child: CircularProgressIndicator())
              : groupList()
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (seachrcontroller.text.isNotEmpty) {
      setState(() {
        _isloading = true;
      });
      await DatabaseService()
          .searchByName(seachrcontroller.text)
          .then((snapshot) {
        setState(() {
          searchsnapshot = snapshot;
          _isloading = false;
          hasUserSearched = true;
          print("Idar main print hua $snapshot");
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchsnapshot!.docs.length,
            itemBuilder: (context, index) {
              return grouptile(
                  userName: userName,
                  groupID: searchsnapshot!.docs[index]['groupID'],
                  groupName: searchsnapshot!.docs[index]['groupname'],
                  admin: searchsnapshot!.docs[index]['admin']);
            })
        : Container();
  }

  Widget grouptile(
      {required String userName,
      required String groupID,
      required String groupName,
      required String admin}) {
    joinedOrNot(userName, groupID, groupName,
        admin); // calling this function to check if user is joined the group or not and then setting their value to state.
    return ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            groupName.substring(0, 1).toUpperCase(),
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          groupName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "Admin: ${getAdminName(admin)}",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: InkWell(
          onTap: () async {
            await DatabaseService(uid: user!.uid)
                .toggleGroupJoin(groupID, userName, groupName);
            if (_isjoined) {
              setState(() {
                _isjoined = !_isjoined;
              });
              showSnackbar(
                  context, Colors.green, "Succesfully joined the Group");
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                            groupID: groupID,
                            groupName: groupName,
                            userName: userName)));
              });
            } else {
              setState(() {
                _isjoined = !_isjoined;
                showSnackbar(context, Colors.red, "Left the group $groupName");
              });
            }
          },
          child: _isjoined
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black),
                  child: const Text("Joined",
                      style: TextStyle(color: Colors.white)))
              : Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black),
                  child: const Text(
                    "Join Now",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
        ));
  }

// here we are checking whether the user is available in search group or not

  joinedOrNot(
      String userName, String groupId, String groupName, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        _isjoined = value;
      });
    });
  }
}

import 'package:chatsystem/Helper/helper_functions.dart';
import 'package:chatsystem/Screens/SearchScreen.dart';
import 'package:chatsystem/services/data_service.dart';
import 'package:chatsystem/widgets/drawer.dart';
import 'package:chatsystem/widgets/grouptile.dart';
import 'package:chatsystem/widgets/loader.dart';
import 'package:chatsystem/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatsystem/services/auth_services.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // HomeScreen({super.key});
  String userName = " ";
  bool _isloading = false;
  String email = " ";
  String groupname = " ";
  AuthServices authServices = AuthServices();
  Stream? groups;

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // ------------String manipulation here
  String getID(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailfromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNamefromSF().then(
      (value) {
        setState(() {
          userName = value!;
        });
      },
    );

    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              icon: const Icon(Icons.search))
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Chat Groups",
          style: TextStyle(fontSize: 24),
        ),
        centerTitle: true,
      ),
      drawer: DrawerScreen(),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  groupList() {
    return StreamBuilder(
        stream: groups,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              // return Text('just placeholder');

              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                    itemCount: snapshot.data["groups"].length,
                    itemBuilder: (context, index) {
                      int revserIndex =
                          snapshot.data["groups"].length - index - 1;
                      return GroupTile(
                          userName: snapshot.data["fullName"],
                          groupID: getID(snapshot.data["groups"][revserIndex]),
                          groupName:
                              getName(snapshot.data["groups"][revserIndex]));
                    });
              } else {
                return noGroupWidget();
                // return Text('no groups');
              }
            } else {
              return noGroupWidget();
            }
          } else {
            return const Loader();
          }
        });
  }

  Widget noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: const Icon(
              Icons.add_circle,
              color: Colors.grey,
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups , tap on the add icon to create a group ",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  popUpDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Create a group",
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isloading == true
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor),
                      )
                    : TextField(
                        onChanged: (val) {
                          setState(() {
                            groupname = val;
                          });
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("CANCEL"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (groupname != "") {
                    setState(() {
                      _isloading = true;
                    });
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .createGroup(userName,
                            FirebaseAuth.instance.currentUser!.uid, groupname)
                        .whenComplete(() {
                      _isloading = false;
                    });
                    Navigator.of(context).pop();
                    showSnackbar(
                        context, Colors.green, "Group Create Successfully");
                  }
                },
                child: Text("CREATE"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          );
        });
  }
}

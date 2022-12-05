import 'package:chatsystem/Screens/ChatScreen.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupID;
  final String groupName;
  const GroupTile(
      {super.key,
      required this.userName,
      required this.groupID,
      required this.groupName});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    groupID: widget.groupID,
                    groupName: widget.groupName,
                    userName: widget.userName,
                  )),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).primaryColor,
              child: Text(
                widget.groupName.substring(0, 1).toLowerCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white70),
              )),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          // subtitle: Text(widget.groupName),
        ),
      ),
    );
  }
}

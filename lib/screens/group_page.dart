import 'package:chat_app/models/msg_model.dart';
import 'package:chat_app/widgets/other_msg.dart';
import 'package:chat_app/widgets/own_msg.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class GroupPage extends StatefulWidget {
  final String name;
  final String userId;
  const GroupPage({super.key, required this.name, required this.userId});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  IO.Socket? socket;
  List<MsgModel> listMsg = [];
  TextEditingController msgController = TextEditingController();
  @override
  void initState() {
    connect();
    super.initState();
  }

  void connect() {
    socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    socket!.connect();

    socket!.onConnect((_) {
      print('connected to frontend');
      socket!.on(
        'sendMsgServer',
        (msg) {
          print(msg);
          if (msg['userId' != widget.userId]) {
            setState(
              () {
                listMsg.add(
                  MsgModel(
                    type: msg['type'],
                    msg: msg['msg'],
                    sender: msg['senderName'],
                  ),
                );
              },
            );
          }
        },
      );
    });
  }

  void sendMsg(String msg, String senderName) {
    MsgModel ownMsg = MsgModel(type: 'ownMsg', msg: msg, sender: senderName);

    listMsg.add(ownMsg);
    setState(() {
      listMsg;
    });
    socket!.emit('sendMsg', {
      'type': 'ownMsg',
      'msg': msg,
      'senderName': senderName,
      'userId': widget.userId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Anon-room'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: listMsg.length,
                itemBuilder: (context, index) {
                  if (listMsg[index].type == 'ownMsg') {
                    return OwnMsg(
                      sender: listMsg[index].sender,
                      msg: listMsg[index].msg,
                    );
                  } else {
                    return OtherMsg(
                      sender: listMsg[index].sender,
                      msg: listMsg[index].msg,
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: msgController,
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            String msg = msgController.text;
                            if (msg.isNotEmpty) {
                              sendMsg(msgController.text, widget.name);
                              msgController.clear();
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

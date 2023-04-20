import 'package:flutter/material.dart';
import 'package:projet_dev_b2/conversations_list_page.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
      ),
      body: ConversationsListPage(),
    );
  }
}

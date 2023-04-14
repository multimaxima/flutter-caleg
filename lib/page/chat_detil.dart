import 'package:flutter/material.dart';

class ChatDetilPage extends StatefulWidget {
  final int id;
  const ChatDetilPage(this.id, {super.key});

  @override
  State<ChatDetilPage> createState() => _ChatDetilPageState();
}

class _ChatDetilPageState extends State<ChatDetilPage> {
  late int id;

  @override
  void initState() {
    super.initState();
    id = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white10,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
            Colors.white,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../utils/posts.dart';

class Feed extends StatelessWidget {
  const Feed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Holbegram',
              style: TextStyle(
                fontFamily: 'Billabong',
                fontSize: 40,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 6),
            Image.asset(
              'assets/images/logo.webp',
              width: 25,
              height: 25,
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.add,
              color: Colors.black,
              size: 28,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(
              Icons.message_outlined,
              color: Colors.black,
              size: 28,
            ),
          ),
        ],
      ),
      body: const Posts(),
    );
  }
}
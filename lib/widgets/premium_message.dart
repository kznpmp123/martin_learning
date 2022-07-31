import 'package:flutter/material.dart';
import 'package:optimize/constants/active_constants.dart';

class PremiumMessage extends StatefulWidget {
  final Function onClick;
  final String type;
  final int id;
  const PremiumMessage(
      {Key? key, required this.onClick, required this.type, required this.id})
      : super(key: key);

  @override
  State<PremiumMessage> createState() => _PremiumMessageState();
}

class _PremiumMessageState extends State<PremiumMessage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        padding: const EdgeInsets.only(top: 100),
        child: Column(
          children: [
            const Text(
              "You need to subscribe",
              style: TextStyle(fontSize: 22),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 20),
                  backgroundColor: activeColors.primary),
              onPressed: () {
                widget.onClick();
              },
              child: const Text(
                'Get Now',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:math' as math;

class FlipCardAnimation extends StatefulWidget {
  const FlipCardAnimation({super.key});

  @override
  State<FlipCardAnimation> createState() => _FlipCardAnimationState();
}

class _FlipCardAnimationState extends State<FlipCardAnimation> {
  final List<bool> isFlippedList = List.generate(3, (_) => false); // Adjust the number of notes
  final int milliseconds = 1000;

  // List of notes
  final List<String> noteList = [
    'Week24',
    
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ListView.builder(
        itemCount: noteList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isFlippedList[index] = !isFlippedList[index];
                });
              },
              child: AnimatedContainer(
                transformAlignment: Alignment.center,
                transform: Matrix4.rotationY(isFlippedList[index] ? math.pi : 0),
                duration: Duration(milliseconds: milliseconds),
                height: screenHeight * 0.5,
                width: screenWidth * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF000000),
                      Color(0xFF434343),
                      Color(0xFF1E1E1E),
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(
                    noteList[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

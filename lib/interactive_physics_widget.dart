import 'dart:math';
import 'package:flutter/material.dart';

class InteractivePhysicsWidget extends StatefulWidget {
  const InteractivePhysicsWidget({super.key});

  @override
  State<InteractivePhysicsWidget> createState() =>
      _InteractivePhysicsWidgetState();
}

class _InteractivePhysicsWidgetState extends State<InteractivePhysicsWidget> {
  final List<Color> allColors = [Colors.red, Colors.green, Colors.blue];
  late List<Color> ballColors;
  late List<Color> containerColors;
  late Map<Color, bool> matched;
  Color? draggingColor;
  String? message;

  @override
  void initState() {
    super.initState();
    randomizeGame();
  }

  void randomizeGame() {
    final rand = Random();
    ballColors = List<Color>.from(allColors)..shuffle(rand);
    containerColors = List<Color>.from(allColors)..shuffle(rand);
    matched = {for (var color in allColors) color: false};
    message = null;
    draggingColor = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Physics Drag & Drop')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ballColors.map((color) {
                return matched[color]!
                    ? const SizedBox(width: 60, height: 60)
                    : Draggable<Color>(
                  data: color,
                  onDragStarted: () =>
                      setState(() => draggingColor = color),
                  onDraggableCanceled: (_, __) =>
                      setState(() => draggingColor = null),
                  onDragEnd: (_) => setState(() => draggingColor = null),
                  feedback: _buildBall(color, 60, opacity: 0.7),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: _buildBall(color, 60),
                  ),
                  child: _buildBall(color, 60),
                );
              }).toList(),
            ),
            const SizedBox(height: 60),
            // Drop targets row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: containerColors.map((color) {
                return DragTarget<Color>(
                  builder: (context, candidateData, rejectedData) {
                    final isActive = candidateData.isNotEmpty;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: matched[color]!
                            ? color.withOpacity(0.5)
                            : isActive
                            ? color.withOpacity(0.3)
                            : Colors.grey[200],
                        border: Border.all(
                          color: isActive
                              ? color
                              : matched[color]!
                              ? color
                              : Colors.grey,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: Center(
                        child: matched[color]!
                            ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 36,
                        )
                            : Icon(Icons.inbox, color: color, size: 36),
                      ),
                    );
                  },
                  onWillAccept: (data) => !matched[color]!,
                  onAccept: (data) {
                    setState(() {
                      if (data == color) {
                        matched[color] = true;
                        message = '';
                      } else {
                        message = 'Try again! Wrong container.';
                      }
                      draggingColor = null;
                    });
                  },
                  onLeave: (_) => setState(() => message = null),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            if (message != null)
              Text(
                message!,
                style: TextStyle(
                  color: message!.startsWith('Great')
                      ? Colors.green
                      : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            if (matched.values.every((v) => v)) ...[
              const Padding(
                padding: EdgeInsets.only(top: 24.0),
                child: Text(
                  'All matched! 🎉',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: randomizeGame,
                icon: const Icon(Icons.restart_alt),
                tooltip: 'Restart & Randomize',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBall(Color color, double size, {double opacity = 1.0}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(opacity),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}
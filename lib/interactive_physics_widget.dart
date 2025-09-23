import 'package:flutter/cupertino.dart';

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
  Widget build(BuildContext context) {
    return Container();
  }
}
    return Scaffold(
      appBar: AppBar(title: const Text('Physics Drag & Drop')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
          ],
        ),
      ),
    );
  }

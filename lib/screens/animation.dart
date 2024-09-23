import 'package:flutter/material.dart';

class DeliveryAnimation extends StatefulWidget {
  const DeliveryAnimation({super.key});

  @override
  DeliveryAnimationState createState() => DeliveryAnimationState();
}

class DeliveryAnimationState extends State<DeliveryAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset:
                Offset(_animation.value * MediaQuery.of(context).size.width, 0),
            child: _buildDeliveryWidget(),
          );
        },
      ),
    );
  }

  Widget _buildDeliveryWidget() {
    return Container(
      width: 100,
      height: 100,
      color: Colors.blue,
      child: const Icon(
        Icons.motorcycle,
        color: Colors.white,
        size: 50,
      ),
    );
  }
}

// Usage:
// Simply use DeliveryAnimation() wherever you want to display this loading animation.

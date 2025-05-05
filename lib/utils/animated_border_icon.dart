import 'package:flutter/material.dart';

class AnimatedBorderIcon extends StatefulWidget {
  final Widget icon;
  final double width;

  final Color color;

  const AnimatedBorderIcon({
    super.key,
    required this.icon,
    this.width = 50.0,
    this.color = Colors.deepOrange,
  });

  @override
  AnimatedBorderIconState createState() => AnimatedBorderIconState();
}

class AnimatedBorderIconState extends State<AnimatedBorderIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(seconds: 1),
    vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 4.0).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInCirc),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(_animation.value),
          decoration: BoxDecoration(
            // border: Border.all(
            color: widget.color,
            //   //width: _animation.value,
            // ),
            borderRadius: BorderRadius.circular(40),
          ),
          child: widget.icon,
        );
      },
    );
  }
}
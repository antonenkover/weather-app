import 'package:flutter/material.dart';

class AnimatedWeatherImage extends StatefulWidget {
  final String imageURL;

  AnimatedWeatherImage(this.imageURL);

  @override
  _AnimatedWeatherImageState createState() => _AnimatedWeatherImageState();
}

class _AnimatedWeatherImageState extends State<AnimatedWeatherImage>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  bool selected = true;

  void animate() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void initState() {
    animate();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animationController,
      child: GestureDetector(
        onTap: () {
          if (selected) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
          setState(() {
            selected = !selected;
          });
        },
        child: Image(
          fit: BoxFit.cover,
          image: AssetImage(widget.imageURL),
          height: MediaQuery.of(context).size.height * 0.2,
        ),
      ),
    );
  }
}

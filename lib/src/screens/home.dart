import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/cat.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation, flapAnimation;
  AnimationController catController, flapController;

  @override
  void initState() {
    super.initState();

    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    catAnimation = Tween(begin: -35.0, end: -80.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeInOut,
      ),
    );

    flapController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    flapAnimation = Tween(
      begin: pi * 0.6,
      end: pi * 0.65,
    ).animate(
      CurvedAnimation(
        parent: flapController,
        curve: Curves.easeInOut,
      ),
    );

    flapController.forward();
    flapAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        flapController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        flapController.forward();
      }
    });
  }

  onTapped() {
    if (catController.status == AnimationStatus.completed) {
      flapController.forward();
      catController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      flapController.stop();
      catController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation Demo'),
      ),
      body: Center(
        child: GestureDetector(
          child: Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              buildCat(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
          ),
          onTap: onTapped,
        ),
      ),
    );
  }

  Widget buildCat() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown[300],
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 10.0,
      top: 3.0,
      child: AnimatedBuilder(
        animation: flapAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: flapAnimation.value,
            alignment: Alignment.topLeft,
            child: child,
          );
        },
        child: Container(
          height: 10.0,
          width: 100.0,
          color: Colors.brown[300],
        ),
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 10.0,
      top: 3.0,
      child: AnimatedBuilder(
        animation: flapAnimation,
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            angle: -flapAnimation.value,
            alignment: Alignment.topRight,
          );
        },
        child: Container(
          height: 10.0,
          width: 100.0,
          color: Colors.brown[300],
        ),
      ),
    );
  }
}

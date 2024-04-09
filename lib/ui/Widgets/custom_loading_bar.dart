import 'dart:async';

import 'package:flutter/material.dart';

class RunningDotsLoader extends StatefulWidget {
  final Color color;
  final double size;

  const RunningDotsLoader({
    Key? key,
    this.color = Colors.teal,
    this.size = 10.0,
  }) : super(key: key);

  @override
  _RunningDotsLoaderState createState() => _RunningDotsLoaderState();
}

class _RunningDotsLoaderState extends State<RunningDotsLoader> with SingleTickerProviderStateMixin {

  late Animation<double> _animation;
   Timer timer = Timer.periodic(Duration(milliseconds: 500),  (timer) { });
  void changeSize(){
    timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if(count == 0){
        setState(() {
          dot1 = 2.0;
          dot2 = 1.0;
          dot3 = 1.0;
        });
      }else if(count == 1){
        setState(() {
          dot2 = 2.0;
        });
      }else if(count == 2){
        setState(() {
          dot1 = 1.0;
          dot3 = 2.0;
        });
      }
      count++;
      if(count > 2){
        count = 0;
      }
    });
  }
  @override
  dispose(){
    timer.cancel();
    super.dispose();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer;
    changeSize();
  }
  double dot1 = 1.0;
  double dot2 = 1.0;
  double dot3 = 1.0;
  int count = 0;
 

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TweenAnimationBuilder(
          
          tween: 
        Tween(begin: 0.0, end: dot1),
         duration: Duration(milliseconds: 500),
          builder: (_,val,child)=>Transform.scale(scale: val,child: 
          child,),
            child: Dot(color: widget.color, size: widget.size),
          ),
        SizedBox(width: 10),
        TweenAnimationBuilder(tween: 
        Tween(begin: 0.0, end: dot2),
         duration: Duration(milliseconds: 500),
          builder: (_,val,child)=>Transform.scale(scale: val,child: 
          child,),
            child: Dot(color: widget.color, size: widget.size),
          ),
           SizedBox(width: 10),
        TweenAnimationBuilder(tween: 
        Tween(begin: 0.0, end: dot3),
         duration: Duration(milliseconds: 500),
          builder: (_,val,child)=>Transform.scale(scale: val,child: 
          child,),
            child: Dot(color: widget.color, size: widget.size),
          ),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  final Color color;
  final double size;

  const Dot({Key? key, required this.color, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

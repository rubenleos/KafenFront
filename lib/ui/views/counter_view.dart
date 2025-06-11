import 'package:flutter/material.dart';
import 'package:kafen/ui/shared/custom_app_menu.dart';

class CounterView extends StatefulWidget {
  @override
  _CounterViewState createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  int _counter = 5;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         
          children: <Widget>[
          
            Spacer(),
            Text('Contador stateful',style: TextStyle(fontSize: 20),),
            
            Text(
              'Número actual:',
            ),
            Text(
              '$_counter',
            
            ),
          ],
        ),
      
     
    );
  }
}





///  final CarouselSliderController _carouselController = CarouselSliderController();
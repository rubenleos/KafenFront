import 'package:flutter/material.dart';
import 'package:kafen/ui/shared/custom_app_menu.dart';

class CounterProviderView extends StatefulWidget {
  @override
  _CounterProviderViewState createState() => _CounterProviderViewState();
}

class _CounterProviderViewState extends State<CounterProviderView> {
  int _counter = 15;

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
            Text('Contador provider',style: TextStyle(fontSize: 20),),
            
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
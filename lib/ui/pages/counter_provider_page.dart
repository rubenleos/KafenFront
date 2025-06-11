import 'package:flutter/material.dart';
import 'package:kafen/ui/shared/custom_app_menu.dart';

class CounterProviderPage extends StatefulWidget {
  @override
  _CounterProviderPageState createState() => _CounterProviderPageState();
}

class _CounterProviderPageState extends State<CounterProviderPage> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter Page'),
      ),
      body: Center(
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
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrementar',
            child: Icon(Icons.remove),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Incrementar',
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
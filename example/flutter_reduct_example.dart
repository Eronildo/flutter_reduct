import 'package:flutter/material.dart';
import 'package:flutter_reduct/flutter_reduct.dart';
import 'package:reduct/reduct.dart';

void main() {
  CounterReducer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Reduct',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Reduct'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: AtomListener<int>(
        atom: counterState,
        listener: (context, value) {
          final snackBar = SnackBar(content: Text('Counter: $value'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Center(
          child: AtomBuilder<int>(
            atom: counterState,
            builder: (context, value) => Text(
              'Counter: $value',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementAction,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// atoms
final counterState = Atom(0);
final incrementAction = Atom.action();

// reducer
class CounterReducer extends Reducer {
  CounterReducer() {
    on(incrementAction, (_) => counterState.value++);
  }
}

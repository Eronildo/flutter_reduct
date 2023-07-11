# Flutter Reduct

A flutter widgets for [reduct](https://pub.dev/packages/reduct) library.

## Install

```yaml
flutter pub add flutter_reduct
```

## AtomBuilder

```dart
final counterState = Atom(0);

...
// Inside widget builder:
AtomBuilder<int>(
  atom: counterState,
  builder: (context, value) => Text('Counter: $value'),
);
```

## AtomListener

```dart
final counterState = Atom(0);

...
// Inside widget builder:
AtomListener<int>(
  atom: counterState,
  listener: (context, count) {
    final snackBar = SnackBar(content: Text('Counter: $count'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  },
  child: Container(),
);
```
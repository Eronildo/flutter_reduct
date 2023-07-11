import 'package:flutter/material.dart';
import 'package:reduct/reduct.dart';

/// Signature for the `builder` function which takes the `BuildContext` and
/// [value] and is responsible for returning a widget which is to be rendered.
/// This is analogous to the `builder` function in [StreamBuilder].
typedef WidgetBuilder<S> = Widget Function(BuildContext context, S value);

/// [AtomBuilder] handles building a widget in response to new `value`.
/// [AtomBuilder] is analogous to [StreamBuilder] but has simplified API to
/// reduce the amount of boilerplate code needed as well as [atom]-specific
/// performance improvements.
///
/// ```dart
/// AtomBuilder<int>(
///   atom: counterState,
///   builder: (context, value) {
///    return Text('$value');
///   }
/// )
/// ```
class AtomBuilder<S> extends BuilderBase<S> {
  const AtomBuilder({
    super.key,
    required super.atom,
    required this.builder,
  });

  /// The [builder] function which will be invoked on each widget build.
  /// The [builder] takes the `BuildContext` and current `value` and
  /// must return a widget.
  /// This is analogous to the [builder] function in [StreamBuilder].
  final WidgetBuilder<S> builder;

  @override
  Widget build(BuildContext context, S value) => builder(context, value);
}

/// Base class for widgets that build themselves based on interaction with
/// a specified [atom].
///
/// A [BuilderBase] is stateful and maintains the state of the interaction
/// so far. The type of the state and how it is updated with each interaction
/// is defined by sub-classes.
abstract class BuilderBase<S> extends StatefulWidget {
  const BuilderBase({
    super.key,
    required this.atom,
  });

  /// The [atom] that the [BuilderBase] will interact with.
  /// If omitted, [BuilderBase] will automatically perform a lookup using
  /// the current `BuildContext`.
  final Atom<S> atom;

  /// Returns a widget based on the `BuildContext` and current [value].
  Widget build(BuildContext context, S value);

  @override
  State<BuilderBase<S>> createState() => _BuilderBaseState<S>();
}

class _BuilderBaseState<S> extends State<BuilderBase<S>> {
  late Atom<S> _atom;
  late S _value;
  late VoidCallback _disposer;

  @override
  void initState() {
    super.initState();

    _atom = widget.atom;
    _value = _atom.value;

    _disposer = _atom.addListener((value) {
      setState(() => _value = value);
    });
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.build(context, _value),
    );
  }
}

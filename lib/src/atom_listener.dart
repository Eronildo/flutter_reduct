import 'package:flutter/material.dart';
import 'package:reduct/reduct.dart';

/// Signature for the `listener` function which takes the `BuildContext` along
/// with the `value` and is responsible for executing in response to
/// `value` changes.
typedef WidgetListener<S> = void Function(BuildContext context, S value);

/// Takes a [AtomListener] and an [atom] and invokes
/// the [listener] in response to `value` changes in the [atom].
/// It should be used for functionality that needs to occur only in response to
/// a `value` change such as navigation, showing a `SnackBar`, showing
/// a `Dialog`, etc...
///
/// ```dart
/// AtomListener<int>(
///   atom: counter,
///   listener: (context, value) {
///     // do stuff here based on value
///   },
///   child: Container(),
/// )
/// ```
class AtomListener<S> extends ListenerBase<S> {
  const AtomListener({
    super.key,
    required super.atom,
    required super.listener,
    required this.child,
  });

  /// The widget which will be rendered as a descendant of the
  /// [AtomListener].
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// Base class for widgets that listen to state changes in a specified [atom].
///
/// A [ListenerBase] is stateful and maintains the atom subscription.
/// The type of the atom and what happens with each value change
/// is defined by sub-classes.
abstract class ListenerBase<S> extends StatefulWidget {
  const ListenerBase({
    super.key,
    required this.atom,
    required this.listener,
  });

  /// The [atom] whose `value` will be listened to.
  /// Whenever the [atom]'s `value` changes, [listener] will be invoked.
  final Atom<S> atom;

  /// The [AtomListener] which will be called on every `value` change.
  /// This [listener] should be used for any code which needs to execute
  /// in response to a `value` change.
  final WidgetListener<S> listener;

  Widget build(BuildContext context);

  @override
  State<ListenerBase<S>> createState() => _ListenerBaseState<S>();
}

class _ListenerBaseState<S> extends State<ListenerBase<S>> {
  late VoidCallback _disposer;

  @override
  void initState() {
    super.initState();

    _disposer = widget.atom.addListener((value) {
      widget.listener(context, value);
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
      child: widget.build(context),
    );
  }
}

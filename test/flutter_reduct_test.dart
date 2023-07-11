import 'package:flutter/material.dart';
import 'package:flutter_reduct/flutter_reduct.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:reduct/reduct.dart';

void main() {
  testWidgets('AtomBuilder', (tester) async {
    final state = Atom<int>(42);

    await tester.pumpWidget(
      MaterialApp(
        home: AtomBuilder<int>(
          atom: state,
          builder: (context, value) {
            return Text('$value');
          },
        ),
      ),
    );

    expect(find.text('42'), findsOneWidget);

    state.value++;
    await tester.pump();

    expect(find.text('42'), findsNothing);
    expect(find.text('43'), findsOneWidget);
  });

  testWidgets('AtomListener', (tester) async {
    int counter = 0;
    final state = Atom<int>(42);

    await tester.pumpWidget(
      MaterialApp(
        home: AtomListener(
          atom: state,
          listener: (context, value) {
            counter = value;
          },
          child: Container(),
        ),
      ),
    );

    expect(counter, 0);

    state.value++;
    await tester.pump();

    expect(counter, 43);
  });
}

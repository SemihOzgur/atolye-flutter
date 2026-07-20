import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leather_care_admin/core/widgets/skeleton_box.dart';
import 'package:leather_care_admin/core/widgets/skeleton_list_tile.dart';

void main() {
  testWidgets('SkeletonBox renders and animates without throwing', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SkeletonBox(width: 100, height: 20)),
      ),
    );

    expect(find.byType(SkeletonBox), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 700));

    expect(tester.takeException(), isNull);
  });

  testWidgets('SkeletonList renders the requested number of rows', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: SkeletonList(count: 3)),
      ),
    );

    expect(find.byType(SkeletonListTile), findsNWidgets(3));
  });
}

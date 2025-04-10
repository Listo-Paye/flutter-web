import 'package:dio_mocked_responses/dio_mocked_responses.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter_kit/flavors.dart';
import 'package:flutter_starter_kit/injection.dart';
import 'package:flutter_starter_kit/ui/ui_module.dart';

Future<void> jaiLanceLapplicationAvecSucces(WidgetTester tester) async {
  MockInterceptor.clearHistory();
  F.appFlavor = Flavor.test;
  getIt.allowReassignment = true;
  configureDependencies();
  TestWidgetsFlutterBinding.ensureInitialized();
  await tester.pumpWidget(App());
  await tester.pumpAndSettle();
  tester.view.physicalSize = const Size(1900, 1200);
  tester.view.devicePixelRatio = 1;
  tester.view.platformDispatcher.textScaleFactorTestValue = 0.5;
  await tester.pumpAndSettle(const Duration(milliseconds: 500));
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_furnish_app/app.dart';
import 'package:virtual_furnish_app/ui/Screens/Authentication/login_page.dart';
import 'package:virtual_furnish_app/ui/Screens/root_page.dart';


Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase for tests
  testWidgets('Virtual Furnish smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(
      home: RootPage(), // Example with LoginPage as the initial route
    ));

    // Verify that LoginPage is present.
    expect(find.byType(LoginPage), findsOneWidget);
  });
}

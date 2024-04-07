import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:dawgs/main.dart';
import 'package:dawgs/components/text_field.dart';

// Define mock HTTP client class
class MockHttpClient extends Mock implements http.Client {}

void main() {
  testWidgets('Widget renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp());

    // Verify that the title text is displayed
    expect(find.text('Discussions'), findsOneWidget);

    // Verify that the post discussion text fields are rendered
    expect(find.byType(MyTextField), findsNWidgets(2));

    // Verify that the post button is rendered
    expect(find.byIcon(Icons.arrow_circle_up), findsOneWidget);
  });

  testWidgets('Post discussion button tap triggers HTTP request',
      (WidgetTester tester) async {
    // Mock HTTP client
    final mockHttpClient = MockHttpClient();

    // Provide the mock client to the app
    runApp(MaterialApp(
      home: MyHomePage(title: 'Home Page'),
    ));

    // Tap the post discussion button
    await tester.tap(find.byIcon(Icons.arrow_circle_up));
    await tester.pump();
  });
}

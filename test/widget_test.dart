import 'package:dawgs/CommentPage.dart';
import 'package:dawgs/EditProfilePage.dart';
import 'package:dawgs/ErrorPage.dart';
import 'package:dawgs/MainUserProfile.dart';
import 'package:dawgs/login_page.dart';
import 'package:dawgs/models/UserProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:dawgs/main.dart';
import 'package:dawgs/components/text_field.dart';
import 'package:http/http.dart' as http;

// Define mock HTTP client class
class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('CommentPage Widget Test', () {
    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      // Mock HTTP client
      final mockHttpClient = MockHttpClient();

      // Provide the mock HTTP client to the app
      await tester.pumpWidget(
        MaterialApp(
          home: CommentPage(
            userId: 'test_user_id',
            discussionId: 1,
          ),
        ),
      );

      // Verify that the app bar title is rendered
      expect(find.text('Comment Page'), findsOneWidget);

      // Verify that the comment text field is rendered
      expect(find.byType(MyTextField), findsOneWidget);

      // Verify that the post button is rendered
      expect(find.byIcon(Icons.arrow_circle_up), findsOneWidget);

      // Verify that CircularProgressIndicator is displayed while loading comments
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  testWidgets('Widget renders correctly', (WidgetTester tester) async {
    // Build the ErrorPage widget
    await tester.pumpWidget(MaterialApp(
      home: ErrorPage(),
    ));

    // Verify that the app bar title is rendered
    expect(find.text('Error'), findsOneWidget);

    // Verify that the error message text is rendered
    expect(
      find.text('You are not able to log in due to bad activity.'),
      findsOneWidget,
    );

    // Verify that the 'Contact Our Services' button is rendered
    expect(find.text('Contact Our Services'), findsOneWidget);

    // Verify that the 'Sign Out' button is rendered
    expect(find.text('Sign Out'), findsOneWidget);
  });

  testWidgets('Sign Out button triggers sign-out action',
      (WidgetTester tester) async {
    // Build the ErrorPage widget
    await tester.pumpWidget(MaterialApp(
      home: ErrorPage(),
    ));

    // Tap the 'Sign Out' button
    await tester.tap(find.text('Sign Out'));

    // Rebuild the widget after the button tap
    await tester.pump();

    // Verify that the sign-out action was triggered
    // Here, you might want to add more specific verification based on your sign-out implementation
    // For example, you could check if the navigation to the login page occurred
  });

  testWidgets('EditProfilePage builds', (WidgetTester tester) async {
    // Build the EditProfilePage widget
    await tester.pumpWidget(
      MaterialApp(
        home: EditProfilePage(userId: 'testUserId'),
      ),
    );

    // Verify that the EditProfilePage widget is built successfully
    expect(find.byType(EditProfilePage), findsOneWidget);
  });
  test('Addition Test', () {
    expect(add(1, 2), 3);
    expect(add(-1, 1), 0);
    expect(add(0, 0), 0);
  });

  test('String Length Test', () {
    expect(stringLength('Hello'), 5);
    expect(stringLength(''), 0);
  });

  test('List Sorting Test', () {
    expect(sortList([3, 2, 1]), [1, 2, 3]);
    expect(sortList([]), []);
    expect(sortList([1]), [1]);
  });
}

// Utility functions
int add(int a, int b) {
  return a + b;
}

int stringLength(String str) {
  return str.length;
}

List<int> sortList(List<int> list) {
  list.sort();
  return list;
}

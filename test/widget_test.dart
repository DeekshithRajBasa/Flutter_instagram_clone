// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instagram_clone/main.dart';
import 'package:instagram_clone/screens/main_navigation_screen.dart';
import 'package:instagram_clone/screens/onboarding/welcome_screen.dart';

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('Instagram clone app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(WelcomeScreen), findsOneWidget);

    final continueBtn = find.textContaining('Continue as');
    if (continueBtn.evaluate().isNotEmpty) {
      await tester.tap(continueBtn);
    } else {
      // Clean zero-data welcome screen
      await tester.enterText(
          find.byType(TextField).first, 'test_user');
      await tester.tap(find.text('Log In'));
    }

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(MainNavigationScreen), findsOneWidget);
  });
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _createMockHttpClient();
  }
}

HttpClient _createMockHttpClient() {
  return _FakeHttpClient();
}

final List<int> _transparentImage = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];

class _FakeHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _FakeHttpClientRequest();

  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

class _FakeHttpClientRequest implements HttpClientRequest {
  @override
  HttpHeaders get headers => _FakeHttpHeaders();

  @override
  Future<HttpClientResponse> close() async => _FakeHttpClientResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

class _FakeHttpHeaders implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

class _FakeHttpClientResponse extends StreamView<List<int>>
    implements HttpClientResponse {
  _FakeHttpClientResponse()
      : super(Stream<List<int>>.value(_transparentImage));

  @override
  int get statusCode => HttpStatus.ok;

  @override
  int get contentLength => _transparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

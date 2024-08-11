import 'dart:convert';

import 'package:cleaner/core/error/exceptions.dart';
import 'package:cleaner/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:cleaner/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture.dart';

class MockHttpClient extends Mock implements Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  NumberTriviaRemoteDatasourceImpl? numberTriviaRemoteDatasource;
  MockHttpClient? mockHttpClient;

  setUpAll(() => registerFallbackValue(FakeUri()));

  setUp(() {
    mockHttpClient = MockHttpClient();
    numberTriviaRemoteDatasource =
        NumberTriviaRemoteDatasourceImpl(httpClient: mockHttpClient!);
  });

  void setupMockHttpClient200() {
    when(
      () => mockHttpClient!.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => Response(fixture('trivia.json'), 200));
  }

  void setupMockHttpClient404() {
    when(
      () => mockHttpClient!.get(any(), headers: any(named: 'headers')),
    ).thenAnswer((_) async => Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const number = 1;
    final numberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform GET request on a URL with number beign endpoint, 
          with appliccation--json header''', () async {
      setupMockHttpClient200();

      numberTriviaRemoteDatasource!.getConcreteNumberTrivia(number);

      verify(() => mockHttpClient!.get(
          Uri(path: "http://numbersapi.com/$number"),
          headers: {'Content-type': 'application/json'}));
    });

    test('should return NumberTrivia when response is 200', () async {
      setupMockHttpClient200();

      final result =
          await numberTriviaRemoteDatasource!.getConcreteNumberTrivia(number);

      expect(result, numberTriviaModel);
    });

    test('should throw ServerException when response is not 200', () async {
      setupMockHttpClient404();

      expect(
          () => numberTriviaRemoteDatasource!.getConcreteNumberTrivia(number),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    const number = 1;
    final numberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform GET request on a URL with number beign endpoint, 
          with appliccation--json header''', () async {
      setupMockHttpClient200();

      numberTriviaRemoteDatasource!.getRandomNumberTrivia();

      verify(() => mockHttpClient!.get(
          Uri(path: "http://numbersapi.com/random"),
          headers: {'Content-type': 'application/json'}));
    });

    test('should return NumberTrivia when response is 200', () async {
      setupMockHttpClient200();

      final result =
          await numberTriviaRemoteDatasource!.getRandomNumberTrivia();

      expect(result, numberTriviaModel);
    });

    test('should throw ServerException when response is not 200', () async {
      setupMockHttpClient404();

      expect(
          () => numberTriviaRemoteDatasource!.getRandomNumberTrivia(),
          throwsA(const TypeMatcher<ServerException>()));
    });
  });
}

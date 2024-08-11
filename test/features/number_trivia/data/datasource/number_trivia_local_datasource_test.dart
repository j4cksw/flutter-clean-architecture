import 'dart:convert';

import 'package:cleaner/core/error/exceptions.dart';
import 'package:cleaner/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:cleaner/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  LocalDatasourceImpl? localDatasourceImpl;
  MockSharedPreferences? mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDatasourceImpl =
        LocalDatasourceImpl(sharedPreferences: mockSharedPreferences!);
  });

  group('getLastNumberTrivia', () {
    test('should return NumberTrivia from SharedPreferences', () async {
      when(() => mockSharedPreferences!.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));

      final result = await localDatasourceImpl!.getLastNumberTrivia();

      verify(
        () => mockSharedPreferences!.getString('CACHED_NUMBER_TRIVIA'),
      );
      expect(
          result,
          NumberTriviaModel.fromJson(
              json.decode(fixture('trivia_cached.json'))));
    });

    test('should throw CacheException when no cache', () async {
      when(() => mockSharedPreferences!.getString(any())).thenReturn(null);

      expect(() => localDatasourceImpl!.getLastNumberTrivia(),
          throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    test('should call SharedPreferences to cache data', () async {
      when(() => mockSharedPreferences!.setString(any(), any()))
          .thenAnswer((_) => Future.value(true));

      const numberTriviaModel = NumberTriviaModel(text: 'test', number: 999);
      localDatasourceImpl!.cacheNumberTrivia(numberTriviaModel);

      verify(
        () => mockSharedPreferences!
            .setString('CACHED_NUMBER_TRIVIA', json.encode(numberTriviaModel)),
      );
    });
  });
}

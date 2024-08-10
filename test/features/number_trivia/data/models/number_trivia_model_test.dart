import 'dart:convert';

import 'package:cleaner/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:cleaner/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');

  test('model should be subclass of entity', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });
  
  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer', () async {
      final jsonMap = json.decode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);
      
      expect(result, tNumberTriviaModel);
    });

    test('should return a valid model when the JSON number is a double', () async {
      final jsonMap = json.decode(fixture('trivia_double.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);

      expect(result, tNumberTriviaModel);
    });
  });
}


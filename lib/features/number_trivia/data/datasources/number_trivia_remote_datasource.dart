import 'package:cleaner/features/number_trivia/data/models/number_trivia_model.dart';

import '../../domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDatasource {
  ///
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  ///
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
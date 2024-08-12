import 'dart:convert';

import 'package:cleaner/core/error/exceptions.dart';
import 'package:cleaner/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart';

abstract class NumberTriviaRemoteDatasource {
  ///
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  ///
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDatasourceImpl implements NumberTriviaRemoteDatasource {
  final Client httpClient;

  NumberTriviaRemoteDatasourceImpl({required this.httpClient});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _getFromUrl("$number");

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getFromUrl("random/trivia");

  Future<NumberTriviaModel> _getFromUrl(url) async {
    final response = await httpClient.get(
        Uri.parse("http://numbersapi.com/$url"),
        headers: {'Content-type': 'application/json'});

    if (response.statusCode != 200) {
      throw ServerException();
    }

    return NumberTriviaModel.fromJson(json.decode(response.body));
  }
}

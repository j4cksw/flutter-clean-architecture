import 'dart:convert';

import 'package:cleaner/core/error/exceptions.dart';
import 'package:cleaner/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDatasource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class LocalDatasourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences sharedPreferences;
  LocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) async {
    sharedPreferences.setString('CACHED_NUMBER_TRIVIA', json.encode(triviaToCache.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final cached = sharedPreferences.getString('CACHED_NUMBER_TRIVIA');
    if (cached == null) {
      throw CacheException();
    }
    return Future.value(NumberTriviaModel.fromJson(json.decode(cached)));
  }
}

import 'package:cleaner/core/error/exceptions.dart';
import 'package:cleaner/core/error/failures.dart';
import 'package:cleaner/core/network/network_info.dart';
import 'package:cleaner/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:cleaner/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:cleaner/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:cleaner/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:cleaner/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTriviaModel> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDatasource remoteDatasource;
  final NumberTriviaLocalDatasource localDatasource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteDatasource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDatasource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final result = await getConcreteOrRandom();
        localDatasource.cacheNumberTrivia(result);
        return Right(result);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(await localDatasource.getLastNumberTrivia());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}

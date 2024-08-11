import 'package:cleaner/core/error/exceptions.dart';
import 'package:cleaner/core/error/failures.dart';
import 'package:cleaner/core/network/network_info.dart';
import 'package:cleaner/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:cleaner/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:cleaner/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:cleaner/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleaner/features/number_trivia/domain/repositories/number_trivia_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDatasource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl? repository;
  NumberTriviaRemoteDatasource? remoteDatasource;
  NumberTriviaLocalDatasource? localDatasource;
  NetworkInfo? networkInfo;

  setUp(() {
    remoteDatasource = MockRemoteDataSource();
    localDatasource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();

    repository = NumberTriviaRepositoryImpl(
      remoteDatasource: remoteDatasource!,
      localDatasource: localDatasource!,
      networkInfo: networkInfo!,
    );
  });

  const tNumber = 1;
  const tNumberTriviaModel = NumberTriviaModel(text: 'test text', number: 1);
  const NumberTrivia tNumberTrivia = tNumberTriviaModel;

  runOnlineTests(Function body) {
    group('device is online', () {
      setUp(() =>
          when(() => networkInfo!.isConnected).thenAnswer((_) async => true));

      body();
    });
  }

  runOfflineTests(Function body) {
    group('device is offline', () {
      setUp(() =>
          when(() => networkInfo!.isConnected).thenAnswer((_) async => false));

      body();
    });
  }

  group('getConcreteNumberTrivia', () {
    test('should check is network online', () async {
      when(() => networkInfo!.isConnected).thenAnswer((_) async => true);
      when(() => remoteDatasource!.getConcreteNumberTrivia(any()))
          .thenAnswer((invocation) async => tNumberTriviaModel);
      when(() => localDatasource?.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async => {});

      repository?.getConcreteNumberTrivia(tNumber);

      verify(() => networkInfo!.isConnected);
    });

    runOnlineTests(() {
      test('should return data from remote datasource when success', () async {
        when(() => remoteDatasource!.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => localDatasource?.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => {});

        final result = await repository!.getConcreteNumberTrivia(tNumber);

        verify(() => remoteDatasource!.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should cache data from remote locally when success', () async {
        when(() => remoteDatasource!.getConcreteNumberTrivia(any()))
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => localDatasource?.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => {});

        await repository!.getConcreteNumberTrivia(tNumber);

        verify(() => remoteDatasource!.getConcreteNumberTrivia(tNumber));
        verify(() => localDatasource!.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote datasource is not success',
          () async {
        when(() => remoteDatasource!.getConcreteNumberTrivia(any()))
            .thenThrow(ServerException());
        when(() => localDatasource?.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => {});

        final result = await repository!.getConcreteNumberTrivia(tNumber);

        verify(() => remoteDatasource!.getConcreteNumberTrivia(tNumber));
        verifyNever(
            () => localDatasource!.cacheNumberTrivia(tNumberTriviaModel));
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runOfflineTests(() {
      test('should return data from cache', () async {
        when(() => localDatasource!.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository!.getConcreteNumberTrivia(tNumber);

        verify(() => localDatasource!.getLastNumberTrivia());
        verifyNever(() => remoteDatasource!.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return data from cache', () async {
        when(() => localDatasource!.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository!.getConcreteNumberTrivia(tNumber);

        verify(() => localDatasource!.getLastNumberTrivia());
        verifyNever(() => remoteDatasource!.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('getRandomNumberTrivia', () {
    test('should check is network online', () async {
      when(() => networkInfo!.isConnected).thenAnswer((_) async => true);
      when(() => remoteDatasource!.getRandomNumberTrivia())
          .thenAnswer((invocation) async => tNumberTriviaModel);
      when(() => localDatasource?.cacheNumberTrivia(tNumberTriviaModel))
          .thenAnswer((_) async => {});

      repository?.getRandomNumberTrivia();

      verify(() => networkInfo!.isConnected);
    });

    runOnlineTests(() {
      test('should return data from remote datasource when success', () async {
        when(() => remoteDatasource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => localDatasource?.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => {});

        final result = await repository!.getRandomNumberTrivia();

        verify(() => remoteDatasource!.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should cache data from remote locally when success', () async {
        when(() => remoteDatasource!.getRandomNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);
        when(() => localDatasource?.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => {});

        await repository!.getRandomNumberTrivia();

        verify(() => remoteDatasource!.getRandomNumberTrivia());
        verify(() => localDatasource!.cacheNumberTrivia(tNumberTriviaModel));
      });

      test(
          'should return server failure when the call to remote datasource is not success',
          () async {
        when(() => remoteDatasource!.getRandomNumberTrivia())
            .thenThrow(ServerException());
        when(() => localDatasource?.cacheNumberTrivia(tNumberTriviaModel))
            .thenAnswer((_) async => {});

        final result = await repository!.getRandomNumberTrivia();

        verify(() => remoteDatasource!.getRandomNumberTrivia());
        verifyNever(
            () => localDatasource!.cacheNumberTrivia(tNumberTriviaModel));
        expect(result, equals(Left(ServerFailure())));
      });
    });

    runOfflineTests(() {
      test('should return data from cache', () async {
        when(() => localDatasource!.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await repository!.getRandomNumberTrivia();

        verify(() => localDatasource!.getLastNumberTrivia());
        verifyNever(() => remoteDatasource!.getRandomNumberTrivia());
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test('should return CacheFailure if no cache exist', () async {
        when(() => localDatasource!.getLastNumberTrivia())
            .thenThrow(CacheException());

        final result = await repository!.getRandomNumberTrivia();

        verify(() => localDatasource!.getLastNumberTrivia());
        verifyNever(() => remoteDatasource!.getRandomNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}

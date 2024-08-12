import 'package:cleaner/core/error/failures.dart';
import 'package:cleaner/core/usecases/usecase.dart';
import 'package:cleaner/core/util/input_converter.dart';
import 'package:cleaner/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleaner/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:cleaner/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:cleaner/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreateNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

class FakeParams extends Fake implements Params {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  GetConcreteNumberTrivia? getConcrete;
  GetRandomNumberTrivia? getRandom;
  InputConverter? input;

  NumberTriviaBloc? bloc;

  setUpAll(() {
    registerFallbackValue(FakeParams());
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    getConcrete = MockGetConcreateNumberTrivia();
    getRandom = MockGetRandomNumberTrivia();
    input = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcrete: getConcrete!,
        getRandom: getRandom!,
        inputConverter: input!);
  });

  test('Initial state should be empty', () {
    expect(bloc!.state, equals(Empty()));
  });

  group('Concrete number', () {
    const numberInput = '1';
    const numberParsed = 1;
    const numberTrivia = NumberTrivia(text: 'test', number: 1);

    void setUpMockInputSuccess() {
      when(() => input!.stringToUnsignedInt(any())).thenReturn(const Right(1));
    }

    void setupMockGetConcreteSuccess() {
      when(() => getConcrete!(any()))
          .thenAnswer((_) async => const Right(numberTrivia));
    }

    void setupMockGetConcreteFails(Failure failure) {
      when(() => getConcrete!(any())).thenAnswer((_) async => Left(failure));
    }

    test('should convert input to interger', () async {
      setUpMockInputSuccess();
      when(() => getConcrete!(any()))
          .thenAnswer((_) async => const Right(numberTrivia));

      bloc!.add(GetConcreteNumberTriviaEvent(numberInput));

      await untilCalled(
        () => input!.stringToUnsignedInt(any()),
      );
      verify(
        () => input!.stringToUnsignedInt(numberInput),
      );
    });

    test('should emit error state when the input is invalid', () async {
      when(() => input!.stringToUnsignedInt(any()))
          .thenReturn(Left(InvalidInputFailure()));

      expectLater(bloc!.stream,
          emitsInOrder([const Error(message: INVALID_INPUT_MESSAGE)]));

      bloc!.add(GetConcreteNumberTriviaEvent(numberInput));
    });

    test('should get data from the concrete usecase', () async {
      setUpMockInputSuccess();
      setupMockGetConcreteSuccess();

      bloc!.add(GetConcreteNumberTriviaEvent(numberInput));

      await untilCalled(() => getConcrete!(any()));
      verify(() => getConcrete!(const Params(number: numberParsed))).captured;
    });

    test('should emit [ Loading, Loaded ] state when data gotten successfully',
        () {
      setUpMockInputSuccess();
      setupMockGetConcreteSuccess();

      expectLater(bloc!.stream,
          emitsInOrder([Loading(), const Loaded(numberTrivia: numberTrivia)]));

      bloc!.add(GetConcreteNumberTriviaEvent(numberInput));
    });

    test('should emit [ Loading, Error ] state when remote data gotten fails',
        () {
      setUpMockInputSuccess();
      setupMockGetConcreteFails(ServerFailure());

      expectLater(bloc!.stream,
          emitsInOrder([Loading(), const Error(message: SERVER_ERROR)]));

      bloc!.add(GetConcreteNumberTriviaEvent(numberInput));
    });

    test(
        'should emit [ Loading, Error ] state with proper message when local data gotten fails',
        () {
      setUpMockInputSuccess();
      setupMockGetConcreteFails(CacheFailure());

      expectLater(bloc!.stream,
          emitsInOrder([Loading(), const Error(message: CACHE_ERROR)]));

      bloc!.add(GetConcreteNumberTriviaEvent(numberInput));
    });
  });

  group('Random number', () {
    const numberTrivia = NumberTrivia(text: 'test', number: 1);

    void setupMockGetRandomSuccess() {
      when(() => getRandom!(any()))
          .thenAnswer((_) async => const Right(numberTrivia));
    }

    void setupMockGetRandomFails(Failure failure) {
      when(() => getRandom!(any())).thenAnswer((_) async => Left(failure));
    }

    test('should get data from the concrete usecase', () async {
      setupMockGetRandomSuccess();

      bloc!.add(GetRandomNumberTriviaEvent());

      await untilCalled(() => getRandom!(any()));
      verify(
        () => getRandom!(NoParams()),
      );
    });

    test('should emit [ Loading, Loaded ] state when data gotten successfully',
        () {
      setupMockGetRandomSuccess();

      expectLater(bloc!.stream,
          emitsInOrder([Loading(), const Loaded(numberTrivia: numberTrivia)]));

      bloc!.add(GetRandomNumberTriviaEvent());
    });

    test('should emit [ Loading, Error ] state when remote data gotten fails',
        () {
      setupMockGetRandomFails(ServerFailure());

      expectLater(bloc!.stream,
          emitsInOrder([Loading(), const Error(message: SERVER_ERROR)]));

      bloc!.add(GetRandomNumberTriviaEvent());
    });

    test(
        'should emit [ Loading, Error ] state with proper message when local data gotten fails',
        () {
      setupMockGetRandomFails(CacheFailure());

      expectLater(bloc!.stream,
          emitsInOrder([Loading(), const Error(message: CACHE_ERROR)]));

      bloc!.add(GetRandomNumberTriviaEvent());
    });
  });
}

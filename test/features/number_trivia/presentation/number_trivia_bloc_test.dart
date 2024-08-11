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

void main() {
  GetConcreteNumberTrivia? concrete;
  GetRandomNumberTrivia? random;
  InputConverter? input;

  NumberTriviaBloc? bloc;

  setUp(() {
    concrete = MockGetConcreateNumberTrivia();
    random = MockGetRandomNumberTrivia();
    input = MockInputConverter();
    bloc = NumberTriviaBloc(
        concrete: concrete!, random: random!, inputConverter: input!);
  });

  test('Initial state should be empty', () {
    expect(bloc!.state, equals(Empty()));
  });

  group('Concrete number', () {
    final numberInput = '1';
    final numberParsed = 1;
    final numberTrivia = NumberTrivia(text: 'test', number: 1);

    test('should convert input to interger', () async {
      when(() => input!.stringToUnsignedInt(any())).thenReturn(const Right(1));

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
  });
}

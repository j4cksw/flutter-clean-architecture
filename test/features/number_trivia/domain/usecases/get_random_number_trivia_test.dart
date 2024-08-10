import 'package:cleaner/core/usecases/usecase.dart';
import 'package:cleaner/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:cleaner/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:cleaner/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late GetRandomNumberTrivia useCase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();

  });

  const tNumberTrivia = NumberTrivia(text: 'test', number: 1);

  test('should get trivia from the number repository', () async {
    when(()=>mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((_) async => const Right(tNumberTrivia));

    useCase = GetRandomNumberTrivia(mockNumberTriviaRepository);
    final result = await useCase(NoParams());

    expect(result, const Right(tNumberTrivia));
    verifyNever(()=>mockNumberTriviaRepository.getConcreteNumberTrivia(any()));
    verify(()=>mockNumberTriviaRepository.getRandomNumberTrivia());
  });
}

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}
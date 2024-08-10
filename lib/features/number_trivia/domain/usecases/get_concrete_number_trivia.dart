import 'package:cleaner/core/error/failures.dart';
import 'package:cleaner/core/usecases/usecase.dart';
import 'package:cleaner/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:cleaner/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {

  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params implements Equatable {
  final int number;

  const Params({ required this.number});


  @override
  List<Object?> get props => [number];

  @override
  bool? get stringify => true;
}

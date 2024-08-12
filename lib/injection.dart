import 'package:cleaner/core/network/network_info.dart';
import 'package:cleaner/core/util/input_converter.dart';
import 'package:cleaner/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:cleaner/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:cleaner/features/number_trivia/data/repositories/number_trivia_repository.dart';
import 'package:cleaner/features/number_trivia/domain/repositories/number_trivia_repository_impl.dart';
import 'package:cleaner/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:cleaner/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:cleaner/features/number_trivia/presentation/bloc/number_trivia/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => NumberTriviaBloc(
      getConcrete: sl(), getRandom: sl(), inputConverter: sl()));

  // usecases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // repositories
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDatasource: sl(), localDatasource: sl(), networkInfo: sl()));

  // data sources
  sl.registerLazySingleton<NumberTriviaRemoteDatasource>(
      () => NumberTriviaRemoteDatasourceImpl(httpClient: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDatasource>(
      () => LocalDatasourceImpl(sharedPreferences: sl()));

  // core
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // external
  final sharedPreferencces = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferencces);
  sl.registerLazySingleton(() => Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

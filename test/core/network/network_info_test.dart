import 'package:cleaner/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  NetworkInfoImpl? networkInfo;
  MockInternetConnectionChecker? mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfoImpl(mockInternetConnectionChecker!);
  });

  group('isConnected', () {
    test('should forward the call to the Internetconnection', () async {
      final tHasConnectionFuture = Future.value(true);
      when(() => mockInternetConnectionChecker!.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);

      final result = networkInfo!.isConnected;

      expect(result, tHasConnectionFuture);
      verify(() => mockInternetConnectionChecker!.hasConnection);
    });
  });
}

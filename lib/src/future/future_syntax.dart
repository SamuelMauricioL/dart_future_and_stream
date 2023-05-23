import 'package:future_and_stream/src/core/exeptions.dart';
import 'package:http/http.dart' as http;

Future<http.Request> _getCoffeList() async {
  // return Future.value(
  //   http.Request('GET', Uri.parse('https://api.sampleapis.com/coffee/hot')),
  // );
  // return http.get(Uri.parse('https://api.sampleapis.com/coffee/hot'));
  // throw HttpException('[Error] HttpException Exception');
  throw HttpException('[Error] HttpException Exception');
}

void getCoffeList() {
  final coffeeList = _getCoffeList();
  coffeeList.then((response) => print(response.body));
}

void getCoffeListWithCatchError() {
  final coffeeList = _getCoffeList();

  coffeeList
      .then((response) => print(response.body)) // Success
      .catchError((error) => print('Type: $error')); // Failure
}

void getCoffeListWithCustomExeptions() {
  final coffeeList = _getCoffeList();

  coffeeList
      .then((value) => print('')) // Success
      .catchError(
    (Object error, StackTrace stackTrace) {
      final err = error as CustomException;
      print(err.message);
    },
    test: (Object error) => error is CustomException,
  ).catchError(
    (Object error, StackTrace stackTrace) {
      final err = error as HttpException;
      print(err.message);
    },
    test: (Object error) => error is HttpException,
  );
}

void getCoffeListWithCompleted() {
  final coffeeList = _getCoffeList();

  coffeeList
      .then((value) => print('')) // Success
      .catchError(
    (Object error, StackTrace stackTrace) {
      final err = error as CustomException;
      print(err.message);
    },
    test: (Object error) => error is CustomException,
  ).catchError(
    (Object error, StackTrace stackTrace) {
      final err = error as HttpException;
      print(err.message);
    },
    test: (Object error) => error is HttpException,
  ).whenComplete(() => print('[Completed]: to do something'));
}

Future<void> getCoffeListWithAsyncAwait() async {
  try {
    final coffeeList = await _getCoffeList();
    print(coffeeList.body);
  } on CustomException catch (e) {
    print(e.message);
  } on HttpException catch (e) {
    print(e.message);
  } catch (e) {
    print(e);
  }
}

Future<void> getCoffeListWithAsyncAwaitAndFinally() async {
  try {
    final coffeeList = await _getCoffeList();
    print(coffeeList.body);
  } on CustomException catch (e) {
    print(e.message);
  } on HttpException catch (e) {
    print(e.message);
  } catch (e) {
    print(e);
  } finally {
    print('[Finally]: to do something');
  }
}

Future<void> getCoffeListWithAsyncAwaitAndFinallyAndStackTrace() async {
  try {
    final coffeeList = await _getCoffeList();
    print(coffeeList.body);
  } on CustomException catch (e, s) {
    print(e.message);
    print(s);
  } on HttpException catch (e, s) {
    print(e.message);
    print(s);
  } catch (e, s) {
    print(e);
    print(s);
  } finally {
    print('[Finally]: to do something');
  }
}

Future<void>
    getCoffeListWithAsyncAwaitAndFinallyAndStackTraceAndRethrow() async {
  try {
    final coffeeList = await _getCoffeList();
    print(coffeeList.body);
  } on CustomException catch (e, s) {
    print(e.message);
    print(s);
    rethrow;
  } on HttpException catch (e, s) {
    print(e.message);
    print(s);
    rethrow;
  } catch (e, s) {
    print(e);
    print(s);
    rethrow;
  } finally {
    print('[Finally]: to do something');
  }
}

Future<void> callMultipleFutures() {
  return Future.wait([
    getCoffeListWithAsyncAwait(),
    getCoffeListWithAsyncAwait(),
    getCoffeListWithAsyncAwait(),
  ]);
}

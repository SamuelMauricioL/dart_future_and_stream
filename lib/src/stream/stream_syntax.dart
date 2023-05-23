import 'dart:async';

Stream<int> createNumberStreamWithException(int last) async* {
  for (int i = 1; i <= last; i++) {
    await Future.delayed(Duration(milliseconds: 700));
    if (i == 5) {
      throw Exception("Demo exception when accessing 5th number");
    }
    yield i; //to be able to send spaced out events
  }
}

Stream<int> createNumberStream(int last) async* {
  for (int i = 1; i <= last; i++) {
    await Future.delayed(Duration(milliseconds: 700));
    yield i; //to be able to send spaced out events
  }
}

// using listen
void subscribeUsingListen() {
  final stream = createNumberStreamWithException(5);

  stream.listen(
    (x) async {
      print("number $x");
      if (x == 3) {
        await Future.delayed(Duration(seconds: 1));
      }
    },
    onError: (err) async => print("error: $err"),
    // cancelOnError: true,
    onDone: () async => print("Done"),
  );
}

// Using Subscription's Handler
void subscribeUsingSubscriptionHandler() {
  Stream stream = createNumberStreamWithException(5);

  final subscription = stream.listen(null);
  subscription.onData((x) => print("number $x"));
  subscription.onError((err) => print("error: $err"));
  subscription.onDone(() => print("Done"));
}

// Using where() Method
void filterUsingWhere() {
  final stream = createNumberStream(5);
  stream
      .where((x) => x > 3) //Filters numbers greater than 3
      .where((x) => x % 2 == 0) //Filters even numbers
      .listen((x) => print(x)); //prints numbers filtered
}

// Using Stream's Properties: FIRST
void first() {
  final stream = createNumberStream(5);

  //print the first number/event
  stream.first.then(
    (x) => print("First event: $x"),
  );
}

// Using Stream's Properties: LAST
void last() {
  //A fresh stream is needed.
  //Single subscription stream can't be re-listened.
  final stream = createNumberStream(5);
  //print the last number/event
  stream.last.then((x) => print("Last event: $x"));
}

// Using Stream's Properties: LEGTH
void length() {
  final stream = createNumberStream(5);
  //print the length of the stream
  stream.length.then((x) => print("Length of Stream: $x"));
}

// Using Stream's Properties: isEmpty
void isEmpty() {
  Stream<int> stream = createNumberStream(5);
  //Check if stream is empty
  stream.isEmpty.then((x) => print("Is Empty : $x"));

  //Create an empty stream
  stream = createNumberStream(0);
  //Verify an empty stream
  stream.isEmpty.then((x) => print("Is Empty : $x"));
}

// Broadcast Streams Operations: asBroadcastStream
void broadcastStreamBasicOperations() {
  final stream = createNumberStream(5);

  //Converting to broadcastStream
  final bStream = stream.asBroadcastStream();

  //check if stream is broadcast stream or single
  if (bStream.isBroadcast) {
    print("Broadcast Stream");
  } else {
    print("Single Stream");
  }
  //print the first number/event
  bStream.first.then((x) => print("First event: $x"));

  //print the last number/event
  bStream.last.then((x) => print("Last event: $x"));

  //print the length of the stream
  bStream.length.then((x) => print("Length of Stream: $x"));

  //Check if stream is empty
  bStream.isEmpty.then((x) => print("Is Empty : $x"));

  //empty stream on purpose
  // stream = createNumberStream(2);
  // bStream = stream.asBroadcastStream();
  // bStream.isEmpty.then((x) => print("Is Empty : $x"));
  // bStream.length.then((x) => print("Length of Stream: $x"));
}

// Broadcast Streams Operations: take
void broadcastStreamTake() {
  final stream = createNumberStream(5);

  //Converting to broadcastStream
  final bStream = stream.asBroadcastStream();

  //Creates a sub stream of 2 elements and
  //listen on it
  bStream.take(2).listen(
        (x) => print("take() : $x"),
      );
}

// Broadcast Streams Operations: skip
void broadcastStreamSkip() {
  final stream = createNumberStream(5);

  //Converting to broadcastStream
  final bStream = stream.asBroadcastStream();

  //skips first two numbers from [1,2,3,4,5]
  bStream.skip(2).listen(
        (x) => print("skip() : $x"),
      );
}

// Broadcast Streams Operations: takeWhile
void broadcastStreamTakeWhile() {
  final stream = createNumberStream(5);

  //Converting to broadcastStream
  final bStream = stream.asBroadcastStream();

  //Creates a sub-stream of items less than 3, and prints the sub-stream of [1,2].
  bStream.takeWhile((x) => x > 0 && x < 3).listen(
        (x) => print("takeWhile() : $x"),
      );
}

// Broadcast Streams Operations: skipWhile
void broadcastStreamSkipWhile() {
  final stream = createNumberStream(5);

  //Converting to broadcastStream
  final bStream = stream.asBroadcastStream();

  //skips elements which are positive and
  //less than 3, and prints rest.
  bStream
      .skipWhile((x) => x > 0 && x < 3)
      .listen((x) => print("skipWhile() : $x"));
}

// Modifying Stream: transform() Method
void modifyStreamUsingTransform() {
  //Stream of integer events is created.
  final stream = createNumberStream(5);

  //StreamTransformer prints the transformed event
  final transformer =
      StreamTransformer<int, String>.fromHandlers(handleData: (value, sink) {
    sink.add("My number is $value");
  });

  stream.transform(transformer).listen(
        (x) => print(x),
        onError: (err) => print("error: $err"),
        onDone: () => print("Done"),
      );
}

// Stream: PAUSE, RESUME
void pauseResume() {
  Stream<int> numberStream = createNumberStream(5);

  final subscription = numberStream.listen(null);
  subscription.onData((number) {
    if (number > 2) {
      subscription.pause();
      print('Stream pausado');
      Future.delayed(Duration(seconds: 2), () {
        subscription.resume();
        print('Stream reanudado');
      });
    }
    print('Número emitido: $number');
  });
}

// Stream: PAUSE, CANCEL
void pauseCancel() {
  Stream<int> numberStream = createNumberStream(5);

  final subscription = numberStream.listen(null);
  subscription.onData((number) {
    if (number > 2) {
      subscription.cancel();
      print('Suscripción cancelada');
    }
    print('Número emitido: $number');
  });
}

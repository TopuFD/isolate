import 'dart:isolate';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Colors.blue,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  var result = await addnumber();
                  print(result);
                },
                child: Text("Async")),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () async {
                  final recevePort = ReceivePort();
                  await Isolate.spawn(addNumberIsolate, recevePort.sendPort);
                  recevePort.listen((value) {
                    print(value);
                  });
                },
                child: Text("isolate"))
          ],
        ),
      ),
    );
  }

  Future addnumber() async {
    var total = 0;
    for (var i = 0; i < 100000000; i++) {
      total = total + i;
    }
    return " The total is : $total";
  }
}

addNumberIsolate(SendPort sendPort) {
  var total = 0;
  for (var i = 0; i < 10000000000; i++) {
    total = total + i;
  }
  sendPort.send(total);
}
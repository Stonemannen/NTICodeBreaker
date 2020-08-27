import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

enum CounterEvent { init, increment }

class CounterState {
  const CounterState();
}

class Ready extends CounterState {
  final int code;

  const Ready(this.code);
}

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  int code = 0;

  @override
  get initialState => CounterState();

  @override
  Stream<CounterState> mapEventToState(CounterEvent event) async* {
    if (event == CounterEvent.init) {
      var response = await http.get('http://212.85.66.117:3050/start');

      if (response.statusCode == 200) {
        print(response.body);
        int newCode =
            int.parse(response.body.replaceAll(new RegExp(r'[^\w\s]+'), ''));
        code = newCode;

        yield Ready(code);
      }
    }

    if (event == CounterEvent.increment) {
      var response =
          await http.get('http://212.85.66.117:3050/increment?code=$code');
      if (response.statusCode == 200) {
        print(response.statusCode);
        code++;
        yield Ready(code);
      }
    }
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: BlocProvider<CounterBloc>(
        create: (context) => CounterBloc(),
        child: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CounterBloc counterBloc = BlocProvider.of<CounterBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Code breaker')),
      body: BlocBuilder<CounterBloc, CounterState>(
        builder: (context, state) {
          if (state is Ready) {
            return Center(
              child: Text(
                '${state.code}',
                style: TextStyle(fontSize: 24.0),
              ),
            );
          } else {
            counterBloc.add(CounterEvent.init);
            return Text("loading");
          }
        },
      ),
      floatingActionButton: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                counterBloc.add(CounterEvent.increment);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.album),
              onPressed: () async {
                const url = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

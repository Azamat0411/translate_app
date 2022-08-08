import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:translator/src/tokens/google_token_gen.dart';
import 'package:translator/translator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: "Lug'at"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _translator = GoogleTranslator();
  final _textController = TextEditingController();
  String a = '';
  String lang = 'Rus tili';
  String code = 'ru';

  List<String> language = [
    "Rus tili",
    "Ingliz tili",
    "Nemis tili",
    "Xitoy tili",
    "Turk tili",
    "Fransuz tili",
    "Italyan tili",
    "Yapon tili",
    "Ispan tili",
    "Tojik tili"
  ];

  List<String> codes = [
    "ru",
    "en",
    "de",
    "zh-tw",
    "tr",
    "fr",
    "it",
    "ja",
    "es",
    "tj"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Lug'at",
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: _textController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: '',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 0.5,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ElevatedButton(
                    onPressed: () async {
                      await _translator
                          .translate(_textController.text, from: 'uz', to: code)
                          .then((value) => setState(() {
                        a = value.text;
                      }));
                    },
                    child: const Text("Tarjima")),
                SizedBox(width: 10,),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: DropdownButton<String>(
                      underline: Container(
                        height: 0.0,
                        color: Colors.white,
                      ),
                      value: lang,
                      icon: const Icon(Icons.expand_more),
                      style: const TextStyle(color: Colors.white),
                      onChanged: (String? newValue) {
                        setState(() {
                          code = codes[language.indexOf(newValue!)];
                          lang = newValue;
                        });
                      },
                      items: language
                          .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                ),
              ],),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: .5),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(a),
                  ))
            ],
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

sssss() async {
  String from = 'uz', to = 'ru';
  var _baseUrl = 'translate.googleapis.com'; // faster than translate.google.com
  const _path = '/translate_a/single';
  final parameters = {
    'client': 't',
    'sl': from,
    'tl': to,
    'hl': to,
    'dt': 't',
    'ie': 'UTF-8',
    'oe': 'UTF-8',
    'otf': '1',
    'ssel': '0',
    'tsel': '0',
    'kc': '7',
    'tk': GoogleTokenGenerator().generateToken("olma"),
    'q': "olma"
  };

  var url = Uri.https(_baseUrl, _path, parameters);
  final data = await http.get(url);

  if (data.statusCode != 200) {
    throw http.ClientException('Error ${data.statusCode}: ${data.body}', url);
  }

  final jsonData = jsonDecode(data.body);
  if (jsonData == null) {
    throw http.ClientException('Error: Can\'t parse json data');
  }

  final sb = StringBuffer();

  print(jsonData[0].toString());

  for (var c = 0; c < jsonData[0].length; c++) {
    sb.write(jsonData[0][c][0]);
  }

  if (from == 'auto' && from != to) {
    from = jsonData[2] ?? from;
    if (from == to) {
      from = 'auto';
    }
  }

  final translated = sb.toString();
}

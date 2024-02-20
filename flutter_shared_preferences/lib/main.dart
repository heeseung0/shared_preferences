/*
  https://www.youtube.com/watch?v=aIirO4sId60
  의존 추가 터미널 명령어 : flutter pub add shared_perferences
*/

import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  List<int> ints = [0,1,2,3,4,5];
  List<String> words = ['a','b','c','d','e','f'];

  late int number = 0;
  late bool understand = false;
  late String word = 'blank';

  late Map<String, Object> data = {};

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      number = prefs.getInt('number') ?? 0; // null 일 경우 0
      understand = prefs.getBool('understand') ?? false;
      word = prefs.getString('word') ?? 'blank';

      var dataString = prefs.getString('data');
      data = dataString != null 
        ? Map<String, Object>.from(jsonDecode(dataString))
        : {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.lightBlueAccent),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Shared Preferences'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              customRow(number, () => updateNumber(), 'Number'),
              const SizedBox(height: 40),
              customRow(understand, () => updateUnderstand(), 'Understand'),
              const SizedBox(height: 40),
              customRow(word, () => updateWord(), 'Word'),
              const SizedBox(height: 40),
              customRow(data, () => updateData(), 'Data'),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('${data['number']}'),
                  Text('${data['understand']}'),
                  Text('${data['word']}'),
                ],
              ),
              const SizedBox(height: 200),
              ElevatedButton(
                onPressed: clearData,
                child: const Text('Clear Data'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row customRow(data, Function()? onPressed, String buttonText){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$data'),
        ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      ],
    );
  }

  void updateNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final rnd = Random().nextInt(ints.length);
      number = ints[rnd];
      prefs.setInt('number', number);
    });
  }

  void updateUnderstand() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      understand = !understand;
      prefs.setBool('understand', understand);
    });
  }

  void updateWord() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final rnd = Random().nextInt(words.length);
      word = words[rnd];
      prefs.setString('word', word);
    });
  }

  void updateData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final updatedData = {
      'number' : number,
      'understand' : understand,
      'word' : word,
    };

    if(!mapEquals(data, updatedData)){
      setState(() {
        data = updatedData;
      });
    }
    prefs.setString('data', jsonEncode(data));
  }

  void clearData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}

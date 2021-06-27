import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class Welcome5 {
  Welcome5({
    required this.parsedResults,
    required this.ocrExitCode,
    required this.isErroredOnProcessing,
    required this.processingTimeInMilliseconds,
    required this.searchablePdfurl,
  });

  List<ParsedResult> parsedResults;
  int ocrExitCode;
  bool isErroredOnProcessing;
  String processingTimeInMilliseconds;
  String searchablePdfurl;

  factory Welcome5.fromJson(Map<String, dynamic> json) {
    var prObj = json['ParsedResults'];
    return Welcome5(
      parsedResults: new List<ParsedResult>.from(prObj),
      ocrExitCode: json['OCRExitCode'],
      isErroredOnProcessing: json['IsErroredOnProcessing'],
      processingTimeInMilliseconds: json['ProcessingTimeInMilliseconds'],
      searchablePdfurl: json['SearchablePDFURL'],
    );
  }
}

class ParsedResult {
  ParsedResult({
    required this.textOverlay,
    required this.textOrientation,
    required this.fileParseExitCode,
    required this.parsedText,
    required this.errorMessage,
    required this.errorDetails,
  });

  TextOverlay textOverlay;
  String textOrientation;
  int fileParseExitCode;
  String parsedText;
  String errorMessage;
  String errorDetails;

  factory ParsedResult.fromJson(Map<String, dynamic> json) {
    return ParsedResult(
      textOverlay: json['TextOverlay'],
      textOrientation: json['TextOrientation'],
      fileParseExitCode: json['FileParseExitCode'],
      parsedText: json['ParsedText'],
      errorMessage: json['ErrorMessage'],
      errorDetails: json['ErrorDetails'],
    );
  }
}

class TextOverlay {
  TextOverlay({
    required this.lines,
    required this.hasOverlay,
    required this.message,
  });

  List<dynamic> lines;
  bool hasOverlay;
  String message;

  factory TextOverlay.fromJson(Map<String, dynamic> json) {
    var lObj = json['lines'];
    return TextOverlay(
      lines: new List<dynamic>.from(lObj),
      hasOverlay: json['HasOverlay'],
      message: json['Message'],
    );
  }
}

List data = [];
Map next = {};
List newk = [];
String summaryt = "";
String imgurl = "";
bool newsum = false;
Future<String> getText() async {
  var url = Uri.parse('https://api.ocr.space/parse/image');
  var response = await http.post(url, headers: {
    'apikey': 'helloworld'
  }, body: {
    'language': 'eng',
    'isOverlayRequired': 'false',
    'url': imgurl,
    'iscreatesearchablepdf': 'false',
    'issearchablepdfhidetextlayer': 'false'
  });

  var convertDataToJson = json.decode(response.body);
  String texts = convertDataToJson['ParsedResults'][0]['ParsedText'];
  print(texts);

  if (response.statusCode == 200) {
    return texts;
  } else {
    throw Exception('Failed to load text');
  }
}

// ignore: camel_case_types
class summary {
  String summaryText = "";

  summary({required this.summaryText});

  summary.fromJson(Map<String, dynamic> json) {
    summaryText = json['summary_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['summary_text'] = this.summaryText;
    return data;
  }
}

Future<void> getSumm() async {
  final textimg = await getText();

  var url =
      Uri.parse('https://api.nlpcloud.io/v1/bart-large-cnn/summarization');

  String msg = json.encode(<String, String>{
    "text": textimg,
  });
  http.Response response = await http.post(url,
      headers: {
        'Authorization': 'Token 488ad0ad72a92d81a57643b6ef7ea7ab95bb7e69',
        'Content-Type': 'application/json',
        "Access-Control-Allow-Origin": "*"
      },
      body: msg);
  var convertDataToJson = json.decode(response.body);
  summaryt = convertDataToJson['summary_text'];
  if (response.statusCode == 200) {
    print(summaryt);
  } else {
    print('Failed to load text');
  }
}

void main() {
  runApp(
    MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

const Color color = Color(0xff495867);
const Color buttoncolor = Color(0xff79B473);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final alucard = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(children: <Widget>[
          SizedBox(height: 80.0),
          CircleAvatar(
              radius: 72.0,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage('assets/crowd.png')),
        ]),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(children: <Widget>[
        SizedBox(
          height: 40.0,
        ),
        Text(
          'Welcome to HandSumm',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28.0, color: Colors.white),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Tap anywhere to get started',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22.0, color: Colors.white),
        ),
      ]),
    );

    final lorem = Padding(padding: EdgeInsets.all(8.0), child: SizedBox());

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: color,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Stack(children: <Widget>[
          Column(
            children: <Widget>[
              alucard,
              welcome,
              lorem,
            ],
          ),
        ]),
      ),
    );

    return Scaffold(
      body: GestureDetector(
          child: body,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => urlInput()),
            );
          }),
    );
  }
}

late Future<String> textstuff;
String initvalue = "";

// ignore: camel_case_types
class urlInput extends StatefulWidget {
  const urlInput({Key? key}) : super(key: key);

  @override
  _urlInputState createState() => _urlInputState();
}

// ignore: camel_case_types
class _urlInputState extends State<urlInput> {
  bool _scanning = true;

  @override
  /*void initState() {
    super.initState();
    textstuff = getText();
  }*/
  Widget build(BuildContext context) {
    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(28.0),
      decoration: BoxDecoration(
        color: color,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Stack(children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Enter the URL of the image you want to summarize',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28.0, color: Colors.white),
              ),
              SizedBox(height: 20.0),
              SizedBox(
                width: 500.0,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    labelText: 'Enter URL',
                    labelStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.add_link,
                      color: Colors.white,
                    ),
                  ),
                  onChanged: (text) {
                    imgurl = text;
                  
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      child: Text('Summarize'),
                      style: ElevatedButton.styleFrom(primary: buttoncolor),
                      onPressed: () {
                        getSumm();
                      }),
                      SizedBox(
                        width: 20.0,
                      ),
                  ElevatedButton(
                      child: Text('Copy Summary'),
                      style: ElevatedButton.styleFrom(primary: buttoncolor),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: summaryt));
                      }),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
    return Scaffold(body: body);
  }
}

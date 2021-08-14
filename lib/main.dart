import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xff4e5850),

      ),
      home: MyHomePage(title: 'Places Search by jan0r'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _addressController = TextEditingController();

  //TextField Spacing
  double cardHeight = 0.0;

  //Home Address
  GooglePlace googlePlace;
  List<AutocompletePrediction> predictions = [];

  void autoCompleteSearch(String value) async {
    var result = await googlePlace.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions;
      });
    }
  }

  var _url = 'https://github.com/jan0r/';
  void _launchURL() async => await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';

  @override
  void initState() {
    String apiKey = 'AIzaSyBTYW4s3JRHEMFNEZE1FAGZ7UgIeba69qE';
    googlePlace = GooglePlace(apiKey);

    super.initState();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //Address input field
              Container(
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: Color(0xff4e5850),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          autoCompleteSearch(value);
                          cardHeight = 500.0;
                        } else {
                          if (predictions.length > 0 && mounted) {
                            setState(() {
                              predictions = [];
                            });
                          }
                        }
                      },
                      controller: _addressController,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      decoration: InputDecoration(
                        labelText: "Adresse",
                        prefixIcon: Icon(
                          Icons.location_on_outlined,
                          color: Color(0xff4e5850),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: cardHeight,
                      child: ListView.builder(
                        itemCount: predictions.length,
                        itemBuilder: (context, index) {
                          return Card(
                              child: ListTile(
                            dense: true,
                            leading: Icon(Icons.pin_drop),
                            title: Text(predictions[index].description),
                            onTap: () {
                              setState(() {
                                _addressController.text = predictions[index].description;
                                print(predictions[index].description);
                                cardHeight = 0.0;
                              });
                            },
                          ));
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _launchURL,
        label: const Text('Star me on GitHub'),
        icon: const Icon(Icons.star),
        backgroundColor: Color(0xff4e5850),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

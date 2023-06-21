import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ThingSpeak Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/gasPage': (context) => const GasPage(),
        '/settingsPage': (context) => const SettingsPage(),
        '/carbonMonoxidePage': (context) => const CarbonMonoxidePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to the ThingSpeak Demo App',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/gasPage');
              },
              child: const Text('Go to  CO Gas Page'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settingsPage');
              },
              child: const Text('Go to ThingSpeak'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/carbonMonoxidePage');
              },
              child: const Text('Go to Carbon Monoxide Concentrations'),
            ),
          ],
        ),
      ),
    );
  }
}

class GasPage extends StatefulWidget {
  const GasPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GasPageState createState() => _GasPageState();
}

class _GasPageState extends State<GasPage> {
  final String apiKey = "JNG4L3C9Y984B7JH";
  final int fieldNumber = 1;
  final String serverURL =
      "https://api.thingspeak.com/channels/2189706/feeds.json?api_key=JNG4L3C9Y984B7JH&results=1";

  String responseText = '';

  @override
  void initState() {
    super.initState();
    fetchDataFromThingSpeak().then((value) {
      setState(() {
        responseText = value;
      });
    });
  }

  Future<String> fetchDataFromThingSpeak() async {
    // Make the HTTP GET request
    final response = await http.get(Uri.parse(serverURL));

    if (response.statusCode == 200) {
      // Parse the JSON response
      final jsonData = json.decode(response.body);
      final feeds = jsonData['feeds'];

      // Extract the value of the specified field from the first feed
      if (feeds.isNotEmpty) {
        final feed = feeds[0];
        final value = feed['field$fieldNumber'];

        return value.toString();
      }
    }

    // Return an empty string if the request failed or the response is invalid
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Latest CO Gas% update Page',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Text(responseText),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final String thingSpeakURL = 'https://thingspeak.com/channels/2189706';

  const SettingsPage({super.key});

  void _launchThingSpeakURL() async {
    // ignore: deprecated_member_use
    if (await canLaunch(thingSpeakURL)) {
      // ignore: deprecated_member_use
      await launch(thingSpeakURL);
    } else {
      throw 'Could not launch $thingSpeakURL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Settings Page',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _launchThingSpeakURL,
              child: const Text('Go to ThingSpeak'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

class CarbonMonoxidePage extends StatelessWidget {
  final String carbonMonoxideURL =
      'https://www.abe.iastate.edu/extension-and-outreach/carbon-monoxide-concentrations-table-aen-172/';

  const CarbonMonoxidePage({super.key});

  void _launchCarbonMonoxideURL() async {
    // ignore: deprecated_member_use
    if (await canLaunch(carbonMonoxideURL)) {
      // ignore: deprecated_member_use
      await launch(carbonMonoxideURL);
    } else {
      throw 'Could not launch $carbonMonoxideURL';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Monoxide Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Carbon Monoxide Concentrations',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _launchCarbonMonoxideURL,
              child: const Text('Go to Carbon Monoxide Concentrations Table'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

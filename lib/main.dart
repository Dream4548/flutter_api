import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lamborghini Showcase',
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Lamborghini Models'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<dynamic>> fetchData() async {
    // ใช้ข้อมูลจำลอง
    final response = await Future.delayed(Duration(seconds: 2), () {
      return jsonEncode([
        {
          "model": "Aventador",
          "description":
              "The Lamborghini Aventador is a mid-engine sports car produced by the Italian automotive manufacturer Lamborghini.",
          "url":
              "https://www.thairath.co.th/lifestyle/auto/news/1234567" // URL ตัวอย่าง
        },
        {
          "model": "Huracan",
          "description":
              "The Lamborghini Huracán is a sports car built by Italian automotive manufacturer Lamborghini.",
          "url": "https://www.sanook.com/auto/7890123" // URL ตัวอย่าง
        },
        {
          "model": "Urus",
          "description":
              "The Lamborghini Urus is a high performance luxury SUV manufactured by Italian automotive manufacturer Lamborghini.",
          "url": "https://www.khaosod.co.th/auto/news_3456789" // URL ตัวอย่าง
        }
      ]);
    });

    if (response.isNotEmpty) {
      return json.decode(response);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _navigateToDetailPage(BuildContext context, Map<String, dynamic> car) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CarDetailPage(car: car),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                  child: InkWell(
                    onTap: () =>
                        _navigateToDetailPage(context, snapshot.data![index]),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data![index]['model'],
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            snapshot.data![index]['description'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class CarDetailPage extends StatelessWidget {
  final Map<String, dynamic> car;

  CarDetailPage({required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(car['model']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              car['model'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
            ),
            SizedBox(height: 10),
            Text(
              car['description'],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'More Information:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

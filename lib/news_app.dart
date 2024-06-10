import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country-Based News App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: NewsHomePage(),
    );
  }
}

class NewsHomePage extends StatefulWidget {
  @override
  _NewsHomePageState createState() => _NewsHomePageState();
}

class _NewsHomePageState extends State<NewsHomePage> {
  String country = 'us';
  String category = 'food';
  String keyword = '';
  List articles = [];

  final Map<String, String> countryCodes = {
    'Bangladesh': 'bd',
    'Germany': 'de',
    'India': 'in',
    'United States of America': 'us'
  };

  final List<String> categories = [
    'education',
    'food',
    'health',
    'politics',
    'science',
    'technology',
    'world'
  ];

  Future<void> fetchNews() async {
    final apiKey = 'pub_45808d5ecdf6b2b576008c91ed2d00016de03';
    final apiUrl =
        'https://newsdata.io/api/1/latest?country=$country&category=$category&apikey=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data =
          json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        articles = data['results'];
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Country-Based News App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: country,
                            decoration: InputDecoration(
                              labelText: 'Country',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            items: countryCodes.entries.map((entry) {
                              return DropdownMenuItem<String>(
                                value: entry.value,
                                child: Text(entry.key),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                country = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: category,
                            decoration: InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            items: categories.map((category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                category = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      onChanged: (value) {
                        keyword = value;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        labelText: 'Enter keywords',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: fetchNews,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 12.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text('Search Country News By Asad 20'),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: articles.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        if (keyword.isNotEmpty &&
                            !(article['title'] ?? '')
                                .toString()
                                .toLowerCase()
                                .contains(keyword.toLowerCase()) &&
                            !(article['description'] ?? '')
                                .toString()
                                .toLowerCase()
                                .contains(keyword.toLowerCase())) {
                          return Container(); // Skip items that don't match the keyword
                        }
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 4.0,
                          child: ListTile(
                            title: Text(
                              article['title'] ?? 'No Title',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              article['description'] ?? 'No Description',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

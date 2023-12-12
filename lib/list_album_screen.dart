import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_http_request/album_model.dart';

class ListAplbumScreen extends StatefulWidget {
  const ListAplbumScreen({super.key});

  @override
  State<ListAplbumScreen> createState() => _ListAplbumScreenState();
}

class _ListAplbumScreenState extends State<ListAplbumScreen> {
  late Future<Album> _futureAlbum;
  Future<Album> fetchAlbum() async {
    final response = await http
        .get(Uri.parse("https://jsonplaceholder.typicode.com/albums/1"));
    if (response.statusCode == 200) {
      return Album.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Album');
    }
  }

  @override
  void initState() {
    _futureAlbum = fetchAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Album>(
          future: _futureAlbum,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              return Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(snapshot.data!.title),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

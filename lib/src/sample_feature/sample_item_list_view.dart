import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

import 'package:http/http.dart' as http;

// Model
class Track {
  final String wrapperType;
  final String kind;
  final int artistId;
  final int collectionId;
  final int trackId;
  final String artistName;
  final String collectionName;
  final String trackName;
  final String collectionCensoredName;
  final String trackCensoredName;
  final String artistViewUrl;
  final String collectionViewUrl;
  final String trackViewUrl;
  final String previewUrl;
  final String artworkUrl30;
  final String artworkUrl60;
  final String artworkUrl100;
  final double collectionPrice;
  final double trackPrice;
  final DateTime releaseDate;
  final String collectionExplicitness;
  final String trackExplicitness;
  final int discCount;
  final int discNumber;
  final int trackCount;
  final int trackNumber;
  final int trackTimeMillis;
  final String country;
  final String currency;
  final String primaryGenreName;
  final bool isStreamable;

  Track({
    required this.wrapperType,
    required this.kind,
    required this.artistId,
    required this.collectionId,
    required this.trackId,
    required this.artistName,
    required this.collectionName,
    required this.trackName,
    required this.collectionCensoredName,
    required this.trackCensoredName,
    required this.artistViewUrl,
    required this.collectionViewUrl,
    required this.trackViewUrl,
    required this.previewUrl,
    required this.artworkUrl30,
    required this.artworkUrl60,
    required this.artworkUrl100,
    required this.collectionPrice,
    required this.trackPrice,
    required this.releaseDate,
    required this.collectionExplicitness,
    required this.trackExplicitness,
    required this.discCount,
    required this.discNumber,
    required this.trackCount,
    required this.trackNumber,
    required this.trackTimeMillis,
    required this.country,
    required this.currency,
    required this.primaryGenreName,
    required this.isStreamable,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      wrapperType: json['wrapperType'],
      kind: json['kind'],
      artistId: json['artistId'],
      collectionId: json['collectionId'],
      trackId: json['trackId'],
      artistName: json['artistName'],
      collectionName: json['collectionName'],
      trackName: json['trackName'],
      collectionCensoredName: json['collectionCensoredName'],
      trackCensoredName: json['trackCensoredName'],
      artistViewUrl: json['artistViewUrl'],
      collectionViewUrl: json['collectionViewUrl'],
      trackViewUrl: json['trackViewUrl'],
      previewUrl: json['previewUrl'],
      artworkUrl30: json['artworkUrl30'],
      artworkUrl60: json['artworkUrl60'],
      artworkUrl100: json['artworkUrl100'],
      collectionPrice: json['collectionPrice'].toDouble(),
      trackPrice: json['trackPrice'].toDouble(),
      releaseDate: DateTime.parse(json['releaseDate']),
      collectionExplicitness: json['collectionExplicitness'],
      trackExplicitness: json['trackExplicitness'],
      discCount: json['discCount'],
      discNumber: json['discNumber'],
      trackCount: json['trackCount'],
      trackNumber: json['trackNumber'],
      trackTimeMillis: json['trackTimeMillis'],
      country: json['country'],
      currency: json['currency'],
      primaryGenreName: json['primaryGenreName'],
      isStreamable: json['isStreamable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wrapperType': wrapperType,
      'kind': kind,
      'artistId': artistId,
      'collectionId': collectionId,
      'trackId': trackId,
      'artistName': artistName,
      'collectionName': collectionName,
      'trackName': trackName,
      'collectionCensoredName': collectionCensoredName,
      'trackCensoredName': trackCensoredName,
      'artistViewUrl': artistViewUrl,
      'collectionViewUrl': collectionViewUrl,
      'trackViewUrl': trackViewUrl,
      'previewUrl': previewUrl,
      'artworkUrl30': artworkUrl30,
      'artworkUrl60': artworkUrl60,
      'artworkUrl100': artworkUrl100,
      'collectionPrice': collectionPrice,
      'trackPrice': trackPrice,
      'releaseDate': releaseDate.toIso8601String(),
      'collectionExplicitness': collectionExplicitness,
      'trackExplicitness': trackExplicitness,
      'discCount': discCount,
      'discNumber': discNumber,
      'trackCount': trackCount,
      'trackNumber': trackNumber,
      'trackTimeMillis': trackTimeMillis,
      'country': country,
      'currency': currency,
      'primaryGenreName': primaryGenreName,
      'isStreamable': isStreamable,
    };
  }
}

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  _SampleItemListViewState createState() => _SampleItemListViewState();
}

/// Displays a list of SampleItems.
class _SampleItemListViewState extends State<SampleItemListView> {
  List<Track> originalTrackList = []; // Store the original list
  List<Track> trackList = []; // This will be filtered
  // String sortBy = 'song'; // Default sorting by song name

  static const routeName = '/';

  @override
  void initState() {
    super.initState();
    fetchTracks(); // Load tracks when the widget initializes
  }

  Future<void> fetchTracks() async {
    try {
      final response = await http.get(Uri.parse(
          'https://itunes.apple.com/search?term=Taylor+Swift&limit=200&media=music'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> results = jsonResponse['results'];
        originalTrackList =
            results.map((json) => Track.fromJson(json)).toList();
        setState(() {
          trackList =
              results.map((trackJson) => Track.fromJson(trackJson)).toList();
          // sortTracks();
        });
        print('trackList ${trackList}');
      }
    } catch (error) {
      print(error);
    }
  }

  // void searchTracks(String query) {
  //   if (query.isEmpty) {
  //     trackList = List.from(originalTrackList); // Reset to original
  //   } else {
  //     trackList = originalTrackList.where((track) {
  //       final lowerCaseQuery = query.toLowerCase();
  //       return track.trackName.toLowerCase().contains(lowerCaseQuery) ||
  //           track.collectionName.toLowerCase().contains(lowerCaseQuery);
  //     }).toList();
  //   }
  //   setState(() {}); // Refresh the UI
  // }

  // void sortTracks() {
  //   if (sortBy == 'song') {
  //     trackList.sort((a, b) => a.trackName.compareTo(b.trackName));
  //   } else if (sortBy == 'album') {
  //     trackList.sort((a, b) => a.collectionName.compareTo(b.collectionName));
  //   }
  //   setState(() {}); // Refresh the UI after sorting
  // }

  // void handleSortChange(String? value) {
  //   setState(() {
  //     sortBy = value ?? 'song'; // Update sort option
  //     sortTracks(); // Sort the list based on new option
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    print('tracklist ${trackList}');
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sample Items'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.restorablePushNamed(context, SettingsView.routeName);
              },
            ),
          ],
        ),
        body: Text('sss')
        // Column(
        //   children: [
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Row(
        //           children: [
        //             Radio<String>(
        //               value: 'song',
        //               groupValue: sortBy,
        //               onChanged: handleSortChange,
        //             ),
        //             const Text('Sort by Song Name'),
        //           ],
        //         ),
        //         Row(
        //           children: [
        //             Radio<String>(
        //               value: 'album',
        //               groupValue: sortBy,
        //               onChanged: handleSortChange,
        //             ),
        //             const Text('Sort by Album Name'),
        //           ],
        //         ),
        //       ],
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: TextField(
        //         decoration: InputDecoration(
        //           labelText: 'Search Tracks',
        //           border: OutlineInputBorder(),
        //         ),
        //         onChanged: (value) {
        //           searchTracks(value); // Perform search on input change
        //         },
        //       ),
        //     ),
        //     Expanded(
        //       child: trackList.isEmpty
        //           ? Center(child: CircularProgressIndicator())
        //           : ListView.builder(
        //               itemCount: trackList.length,
        //               itemBuilder: (context, index) {
        //                 final track = trackList[index];
        //                 return ListTile(
        //                   leading: Image.network(track.artworkUrl30),
        //                   title: Text(track.trackName),
        //                   subtitle: Text(track.artistName),
        //                   onTap: () {
        //                     // Handle tap
        //                     print('Tapped on ${track.trackName}');
        //                   },
        //                 );
        //               },
        //             ),
        //     ),
        //   ],
        // ),
        );
  }
}

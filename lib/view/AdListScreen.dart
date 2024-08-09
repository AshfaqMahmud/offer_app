import 'dart:io';

import 'package:flutter/material.dart';
import 'package:offer_app/database/DBHelper.dart';
import '../model/AdModel.dart';


class AdListScreen extends StatefulWidget {
  @override
  _AdListScreenState createState() => _AdListScreenState();
}

class _AdListScreenState extends State<AdListScreen> {
  late Future<List<Ad>> _adList;

  @override
  void initState() {
    super.initState();
    _adList = _fetchAds();
  }

  Future<List<Ad>> _fetchAds() async {
    return await DBhelper().getAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Ads'),
      ),
      body: FutureBuilder<List<Ad>>(
        future: _adList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No ads found.'));
          }

          List<Ad> ads = snapshot.data!;
          return ListView.builder(
            itemCount: ads.length,
            itemBuilder: (context, index) {
              Ad ad = ads[index];
              return ListTile(
                leading: ad.adImage.isNotEmpty
                    ? Image.file(
                  File(ad.adImage),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                )
                    : Container(width: 50, height: 50, color: Colors.grey),
                title: Text(ad.adDescription),
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offer_app/database/DBHelper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../model/AdModel.dart';

Future<File?> compressImage(File file) async {
  final dir = await getTemporaryDirectory();
  final targetPath = join(dir.absolute.path, "${DateTime.now().millisecondsSinceEpoch}.jpg");

  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path,
    targetPath,
    quality: 60, // Adjust the quality as needed (0-100)
  );

  return result;
}


void createAd() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    File adImage = File(pickedFile.path);
    // Compress the image before saving
    File? compressedImage = await compressImage(adImage);
    if (compressedImage != null) {
      String adDescription = "Your ad description here";

      Ad newAd = Ad(
          adImage: compressedImage.path, adDescription: adDescription);
      await DBhelper().insertAd(newAd);
    }
  }
}

void readAds() async {
  List<Ad> ads = await DBhelper().getAds();
  ads.forEach((ad) {
    print("Ad ID: ${ad.id}, Image Path: ${ad.adImage}, Description: ${ad.adDescription}");
  });
}

void updateAd(int id) async {
  Ad updatedAd = Ad(id: id, adImage: "new_image_path.jpg", adDescription: "Updated description");
  await DBhelper().updateAd(updatedAd);
}

void deleteAd(int id) async {
  await DBhelper().deleteAd(id);
}

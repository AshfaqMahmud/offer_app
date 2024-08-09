class Ad {
  int? id;
  String adImage; //Path to image file
  String adDescription;

  Ad({this.id, required this.adImage, required this.adDescription});

  //Convert a Ad object into a Map object
  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'adImage' : adImage,
      'adDescription' : adDescription,
    };
  }

  //Convert a Map object into a Ad object

  factory Ad.fromMap(Map<String,dynamic> map) {
    return Ad(
      id : map['id'],
      adImage: map['adImage'],
      adDescription: map['adDescription'],
    );
  }
}


class UserModel {
  int? coastalRegion;
  int? easternRegion;
  int? lebanonRegion;
  int? northernRegion;
  int? southernRegion;
  int? number;
  int? month;
  int? year;


  UserModel({
    required this.coastalRegion,
    required this.easternRegion,
    required this.lebanonRegion,
    required this.northernRegion,
    required this.southernRegion,
    required this.number,
    required this.month,
    required this.year,

  });

  UserModel.fromMap(Map<String,dynamic> map){
    coastalRegion=map['coastalRegion'];
    easternRegion=map['easternRegion'];
    lebanonRegion=map['lebanonRegion'];
    northernRegion=map['northernRegion'];
    southernRegion=map['southernRegion'];
    number=map['number'];
    month=map['month'];
    year=map['year'];


  }

}


class UserModel {
  String? name;
  String? email;
  String? living;
  int? number;
  String? region;
  String? image;
  String? date;
  String? password;

  UserModel({
    required this.name,
    required this.email,
    required this.living,
    required this.number,
    required this.region,
    required this.image,
    required this.date,
    required this.password,

  });
  Map<String,dynamic> toMap(){

    return {
      'name':name,
      'email':email,
      'living':living,
      'number':number,
      'region':region,
      'image':image,
      'date':date,
      'password':password,


    };
  }
  UserModel.fromMap(Map<String,dynamic> map){
    email=map['email'];
    name=map['name'];
    living=map['living'];
    number=map['number'];
    region=map['region'];
    image=map['image'];
    date=map['date'];
    password=map['password'];


  }

}

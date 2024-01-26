

class Account {
  int? id;
  String? name;
  int? isCompleted;
  String? date;
  int? color;
  String? gender;
  String? email;
  String? areaofwork;
  String? empstatus;
  String? phone;

  Account({
    this.id,
    this.name,
    this.isCompleted,
    this.date,
    this.gender,
    this.email,
    this.areaofwork,
    this.empstatus,
    this.phone,

  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted,
      'date': date,
      'gender': gender,
      'email': email,
      'areaofwork':areaofwork,
      'empstatus':empstatus,
      'phone':phone,

    };
  }

  Account.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    gender =json['gender'];
    email = json['email'];
    areaofwork = json['areaofwork'];
    empstatus = json['empstatus'];
    phone = json['phone'];

  }
}
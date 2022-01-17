class Employee{
  late final int id;
  late final String name; 

  Employee({required this.id, required this.name});

  Employee.fromMap(Map<String, dynamic> json){
    id=json['id'];
    name=json['name'];
  }

  Map<String, dynamic> toMap(){
    return {'id': id, 'name':name};
  }
}
class Batch{
  String garden;
  String plantType;
  String phase;
  double count;
  DateTime date;
  String id;

  Map<String, dynamic> toMap() {
    Map<String,dynamic> data  ={
      'garden':garden,
      'plantType':plantType,
      'phase': phase,
      'count':count,
      'date':date,
      'id':id
    };
    return data;
  }
  void fromMap(Map<String,dynamic> data){
    this.date = data["date"];
    this.count = data["count"];
    this.phase = data["phase"];
    this.plantType = data["plantType"];
    this.garden = data["garden"];
    this.id = data["id"];
  }
}
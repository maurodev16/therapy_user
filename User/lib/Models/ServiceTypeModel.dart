class ServiceTypeModel {
  String? name;
  String? notes;
  ServiceTypeModel({this.name, this.notes});
  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeModel(
      name: json['name'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'notes': notes,
    };
  }
}

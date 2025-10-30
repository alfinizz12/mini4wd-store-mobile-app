class Store {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Store({required this.id, required this.name, required this.address, required this.latitude, required this.longitude});

  factory Store.fromJson(Map<String, dynamic> json){
    return Store(
      id: json['id'], 
      name: json['id'], 
      address: json['id'], 
      latitude: json['id'], 
      longitude: json['id']
    );
  }
}
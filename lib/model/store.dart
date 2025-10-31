class Store {
  final int id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  Store({required this.id, required this.name, required this.address, required this.latitude, required this.longitude});

  factory Store.fromJson(Map<String, dynamic> json){
    return Store(
      id: int.parse(json['id']), 
      name: json['name'], 
      address: json['address'], 
      latitude: json['latitude'], 
      longitude: json['longitude']
    );
  }
}
class Universe {
  final String id;
  final String name;
  final String description;
  final String image;

  const Universe({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
  });

  factory Universe.fromJson(Map<String, dynamic> json) {
    return Universe(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
    };
  }
}

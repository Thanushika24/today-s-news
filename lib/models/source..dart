class Source {
  final String? id;
  final String name;
  final String? description;
  final String? category;

  Source({this.id, required this.name, this.description,this.category});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name'],
      description:json['description'],
      category:json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
    };
  }
}

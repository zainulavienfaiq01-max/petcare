// Model representing a pet breed (dog or cat)
class Breed {
  final String id;
  final String name;
  final String type; // 'dog' or 'cat'
  final String origin;
  final String lifespan;
  final List<String> characteristics;
  final String habitat;
  final String description;
  final String imageUrl;
  final String temperament;
  final double size; // 1-5 scale: 1=tiny, 5=giant

  const Breed({
    required this.id,
    required this.name,
    required this.type,
    required this.origin,
    required this.lifespan,
    required this.characteristics,
    required this.habitat,
    required this.description,
    required this.imageUrl,
    required this.temperament,
    required this.size,
  });
}

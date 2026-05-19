import '../models/breed.dart';

/// Static data service for the Pet Library.
/// Contains curated dog and cat breed data.
class BreedDataService {
  // ─── DOG BREEDS ────────────────────────────────────────────────────────────
  static const List<Breed> dogBreeds = [
    Breed(
      id: 'dog_labrador',
      name: 'Labrador Retriever',
      type: 'dog',
      origin: 'Canada',
      lifespan: '10–12 years',
      characteristics: ['Friendly', 'Outgoing', 'Active', 'Easy to Train'],
      habitat: 'Family home, rural & suburban areas',
      description:
          'The Labrador Retriever is one of the most popular dog breeds in the world. Originally bred as a working retriever, Labs are known for their gentle nature, intelligence, and loyalty. They excel as guide dogs, search-and-rescue dogs, and family companions.',
      imageUrl:
          'https://images.unsplash.com/photo-1591946614720-90a587da4a36?auto=format&fit=crop&w=600&q=80',
      temperament: 'Gentle, Friendly, Intelligent',
      size: 3.5,
    ),
    Breed(
      id: 'dog_golden',
      name: 'Golden Retriever',
      type: 'dog',
      origin: 'Scotland, UK',
      lifespan: '10–12 years',
      characteristics: ['Loyal', 'Trustworthy', 'Kind', 'Confident'],
      habitat: 'Family home, suburban areas',
      description:
          'Golden Retrievers are highly intelligent dogs that are incredibly patient and devoted. Their kind eyes, lustrous golden coat, and enthusiastic character make them one of the most beloved family dogs in the world.',
      imageUrl:
          'https://images.unsplash.com/photo-1587300003388-59208cc962cb?auto=format&fit=crop&w=600&q=80',
      temperament: 'Reliable, Trustworthy, Kind',
      size: 3.5,
    ),
    Breed(
      id: 'dog_husky',
      name: 'Siberian Husky',
      type: 'dog',
      origin: 'Siberia, Russia',
      lifespan: '12–14 years',
      characteristics: ['Energetic', 'Athletic', 'Independent', 'Pack-minded'],
      habitat: 'Cold climates, wide open spaces',
      description:
          'Siberian Huskies were bred by the Chukchi people of Siberia as sled dogs. They are known for their striking blue or multi-colored eyes and thick, beautiful coats. Huskies are energetic and need lots of exercise.',
      imageUrl:
          'https://images.unsplash.com/photo-1617895153857-82fe0c43621b?auto=format&fit=crop&w=600&q=80',
      temperament: 'Outgoing, Mischievous, Loyal',
      size: 3,
    ),
    Breed(
      id: 'dog_poodle',
      name: 'Poodle',
      type: 'dog',
      origin: 'Germany / France',
      lifespan: '12–15 years',
      characteristics: ['Highly Intelligent', 'Active', 'Elegant', 'Hypoallergenic'],
      habitat: 'Family homes, apartments',
      description:
          'Poodles are among the most intelligent of all dog breeds. They are active, proud, and very smart. Poodles come in three sizes (standard, miniature, and toy) and their curly, hypoallergenic coat comes in many colors.',
      imageUrl:
          'https://images.unsplash.com/photo-1605897472359-85e4b94d685d?auto=format&fit=crop&w=600&q=80',
      temperament: 'Intelligent, Alert, Faithful',
      size: 2.5,
    ),
    Breed(
      id: 'dog_bulldog',
      name: 'French Bulldog',
      type: 'dog',
      origin: 'France',
      lifespan: '10–12 years',
      characteristics: ['Adaptable', 'Playful', 'Sociable', 'Low-energy'],
      habitat: 'Apartments, urban homes',
      description:
          'The French Bulldog is a small but muscular dog with a smooth coat, snub nose, and bat-like ears. Frenchies are patient, affectionate, and playful, making them excellent companions for city dwellers.',
      imageUrl:
          'https://images.unsplash.com/photo-1519098901909-b1553a1190af?auto=format&fit=crop&w=600&q=80',
      temperament: 'Adaptable, Playful, Affectionate',
      size: 1.5,
    ),
    Breed(
      id: 'dog_german_shepherd',
      name: 'German Shepherd',
      type: 'dog',
      origin: 'Germany',
      lifespan: '9–13 years',
      characteristics: ['Courageous', 'Confident', 'Intelligent', 'Protective'],
      habitat: 'Family homes, working environments',
      description:
          'German Shepherds are widely used as police, guard, and military dogs. Highly intelligent and versatile, they excel in almost any task they are trained to perform. They are extremely loyal and protective of their families.',
      imageUrl:
          'https://images.unsplash.com/photo-1589941013453-ec89f33b5e95?auto=format&fit=crop&w=600&q=80',
      temperament: 'Loyal, Courageous, Confident',
      size: 4,
    ),
    Breed(
      id: 'dog_beagle',
      name: 'Beagle',
      type: 'dog',
      origin: 'England, UK',
      lifespan: '12–15 years',
      characteristics: ['Curious', 'Merry', 'Friendly', 'Excellent Scent'],
      habitat: 'Suburban homes, rural areas',
      description:
          'Beagles are curious, clever, and energetic. Originally bred for hunting hares, they have an excellent sense of smell and tracking instinct. Their compact size, even temper, and lack of inherited health problems make them ideal pets.',
      imageUrl:
          'https://images.unsplash.com/photo-1505628346881-b72b27e84530?auto=format&fit=crop&w=600&q=80',
      temperament: 'Merry, Friendly, Curious',
      size: 2,
    ),
    Breed(
      id: 'dog_pomeranian',
      name: 'Pomeranian',
      type: 'dog',
      origin: 'Pomerania (Germany/Poland)',
      lifespan: '12–16 years',
      characteristics: ['Lively', 'Bold', 'Inquisitive', 'Fluffy Coat'],
      habitat: 'Apartments, urban & suburban homes',
      description:
          'The Pomeranian is a compact, active toy dog with a fluffy double coat. Despite their small size, Pomeranians are bold and curious dogs with a big personality. They are intelligent and respond well to training.',
      imageUrl:
          'https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?auto=format&fit=crop&w=600&q=80',
      temperament: 'Lively, Playful, Friendly',
      size: 1,
    ),
    Breed(
      id: 'dog_shiba_inu',
      name: 'Shiba Inu',
      type: 'dog',
      origin: 'Japan',
      lifespan: '13–16 years',
      characteristics: ['Bold', 'Alert', 'Independent', 'Agile'],
      habitat: 'Suburban and rural areas, mountain terrain',
      description:
          'The Shiba Inu is the smallest of Japan\'s six native breeds and is also the most popular companion dog in Japan. Originally bred for hunting in mountainous terrain, Shibas are alert, agile, and bold dogs with a good nature.',
      imageUrl:
          'https://images.unsplash.com/photo-1546456073-92b787fbe86a?auto=format&fit=crop&w=600&q=80',
      temperament: 'Bold, Fiery, Alert',
      size: 2,
    ),
    Breed(
      id: 'dog_dalmatian',
      name: 'Dalmatian',
      type: 'dog',
      origin: 'Croatia',
      lifespan: '11–13 years',
      characteristics: ['Energetic', 'Outgoing', 'Dignified', 'Spots Pattern'],
      habitat: 'Active homes with large yards',
      description:
          'The Dalmatian is a large dog, well-muscled, and with a distinctive spotted coat. The breed is highly energetic and playful and needs plenty of exercise. Dalmatians are intelligent and loyal dogs that love to be with their families.',
      imageUrl:
          'https://images.unsplash.com/photo-1601979031925-424e53b6caaa?auto=format&fit=crop&w=600&q=80',
      temperament: 'Playful, Energetic, Sensitive',
      size: 3.5,
    ),
  ];

  // ─── CAT BREEDS ────────────────────────────────────────────────────────────
  static const List<Breed> catBreeds = [
    Breed(
      id: 'cat_persian',
      name: 'Persian',
      type: 'cat',
      origin: 'Iran (Persia)',
      lifespan: '12–17 years',
      characteristics: ['Calm', 'Gentle', 'Luxurious Coat', 'Quiet'],
      habitat: 'Indoor, quiet family homes',
      description:
          'Persian cats are known for their long, luxurious coats and sweet, gentle personalities. They are calm, laid-back cats who enjoy lounging and being pampered. Persians require daily grooming to keep their coat free of tangles.',
      imageUrl:
          'https://images.unsplash.com/photo-1546422904-90eab23c3d7e?auto=format&fit=crop&w=600&q=80',
      temperament: 'Quiet, Gentle, Affectionate',
      size: 2.5,
    ),
    Breed(
      id: 'cat_siamese',
      name: 'Siamese',
      type: 'cat',
      origin: 'Thailand',
      lifespan: '12–15 years',
      characteristics: ['Talkative', 'Social', 'Intelligent', 'Demanding'],
      habitat: 'Indoor, family homes',
      description:
          'Siamese cats are one of the first distinctly recognized breeds. They are known for their striking blue eyes and distinctive colorpoint pattern. Siamese are very social, vocal, and enjoy interacting with their owners.',
      imageUrl:
          'https://images.unsplash.com/photo-1596854373066-cae11dda5c24?auto=format&fit=crop&w=600&q=80',
      temperament: 'Social, Vocal, Intelligent',
      size: 2,
    ),
    Breed(
      id: 'cat_maine_coon',
      name: 'Maine Coon',
      type: 'cat',
      origin: 'Maine, USA',
      lifespan: '12–15 years',
      characteristics: ['Dog-like', 'Playful', 'Large Breed', 'Tufted Ears'],
      habitat: 'Homes with space, indoor/outdoor',
      description:
          'Maine Coons are one of the largest domesticated cat breeds. They are known for their thick, water-resistant fur and bushy tails. Often called "the dog of the cat world", Maine Coons are playful, intelligent, and friendly.',
      imageUrl:
          'https://images.unsplash.com/photo-1548802673-380ab8ebc7b7?auto=format&fit=crop&w=600&q=80',
      temperament: 'Friendly, Playful, Intelligent',
      size: 4,
    ),
    Breed(
      id: 'cat_british_shorthair',
      name: 'British Shorthair',
      type: 'cat',
      origin: 'United Kingdom',
      lifespan: '12–20 years',
      characteristics: ['Round Face', 'Dense Coat', 'Easygoing', 'Loyal'],
      habitat: 'Indoor family homes, apartments',
      description:
          'The British Shorthair is a pedigreed version of the traditional British domestic cat. Known for their round faces, dense coats, and easygoing personalities, they are calm and devoted companions that adapt well to apartment life.',
      imageUrl:
          'https://images.unsplash.com/photo-1573865526739-10659fec78a5?auto=format&fit=crop&w=600&q=80',
      temperament: 'Calm, Easygoing, Loyal',
      size: 3,
    ),
    Breed(
      id: 'cat_ragdoll',
      name: 'Ragdoll',
      type: 'cat',
      origin: 'California, USA',
      lifespan: '12–17 years',
      characteristics: ['Floppy', 'Blue Eyes', 'Docile', 'Large & Affectionate'],
      habitat: 'Indoor, quiet family homes',
      description:
          'Ragdolls are large, docile cats with a silky coat and striking blue eyes. They are known for going limp when held — hence the name "Ragdoll". They are extremely gentle, calm, and devoted companions that get along well with children.',
      imageUrl:
          'https://images.unsplash.com/photo-1561948955-570b270e7c36?auto=format&fit=crop&w=600&q=80',
      temperament: 'Docile, Affectionate, Calm',
      size: 4,
    ),
    Breed(
      id: 'cat_bengal',
      name: 'Bengal',
      type: 'cat',
      origin: 'USA (Asian Leopard hybrid)',
      lifespan: '12–16 years',
      characteristics: ['Athletic', 'Leopard Pattern', 'Energetic', 'Water-loving'],
      habitat: 'Active homes, indoor/outdoor',
      description:
          'Bengal cats have a wild appearance with their distinctive spotted or marbled coat that resembles a miniature leopard. They are highly energetic, athletic, and playful — and unlike most cats, many Bengals love water.',
      imageUrl:
          'https://images.unsplash.com/photo-1589883661923-6476cb0ae9f2?auto=format&fit=crop&w=600&q=80',
      temperament: 'Alert, Energetic, Playful',
      size: 2.5,
    ),
    Breed(
      id: 'cat_scottish_fold',
      name: 'Scottish Fold',
      type: 'cat',
      origin: 'Scotland, UK',
      lifespan: '11–14 years',
      characteristics: ['Folded Ears', 'Adaptable', 'Quiet', 'Round Eyes'],
      habitat: 'Indoor family homes, apartments',
      description:
          'Scottish Folds are known for their distinctive folded ears, which give them an owl-like appearance. They are gentle, adaptable, and calm cats that get along well with children and other pets. They tend to be very quiet.',
      imageUrl:
          'https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?auto=format&fit=crop&w=600&q=80',
      temperament: 'Sweet, Calm, Adaptable',
      size: 2.5,
    ),
    Breed(
      id: 'cat_abyssinian',
      name: 'Abyssinian',
      type: 'cat',
      origin: 'Ethiopia (Abyssinia)',
      lifespan: '9–15 years',
      characteristics: ['Curious', 'Active', 'Intelligent', 'Slender Build'],
      habitat: 'Active homes, needs space to climb',
      description:
          'The Abyssinian is a slender, athletic cat with a distinctively ticked coat. They are one of the oldest known cat breeds and are extremely curious, active, and intelligent. Abyssinians love to climb and explore their environment.',
      imageUrl:
          'https://images.unsplash.com/photo-1526336024174-e58f5cdd8e13?auto=format&fit=crop&w=600&q=80',
      temperament: 'Curious, Active, Independent',
      size: 2,
    ),
    Breed(
      id: 'cat_sphynx',
      name: 'Sphynx',
      type: 'cat',
      origin: 'Canada',
      lifespan: '8–14 years',
      characteristics: ['Hairless', 'Warm Body', 'Extroverted', 'Acrobatic'],
      habitat: 'Indoor only (sensitive to cold & sun)',
      description:
          'The Sphynx is best known for its lack of fur. Despite their alien appearance, Sphynx cats are extremely affectionate, energetic, and love being the center of attention. They are very warm to the touch and often seek warmth from humans.',
      imageUrl:
          'https://images.unsplash.com/photo-1606214174585-fe31582dc6ee?auto=format&fit=crop&w=600&q=80',
      temperament: 'Extroverted, Affectionate, Demanding',
      size: 2,
    ),
    Breed(
      id: 'cat_norwegian',
      name: 'Norwegian Forest Cat',
      type: 'cat',
      origin: 'Norway',
      lifespan: '12–16 years',
      characteristics: ['Thick Double Coat', 'Hardy', 'Strong Climber', 'Independent'],
      habitat: 'Cold climates, homes with outdoor access',
      description:
          'The Norwegian Forest Cat is adapted to the cold Scandinavian climate with its thick, water-resistant double coat. They are strong, muscular cats that love to climb and explore. Despite their independent streak, they are devoted to their families.',
      imageUrl:
          'https://images.unsplash.com/photo-1533743983669-94fa5c4338ec?auto=format&fit=crop&w=600&q=80',
      temperament: 'Friendly, Gentle, Independent',
      size: 3.5,
    ),
  ];

  /// Returns all breeds for a given type ('dog' or 'cat').
  static List<Breed> getBreedsByType(String type) {
    return type == 'dog' ? dogBreeds : catBreeds;
  }

  /// Searches breeds by name, origin, or characteristics.
  static List<Breed> searchBreeds(String query, String type) {
    final q = query.toLowerCase();
    return getBreedsByType(type).where((b) {
      return b.name.toLowerCase().contains(q) ||
          b.origin.toLowerCase().contains(q) ||
          b.characteristics.any((c) => c.toLowerCase().contains(q)) ||
          b.temperament.toLowerCase().contains(q);
    }).toList();
  }
}

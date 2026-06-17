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
          'https://upload.wikimedia.org/wikipedia/commons/3/34/Labrador_on_Quantock_%282175262184%29.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/c/c0/Golden_Retriever_with_tennis_ball.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/a/a3/Black-Magic-Big-Boy.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/f/f8/Full_attention_%288067543690%29.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/1/18/French_Bulldog_22.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/d/d0/German_Shepherd_-_Aron.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/5/55/Beagle_600.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/c/c6/Pomeranian_Dog.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/5/58/Shiba_inu_taiki.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/1/15/Dalmatian_standing_looking.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/1/15/White_Persian_Cat.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/2/25/Siam_lilacpoint.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/5/5b/Maine_Coon_cat_by_Tomitheos.JPG',
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
          'https://upload.wikimedia.org/wikipedia/commons/9/9d/Britishblue.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/6/64/Ragdoll_Bicolor.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/b/ba/Paintedcats_Red_Star_standing.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/5/5d/Adult_Scottish_Fold.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/9/9b/Gustav_chocolate.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/e/e8/Sphinx2_simona.jpg',
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
          'https://upload.wikimedia.org/wikipedia/commons/0/0f/Norwegian_Forest_Cat_in_snow.jpg',
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

/// Comprehensive pet disease database for cats and dogs.
/// Each disease includes detailed medical information to help
/// pet owners identify and understand potential health issues.

class DiseaseInfo {
  final String name;
  final String description;
  final List<String> affectedAnimals; // 'dog', 'cat', or both
  final String causes;
  final List<String> symptoms;
  final List<String> physicalSigns;
  final List<String> behavioralChanges;
  final String severity; // 'Mild', 'Moderate', 'Severe', 'Critical'
  final List<String> prevention;
  final List<String> treatments;
  final String whenToVisitVet;
  final List<String> emergencyWarnings;
  final String emoji;

  const DiseaseInfo({
    required this.name,
    required this.description,
    required this.affectedAnimals,
    required this.causes,
    required this.symptoms,
    required this.physicalSigns,
    required this.behavioralChanges,
    required this.severity,
    required this.prevention,
    required this.treatments,
    required this.whenToVisitVet,
    required this.emergencyWarnings,
    required this.emoji,
  });
}

class DiseaseDataService {
  static const List<DiseaseInfo> diseases = [
    // 1. Rabies
    DiseaseInfo(
      name: 'Rabies',
      description: 'A fatal viral disease that affects the central nervous system. It is transmitted through the bite of an infected animal and is zoonotic (can spread to humans).',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Caused by the Rabies lyssavirus, transmitted through saliva via bites or scratches from infected animals such as bats, raccoons, skunks, or other dogs/cats.',
      symptoms: ['Fever', 'Excessive drooling', 'Difficulty swallowing', 'Seizures', 'Paralysis', 'Aggression or unusual tameness', 'Hydrophobia (fear of water)'],
      physicalSigns: ['Foaming at the mouth', 'Dropped jaw', 'Muscle paralysis starting from hind legs', 'Dilated pupils', 'Excessive salivation', 'Wound at bite site'],
      behavioralChanges: ['Sudden aggression in normally calm pets', 'Extreme restlessness', 'Disorientation and confusion', 'Unprovoked attacks', 'Self-mutilation', 'Withdrawal and hiding'],
      severity: 'Critical',
      prevention: ['Annual rabies vaccination', 'Avoid contact with wild animals', 'Keep pets supervised outdoors', 'Report stray animals to authorities', 'Maintain updated vaccination records'],
      treatments: ['No cure once symptoms appear', 'Post-exposure prophylaxis (PEP) if caught immediately', 'Quarantine of suspected animals', 'Supportive care only'],
      whenToVisitVet: 'Immediately if your pet is bitten by a wild or unknown animal, or shows any neurological symptoms. Rabies is a medical emergency.',
      emergencyWarnings: ['Any bite from a wild animal', 'Sudden personality change', 'Difficulty walking or standing', 'Excessive drooling with jaw paralysis', 'Seizures or convulsions'],
      emoji: '🦇',
    ),

    // 2. Distemper
    DiseaseInfo(
      name: 'Distemper',
      description: 'Canine distemper is a highly contagious viral disease affecting dogs. It attacks the respiratory, gastrointestinal, and nervous systems. Feline distemper (panleukopenia) is equally dangerous for cats.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Caused by the Canine Distemper Virus (CDV) in dogs and Feline Panleukopenia Virus (FPV) in cats. Spread through airborne exposure, direct contact with infected animals, or contaminated objects.',
      symptoms: ['High fever', 'Nasal and eye discharge', 'Coughing and sneezing', 'Vomiting and diarrhea', 'Loss of appetite', 'Lethargy', 'Seizures in advanced stages'],
      physicalSigns: ['Thick yellowish-green nasal discharge', 'Crusty eyes', 'Thickened foot pads (dogs)', 'Dehydration', 'Weight loss', 'Pneumonia signs'],
      behavioralChanges: ['Depression and withdrawal', 'Reduced playfulness', 'Head tilting', 'Circling behavior', 'Muscle twitching', 'Involuntary eye movements'],
      severity: 'Critical',
      prevention: ['DHPP vaccination for dogs', 'FVRCP vaccination for cats', 'Avoid contact with infected animals', 'Proper sanitation', 'Quarantine new pets before introduction'],
      treatments: ['No specific antiviral treatment available', 'Supportive care with IV fluids', 'Anti-nausea medications', 'Antibiotics for secondary infections', 'Anti-seizure medications if needed', 'Nutritional support'],
      whenToVisitVet: 'Immediately if you notice respiratory symptoms combined with fever, especially in unvaccinated puppies or kittens.',
      emergencyWarnings: ['Seizures or convulsions', 'Persistent high fever above 104°F', 'Bloody diarrhea', 'Complete refusal to eat or drink', 'Difficulty breathing'],
      emoji: '🤒',
    ),

    // 3. Parvovirus
    DiseaseInfo(
      name: 'Parvovirus',
      description: 'A highly contagious viral illness affecting mainly dogs, especially puppies. It attacks rapidly dividing cells in the intestinal lining, bone marrow, and lymph nodes.',
      affectedAnimals: ['dog'],
      causes: 'Caused by Canine Parvovirus Type 2 (CPV-2). Spread through direct contact with infected dogs or contaminated feces, environments, or objects. The virus can survive in the environment for months.',
      symptoms: ['Severe bloody diarrhea', 'Vomiting', 'Loss of appetite', 'Lethargy and weakness', 'Rapid weight loss', 'High fever followed by hypothermia', 'Abdominal pain'],
      physicalSigns: ['Foul-smelling bloody stool', 'Severe dehydration (sunken eyes, dry gums)', 'Rapid heartbeat', 'Abdominal tenderness', 'Pale gums', 'Hypothermia in severe cases'],
      behavioralChanges: ['Complete loss of energy', 'Refusal to eat or drink', 'Whimpering or crying from pain', 'Inability to stand', 'Seeking isolation'],
      severity: 'Critical',
      prevention: ['Complete puppy vaccination series (6-16 weeks)', 'Booster shots as recommended', 'Avoid dog parks until fully vaccinated', 'Disinfect contaminated areas with bleach', 'Proper socialization after vaccination'],
      treatments: ['Aggressive IV fluid therapy', 'Anti-nausea medications', 'Antibiotics for secondary infections', 'Plasma or blood transfusions in severe cases', 'Hospitalization typically 5-7 days', 'Nutritional support'],
      whenToVisitVet: 'Immediately if a puppy shows vomiting and bloody diarrhea. Early treatment dramatically improves survival rates.',
      emergencyWarnings: ['Bloody diarrhea in an unvaccinated puppy', 'Complete refusal to drink water', 'Collapse or inability to stand', 'Pale or white gums', 'Body temperature below 99°F'],
      emoji: '🦠',
    ),

    // 4. Kennel Cough
    DiseaseInfo(
      name: 'Kennel Cough',
      description: 'An upper respiratory infection causing a persistent, dry, honking cough. Also known as infectious tracheobronchitis, it is highly contagious among dogs.',
      affectedAnimals: ['dog'],
      causes: 'Caused by a combination of bacteria (Bordetella bronchiseptica) and viruses (Parainfluenza, Adenovirus). Spread through airborne droplets, direct contact, or shared water bowls in places with many dogs.',
      symptoms: ['Persistent dry hacking cough', 'Retching or gagging', 'Nasal discharge', 'Mild fever', 'Sneezing', 'Eye discharge', 'Reduced appetite'],
      physicalSigns: ['Honking cough sound', 'Watery to mucoid nasal discharge', 'Swollen tonsils', 'Mild lethargy', 'Slight fever'],
      behavioralChanges: ['Coughing fits after exercise or excitement', 'Less interest in play', 'Restlessness at night due to coughing', 'Normal appetite in mild cases'],
      severity: 'Mild',
      prevention: ['Bordetella vaccination', 'Avoid crowded dog facilities during outbreaks', 'Good ventilation in kennels', 'Regular cleaning of shared spaces', 'Isolate infected dogs'],
      treatments: ['Rest and isolation for 1-2 weeks', 'Cough suppressants if needed', 'Antibiotics for bacterial component', 'Humidifier to ease breathing', 'Honey (1 tsp) to soothe throat'],
      whenToVisitVet: 'Within 1-2 days of persistent cough. Immediately if the dog shows difficulty breathing, stops eating, or the cough worsens significantly.',
      emergencyWarnings: ['Labored breathing', 'Blue-tinged gums', 'Cough lasting more than 3 weeks', 'High fever above 104°F', 'Complete loss of appetite'],
      emoji: '😷',
    ),

    // 5. Heartworm
    DiseaseInfo(
      name: 'Heartworm Disease',
      description: 'A serious and potentially fatal condition caused by parasitic worms living in the heart, lungs, and blood vessels. It is spread through mosquito bites.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Caused by the parasitic worm Dirofilaria immitis. Transmitted through the bite of an infected mosquito. Larvae migrate through the bloodstream to the heart and lungs where they mature into adult worms.',
      symptoms: ['Persistent cough', 'Reluctance to exercise', 'Fatigue after moderate activity', 'Decreased appetite', 'Weight loss', 'Swollen belly from fluid accumulation'],
      physicalSigns: ['Heart murmur', 'Enlarged liver', 'Abnormal lung sounds', 'Distended abdomen (ascites)', 'Labored breathing', 'Pale gums'],
      behavioralChanges: ['Avoiding exercise', 'Tiring quickly during walks', 'Sleeping more than usual', 'Decreased playfulness', 'Coughing after activity'],
      severity: 'Severe',
      prevention: ['Monthly heartworm preventive medication year-round', 'Annual heartworm testing', 'Minimize mosquito exposure', 'Keep pets indoors during peak mosquito hours', 'Eliminate standing water around home'],
      treatments: ['Melarsomine injections for dogs (adulticidal therapy)', 'Strict exercise restriction during treatment', 'Doxycycline antibiotics', 'Monthly preventives to kill larvae', 'Surgery for severe cases', 'No approved treatment for cats - prevention only'],
      whenToVisitVet: 'Schedule regular annual testing. Visit immediately if your pet shows exercise intolerance, persistent cough, or abdominal swelling.',
      emergencyWarnings: ['Sudden collapse', 'Severe difficulty breathing', 'Coughing up blood', 'Very pale or blue gums', 'Sudden hindlimb weakness (caval syndrome)'],
      emoji: '🪱',
    ),

    // 6. Mange
    DiseaseInfo(
      name: 'Mange',
      description: 'A skin disease caused by parasitic mites that burrow into the skin. Two main types: Sarcoptic mange (highly contagious) and Demodectic mange (not contagious).',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Sarcoptic mange is caused by Sarcoptes scabiei mites (contagious). Demodectic mange is caused by Demodex mites that normally live on the skin but overgrow when the immune system is weakened.',
      symptoms: ['Intense itching and scratching', 'Hair loss in patches', 'Red, inflamed skin', 'Crusty or scabby skin', 'Skin thickening', 'Secondary skin infections'],
      physicalSigns: ['Patchy hair loss starting from ears, face, and legs', 'Reddened irritated skin', 'Crusty scabs and sores', 'Thickened wrinkled skin', 'Bacterial skin infections', 'Dandruff-like flaking'],
      behavioralChanges: ['Constant scratching and biting at skin', 'Restlessness and inability to sleep', 'Rubbing against furniture', 'Agitation and irritability', 'Decreased appetite from discomfort'],
      severity: 'Moderate',
      prevention: ['Regular flea and tick prevention products', 'Keep living areas clean', 'Avoid contact with infected animals', 'Maintain strong immune system through good nutrition', 'Regular veterinary check-ups'],
      treatments: ['Medicated baths and dips', 'Oral or topical antiparasitic medications (Ivermectin, Bravecto)', 'Antibiotics for secondary infections', 'Anti-itch medications', 'Immune support supplements', 'Environmental cleaning'],
      whenToVisitVet: 'Within a few days of noticing hair loss or intense scratching. Mange can spread quickly and cause secondary infections.',
      emergencyWarnings: ['Widespread hair loss covering most of body', 'Open sores with pus or bleeding', 'Fever accompanying skin lesions', 'Rapid weight loss', 'Signs of extreme distress'],
      emoji: '🔬',
    ),

    // 7. Ringworm
    DiseaseInfo(
      name: 'Ringworm',
      description: 'A fungal infection affecting the skin, hair, and nails. Despite its name, it is not caused by a worm but by dermatophyte fungi. It is zoonotic and can spread to humans.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Caused by dermatophyte fungi (Microsporum canis, Trichophyton mentagrophytes). Spread through direct contact with infected animals or contaminated objects like bedding, brushes, and furniture.',
      symptoms: ['Circular patches of hair loss', 'Scaly or crusty skin', 'Brittle or broken hairs', 'Mild itching', 'Darkened skin patches', 'Nail deformity'],
      physicalSigns: ['Ring-shaped lesions with raised edges', 'Circular bald patches', 'Gray scaly patches', 'Broken or stubby hairs at lesion edges', 'Reddened skin within patches', 'Crusting around ears and face'],
      behavioralChanges: ['Mild to moderate scratching', 'Over-grooming affected areas (cats)', 'Generally normal behavior', 'Slight irritability'],
      severity: 'Mild',
      prevention: ['Regular cleaning of pet bedding and brushes', 'Quarantine new pets for 2 weeks', 'Good hygiene when handling pets', 'Avoid sharing grooming tools', 'Maintain clean living environment'],
      treatments: ['Topical antifungal creams or ointments', 'Oral antifungal medication (Itraconazole, Griseofulvin)', 'Medicated antifungal shampoo', 'Environmental decontamination with bleach', 'Treatment duration: 6-8 weeks minimum', 'Follow-up fungal cultures to confirm cure'],
      whenToVisitVet: 'Within a week of noticing circular hair loss patches. Early treatment prevents spread to other pets and family members.',
      emergencyWarnings: ['Rapid spread to multiple body areas', 'Signs of secondary bacterial infection (pus, swelling)', 'Spread to human family members', 'Lesions near eyes'],
      emoji: '🍄',
    ),

    // 8. Flea Allergy Dermatitis
    DiseaseInfo(
      name: 'Flea Allergy Dermatitis',
      description: 'The most common skin disease in pets, caused by an allergic reaction to flea saliva. Even a single flea bite can trigger intense itching in sensitized animals.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Caused by hypersensitivity to proteins in flea saliva (Ctenocephalides felis). The allergic reaction is triggered when fleas bite and inject saliva into the skin during feeding.',
      symptoms: ['Intense itching especially at the base of tail', 'Hair loss on lower back and thighs', 'Red bumpy rash', 'Hot spots', 'Excessive licking and chewing', 'Skin infections'],
      physicalSigns: ['Hair loss concentrated on lower back, tail base, and inner thighs', 'Red papules and pustules', 'Thickened darkened skin from chronic scratching', 'Flea dirt (black specks) in fur', 'Hot spots (acute moist dermatitis)', 'Scabs and crusts'],
      behavioralChanges: ['Frantic scratching and biting', 'Restlessness', 'Rolling on the ground', 'Excessive grooming (cats)', 'Sleep disruption', 'Irritability when touched near affected areas'],
      severity: 'Moderate',
      prevention: ['Year-round flea prevention (topical or oral)', 'Regular environmental treatment', 'Vacuum carpets and furniture regularly', 'Wash pet bedding in hot water weekly', 'Treat all pets in the household simultaneously'],
      treatments: ['Immediate flea treatment for all pets', 'Environmental flea control (sprays, foggers)', 'Antihistamines or corticosteroids for itch relief', 'Antibiotics for secondary infections', 'Medicated baths', 'Apoquel or Cytopoint for severe cases'],
      whenToVisitVet: 'Within a few days if your pet is scratching intensely. Immediately if you notice hot spots or open sores.',
      emergencyWarnings: ['Large oozing hot spots', 'Fever with skin lesions', 'Severe anemia (pale gums) from heavy flea infestation', 'Signs of tapeworm (from ingesting fleas)', 'Hair loss over 50% of body'],
      emoji: '🪲',
    ),

    // 9. Ear Infection
    DiseaseInfo(
      name: 'Ear Infection (Otitis)',
      description: 'One of the most common conditions in pets, especially dogs with floppy ears. Can affect the outer ear (otitis externa), middle ear (otitis media), or inner ear (otitis interna).',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Caused by bacteria (Staphylococcus, Pseudomonas), yeast (Malassezia), or ear mites. Contributing factors include moisture in ears, allergies, foreign bodies, hormonal imbalances, and ear anatomy.',
      symptoms: ['Head shaking', 'Ear scratching', 'Redness in ear canal', 'Foul odor from ears', 'Discharge (brown, yellow, or bloody)', 'Pain when ears are touched', 'Hearing loss'],
      physicalSigns: ['Swollen red ear canal', 'Dark brown or yellowish discharge', 'Crusty buildup around ear', 'Warm ears to the touch', 'Head tilt (middle/inner ear)', 'Facial nerve paralysis in severe cases'],
      behavioralChanges: ['Frequent head shaking', 'Rubbing ears on furniture or floor', 'Whimpering when ears are touched', 'Loss of balance (inner ear)', 'Irritability', 'Reduced appetite'],
      severity: 'Moderate',
      prevention: ['Regular ear cleaning with vet-approved solution', 'Dry ears thoroughly after swimming or bathing', 'Regular grooming of ear hair', 'Treat underlying allergies', 'Regular veterinary ear examinations'],
      treatments: ['Ear cleaning with medicated solution', 'Topical antibiotic or antifungal ear drops', 'Oral antibiotics for severe infections', 'Anti-inflammatory medications', 'Ear mite treatment if applicable', 'Surgery for chronic cases (lateral ear resection)'],
      whenToVisitVet: 'Within 1-2 days of noticing symptoms. Ear infections can worsen quickly and lead to permanent hearing loss if untreated.',
      emergencyWarnings: ['Loss of balance or circling', 'Facial drooping', 'Bleeding from the ear', 'Severe swelling closing the ear canal', 'Sudden deafness', 'Extreme pain when mouth is opened'],
      emoji: '👂',
    ),

    // 10. Diabetes
    DiseaseInfo(
      name: 'Diabetes Mellitus',
      description: 'A chronic metabolic disease where the body cannot properly produce or respond to insulin, leading to high blood sugar levels. More common in middle-aged to older pets.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'In dogs, usually Type 1 (insulin deficiency from pancreatic damage). In cats, usually Type 2 (insulin resistance, often linked to obesity). Contributing factors include genetics, obesity, pancreatitis, and certain medications.',
      symptoms: ['Excessive thirst (polydipsia)', 'Frequent urination (polyuria)', 'Increased appetite with weight loss', 'Lethargy', 'Cloudy eyes in dogs (cataracts)', 'Weakness in hind legs (cats)'],
      physicalSigns: ['Weight loss despite eating well', 'Poor coat quality', 'Cataracts (dogs)', 'Plantigrade stance - walking on hocks (cats)', 'Sweet or fruity breath odor', 'Dehydration'],
      behavioralChanges: ['Increased water seeking', 'More frequent urination or house accidents', 'Decreased activity levels', 'Increased food begging', 'Weakness and fatigue'],
      severity: 'Severe',
      prevention: ['Maintain healthy weight', 'Regular exercise', 'Balanced diet appropriate for age', 'Regular veterinary check-ups with blood work', 'Avoid high-carb diets especially for cats'],
      treatments: ['Insulin injections (usually twice daily)', 'Dietary management (high-protein, low-carb for cats)', 'Regular blood glucose monitoring', 'Exercise management', 'Treatment of concurrent conditions', 'Possible remission in cats with early treatment'],
      whenToVisitVet: 'Within a few days if you notice increased thirst and urination. Immediately if your pet shows vomiting, weakness, or sweet-smelling breath.',
      emergencyWarnings: ['Vomiting and lethargy (diabetic ketoacidosis)', 'Sweet or acetone-smelling breath', 'Rapid breathing', 'Collapse or seizures (hypoglycemia)', 'Complete refusal to eat'],
      emoji: '💉',
    ),

    // 11. Kidney Disease
    DiseaseInfo(
      name: 'Chronic Kidney Disease',
      description: 'A progressive condition where the kidneys gradually lose their ability to filter waste from the blood. Very common in older cats and can affect dogs of any age.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Can be caused by aging, infections, toxins (lilies, antifreeze, NSAIDs), genetic predisposition, dental disease, high blood pressure, or previous acute kidney injury.',
      symptoms: ['Increased thirst and urination', 'Decreased appetite', 'Weight loss', 'Vomiting', 'Bad breath with chemical odor', 'Lethargy', 'Mouth ulcers'],
      physicalSigns: ['Weight loss and muscle wasting', 'Dehydration (tenting skin test)', 'Pale gums', 'Small irregular kidneys on palpation', 'Oral ulcers', 'Unkempt coat', 'High blood pressure'],
      behavioralChanges: ['Drinking from unusual sources', 'Seeking cool surfaces to lie on', 'Decreased grooming (cats)', 'Hiding more often', 'Less social interaction', 'Nausea-related lip licking'],
      severity: 'Severe',
      prevention: ['Regular blood work screening after age 7', 'Fresh water always available', 'Avoid toxic substances (lilies, antifreeze)', 'Regular dental care', 'Monitor and treat high blood pressure', 'Appropriate protein levels in diet'],
      treatments: ['Prescription kidney diet (reduced phosphorus and sodium)', 'Subcutaneous fluid therapy', 'Phosphate binders', 'Anti-nausea medications', 'Blood pressure medications', 'Potassium supplements', 'Erythropoietin for anemia'],
      whenToVisitVet: 'Schedule regular screening blood work for senior pets. Visit sooner if you notice increased thirst, weight loss, or vomiting.',
      emergencyWarnings: ['Complete cessation of urination', 'Severe vomiting and unable to keep water down', 'Seizures', 'Extreme weakness or collapse', 'Ammonia-like breath odor'],
      emoji: '🫘',
    ),

    // 12. Liver Disease
    DiseaseInfo(
      name: 'Liver Disease',
      description: 'Encompasses various conditions affecting liver function including hepatitis, liver shunts, fatty liver disease (hepatic lipidosis in cats), and liver tumors.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Can be caused by infections (leptospirosis), toxins (xylitol, certain medications), fatty liver from rapid weight loss (cats), copper storage disease, cancer, or congenital defects (liver shunts).',
      symptoms: ['Jaundice (yellowing of skin, gums, eyes)', 'Vomiting and diarrhea', 'Loss of appetite', 'Increased thirst', 'Swollen abdomen', 'Weight loss', 'Dark urine'],
      physicalSigns: ['Yellow discoloration of gums, ear flaps, and whites of eyes', 'Distended abdomen (ascites)', 'Enlarged liver on palpation', 'Orange-colored urine', 'Easy bruising or bleeding', 'Poor clotting'],
      behavioralChanges: ['Confusion or disorientation (hepatic encephalopathy)', 'Circling or head pressing', 'Excessive sleeping', 'Decreased social interaction', 'Aimless wandering', 'Personality changes'],
      severity: 'Severe',
      prevention: ['Avoid toxic foods (xylitol, grapes, macadamia nuts)', 'Keep medications and chemicals secured', 'Leptospirosis vaccination for dogs', 'Regular veterinary check-ups with liver panel', 'Maintain healthy weight', 'Never fast cats for more than 24 hours'],
      treatments: ['Treat underlying cause', 'Liver-supportive diet', 'SAMe and milk thistle supplements', 'IV fluid therapy', 'Antibiotics if infection is present', 'Vitamin K for clotting disorders', 'Surgery for shunts or tumors'],
      whenToVisitVet: 'Immediately if you notice jaundice (yellow skin or eyes), or if your cat stops eating for more than 24 hours.',
      emergencyWarnings: ['Obvious jaundice', 'Head pressing against walls', 'Seizures or sudden blindness', 'Unexplained bleeding', 'Rapid abdominal swelling', 'Complete anorexia in cats for >24 hours'],
      emoji: '🟡',
    ),

    // 13. Feline Leukemia (FeLV)
    DiseaseInfo(
      name: 'Feline Leukemia Virus (FeLV)',
      description: 'A retrovirus that weakens a cat\'s immune system, making them vulnerable to secondary infections and certain cancers. It is the most common cause of cancer in cats.',
      affectedAnimals: ['cat'],
      causes: 'Caused by the Feline Leukemia Virus, transmitted through close contact - mutual grooming, shared food/water bowls, bite wounds, and from mother to kittens during pregnancy or nursing.',
      symptoms: ['Progressive weight loss', 'Recurring infections', 'Pale gums (anemia)', 'Enlarged lymph nodes', 'Fever that comes and goes', 'Poor coat condition', 'Chronic diarrhea'],
      physicalSigns: ['Pale mucous membranes', 'Swollen lymph nodes', 'Stomatitis (inflamed mouth)', 'Skin lesions or tumors', 'Jaundice', 'Eye inflammation', 'Enlarged spleen'],
      behavioralChanges: ['Gradual decline in activity', 'Loss of appetite', 'Increased sleeping', 'Withdrawal from social activities', 'Seeking warm places', 'Decreased grooming'],
      severity: 'Critical',
      prevention: ['FeLV vaccination', 'Test all new cats before introduction', 'Keep cats indoors', 'Separate FeLV-positive cats from negative ones', 'Do not share food bowls between tested and untested cats'],
      treatments: ['No cure available', 'Supportive care and immune support', 'Treatment of secondary infections', 'Chemotherapy for FeLV-related cancers', 'Blood transfusions for severe anemia', 'Indoor-only lifestyle', 'Regular veterinary monitoring every 6 months'],
      whenToVisitVet: 'Test all new cats. Visit if your cat shows recurring illnesses, weight loss, or any symptoms listed above.',
      emergencyWarnings: ['Severe anemia (very pale gums)', 'Difficulty breathing', 'High persistent fever', 'Rapid tumor growth', 'Severe mouth inflammation preventing eating'],
      emoji: '🧬',
    ),

    // 14. Feline Immunodeficiency Virus (FIV)
    DiseaseInfo(
      name: 'Feline Immunodeficiency Virus (FIV)',
      description: 'Similar to HIV in humans, FIV attacks the immune system of cats. Infected cats may live for years before showing symptoms, but eventually develop immune deficiency.',
      affectedAnimals: ['cat'],
      causes: 'Caused by the Feline Immunodeficiency Virus, primarily spread through deep bite wounds. Most common in unneutered male outdoor cats. Not transmissible to humans or dogs.',
      symptoms: ['Recurring infections', 'Chronic mouth inflammation (stomatitis)', 'Weight loss', 'Poor appetite', 'Chronic diarrhea', 'Eye inflammation', 'Neurological issues'],
      physicalSigns: ['Enlarged lymph nodes', 'Chronic gingivitis and stomatitis', 'Skin infections and poor wound healing', 'Upper respiratory signs', 'Eye discharge', 'Fever'],
      behavioralChanges: ['Gradual decline in activity over months/years', 'Changes in litter box habits', 'Increased hiding', 'Decreased grooming', 'Personality changes'],
      severity: 'Severe',
      prevention: ['Keep cats indoors', 'Neuter male cats to reduce fighting', 'Test all new cats before introduction', 'Avoid contact with stray or feral cats'],
      treatments: ['No cure available', 'Keep indoors to prevent secondary infections', 'High-quality nutrition', 'Prompt treatment of any infections', 'Regular dental care', 'Regular veterinary monitoring', 'Anti-inflammatory treatment for stomatitis'],
      whenToVisitVet: 'Test all new cats. Visit promptly when FIV-positive cats show any signs of illness, as infections can progress rapidly.',
      emergencyWarnings: ['Severe mouth inflammation preventing eating', 'Rapid weight loss', 'High fever not responding to treatment', 'Neurological symptoms (seizures, disorientation)', 'Severe anemia'],
      emoji: '🛡️',
    ),

    // 15. Upper Respiratory Infection
    DiseaseInfo(
      name: 'Upper Respiratory Infection',
      description: 'Common infectious disease affecting the nose, throat, and sinuses, especially in cats. Often called "cat flu." Can be caused by multiple agents and is highly contagious.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Primarily caused by Feline Herpesvirus (FHV-1), Feline Calicivirus (FCV), Bordetella, or Chlamydophila. Spread through sneezing, sharing food bowls, and direct contact.',
      symptoms: ['Sneezing', 'Nasal discharge', 'Watery or goopy eyes', 'Coughing', 'Fever', 'Loss of appetite', 'Mouth ulcers (calicivirus)'],
      physicalSigns: ['Clear to thick nasal discharge', 'Conjunctivitis with eye discharge', 'Oral ulcers on tongue and palate', 'Drooling', 'Dehydration', 'Open-mouth breathing in severe cases'],
      behavioralChanges: ['Decreased appetite (can\'t smell food)', 'Lethargy', 'Hiding', 'Decreased grooming', 'Reduced vocalization or hoarse voice'],
      severity: 'Moderate',
      prevention: ['FVRCP vaccination for cats', 'Minimize stress and overcrowding', 'Good hygiene and ventilation', 'Quarantine new cats for 2 weeks', 'Regular cleaning of food and water bowls'],
      treatments: ['Supportive care with fluids and nutrition', 'Steam therapy to loosen congestion', 'Warming food to enhance smell', 'Eye drops or ointments', 'Antibiotics for secondary bacterial infections', 'L-lysine supplements (cats with herpesvirus)'],
      whenToVisitVet: 'Within 1-2 days if sneezing persists or discharge becomes thick/colored. Immediately if the pet stops eating or has difficulty breathing.',
      emergencyWarnings: ['Open-mouth breathing or gasping', 'Complete refusal to eat for 48+ hours', 'Thick green/yellow discharge', 'Corneal ulcers (squinting, cloudy eye)', 'Dehydration'],
      emoji: '🤧',
    ),

    // 16. Worm Infestation
    DiseaseInfo(
      name: 'Intestinal Worm Infestation',
      description: 'Parasitic infection by various types of intestinal worms including roundworms, hookworms, tapeworms, and whipworms. Very common, especially in puppies and kittens.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Different transmission routes: roundworms from contaminated soil or mother; hookworms through skin or ingestion; tapeworms from infected fleas; whipworms from contaminated environment. Puppies can be born with roundworms.',
      symptoms: ['Visible worms in stool or around anus', 'Diarrhea (sometimes bloody)', 'Vomiting', 'Weight loss', 'Pot-bellied appearance (puppies)', 'Scooting on rear', 'Dull coat'],
      physicalSigns: ['Distended abdomen in young animals', 'Poor body condition despite good appetite', 'Pale gums (anemia from hookworms)', 'Rice-like segments around anus (tapeworms)', 'Spaghetti-like worms in vomit (roundworms)'],
      behavioralChanges: ['Increased appetite without weight gain', 'Dragging rear on ground (scooting)', 'Restlessness', 'Licking or biting at rear end', 'Decreased energy'],
      severity: 'Moderate',
      prevention: ['Regular deworming schedule (every 3 months for adults)', 'Monthly heartworm preventives (many cover intestinal worms)', 'Flea control (prevents tapeworms)', 'Clean up feces promptly', 'Regular fecal exams at vet visits'],
      treatments: ['Appropriate dewormer medication based on worm type', 'Multiple treatments may be needed 2-3 weeks apart', 'Environmental cleaning to remove eggs', 'Flea treatment if tapeworms present', 'Nutritional support for malnourished animals'],
      whenToVisitVet: 'Schedule regular fecal exams. Visit sooner if you see worms in stool, the pet has diarrhea, or a puppy/kitten has a potbelly.',
      emergencyWarnings: ['Severe anemia (very pale gums)', 'Intestinal obstruction from heavy worm burden', 'Bloody diarrhea', 'Vomiting worms', 'Failure to thrive in puppies/kittens'],
      emoji: '🐛',
    ),

    // 17. Urinary Tract Infection
    DiseaseInfo(
      name: 'Urinary Tract Infection / FLUTD',
      description: 'Infections or inflammation of the urinary tract. In cats, often called FLUTD (Feline Lower Urinary Tract Disease). Can include infections, bladder stones, or urethral blockages.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Bacteria (E. coli most common), bladder stones (struvite or calcium oxalate), stress (cats), crystal formation, anatomical abnormalities, or idiopathic cystitis in cats.',
      symptoms: ['Frequent urination in small amounts', 'Straining to urinate', 'Blood in urine', 'Crying while urinating', 'Urinating outside litter box', 'Licking genital area excessively', 'Strong-smelling urine'],
      physicalSigns: ['Bloody or cloudy urine', 'Distended painful bladder', 'Straining with little to no urine output', 'Licking at urinary opening', 'Fever in some cases'],
      behavioralChanges: ['Frequent visits to litter box or going outside', 'Vocalizing during urination', 'Inappropriate urination', 'Restlessness', 'Decreased appetite', 'Hiding (cats)'],
      severity: 'Severe',
      prevention: ['Ensure adequate water intake', 'Feed appropriate diet (wet food helps)', 'Keep litter boxes clean (1 per cat + 1 extra)', 'Reduce stress in cats', 'Regular veterinary check-ups', 'Maintain healthy weight'],
      treatments: ['Antibiotics for bacterial infections', 'Pain management', 'Dietary changes to dissolve/prevent stones', 'Increased water intake', 'Anti-inflammatory medications', 'Catheterization for blockages (EMERGENCY)', 'Surgery for large stones'],
      whenToVisitVet: 'Within 24 hours if you notice urinary changes. IMMEDIATELY if a male cat is straining and cannot produce urine - this is a life-threatening emergency.',
      emergencyWarnings: ['Male cat straining with no urine production (urethral blockage)', 'Vomiting combined with inability to urinate', 'Collapse or severe lethargy', 'Crying in pain', 'Not urinating for 12+ hours'],
      emoji: '💧',
    ),

    // 18. Arthritis
    DiseaseInfo(
      name: 'Arthritis (Osteoarthritis)',
      description: 'A degenerative joint disease causing chronic pain and reduced mobility. It affects up to 80% of dogs over 8 years old and 90% of cats over 12 years old.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Caused by the wearing down of cartilage that cushions joints. Contributing factors include aging, obesity, previous joint injuries, hip/elbow dysplasia, and breed predisposition.',
      symptoms: ['Limping or favoring a leg', 'Stiffness especially after rest', 'Difficulty rising from lying down', 'Reluctance to jump or climb stairs', 'Decreased activity', 'Joint swelling', 'Muscle wasting'],
      physicalSigns: ['Limping that worsens after exercise', 'Swollen joints', 'Decreased range of motion', 'Muscle atrophy around affected joints', 'Crepitus (grinding sensation in joints)', 'Warm joints to the touch'],
      behavioralChanges: ['Reluctance to play or exercise', 'Difficulty with stairs or jumping on furniture', 'Litter box avoidance in cats (can\'t squat)', 'Increased sleeping', 'Irritability when touched on affected areas', 'Changes in grooming habits (cats)'],
      severity: 'Moderate',
      prevention: ['Maintain healthy weight', 'Regular moderate exercise', 'Joint supplements (glucosamine, chondroitin, omega-3)', 'Appropriate diet', 'Avoid repetitive high-impact activities', 'Orthopedic beds'],
      treatments: ['NSAIDs (carprofen, meloxicam)', 'Joint supplements', 'Weight management', 'Physical therapy and hydrotherapy', 'Adequan injections', 'Laser therapy', 'Acupuncture', 'Environmental modifications (ramps, low-sided litter boxes)'],
      whenToVisitVet: 'When you notice persistent limping, difficulty moving, or changes in activity level. Regular check-ups for senior pets.',
      emergencyWarnings: ['Sudden inability to walk', 'Severe limping with vocalization', 'Joint appears grossly swollen or deformed', 'Fever accompanying joint swelling', 'Sudden paralysis of hind legs'],
      emoji: '🦴',
    ),

    // 19. Obesity
    DiseaseInfo(
      name: 'Obesity',
      description: 'A nutritional disease resulting from excess body fat accumulation. It is the most common preventable disease in pets, affecting over 50% of dogs and cats.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Caused by caloric intake exceeding energy expenditure. Contributing factors include overfeeding, too many treats, lack of exercise, neutering/spaying, genetics, and hormonal conditions like hypothyroidism.',
      symptoms: ['Visible excess weight', 'Inability to feel ribs easily', 'No visible waist when viewed from above', 'Difficulty breathing during mild exercise', 'Reduced stamina', 'Heat intolerance'],
      physicalSigns: ['Body weight 15-20% or more above ideal', 'Ribs not palpable under fat layer', 'Loss of waist definition', 'Fat deposits over spine and base of tail', 'Abdominal distension', 'Waddling gait'],
      behavioralChanges: ['Decreased interest in play', 'Excessive sleeping', 'Difficulty grooming (especially cats)', 'Exercise intolerance', 'Food obsession', 'Begging behavior'],
      severity: 'Moderate',
      prevention: ['Measure food portions accurately', 'Follow feeding guidelines for pet\'s ideal weight', 'Limit treats to <10% of daily calories', 'Regular exercise appropriate for breed/age', 'Regular weight checks', 'Use puzzle feeders for mental stimulation'],
      treatments: ['Veterinarian-supervised weight loss plan', 'Prescription weight management diet', 'Gradual calorie reduction', 'Increased exercise (slowly build up)', 'Regular weigh-ins to track progress', 'Rule out medical causes (thyroid, Cushing\'s)'],
      whenToVisitVet: 'Schedule a weight assessment if you can no longer feel your pet\'s ribs. Annual wellness exams should include body condition scoring.',
      emergencyWarnings: ['Difficulty breathing at rest', 'Collapse during exercise', 'Sudden lameness', 'Inability to groom or reach certain body parts', 'Skin fold infections'],
      emoji: '⚖️',
    ),

    // 20. Dental Disease
    DiseaseInfo(
      name: 'Dental Disease (Periodontal Disease)',
      description: 'The most common disease in adult pets, affecting over 80% of dogs and 70% of cats by age 3. It includes gingivitis, periodontitis, tooth resorption, and tooth abscesses.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Caused by bacterial plaque buildup on teeth that hardens into tartar. Without dental care, bacteria invade below the gum line, causing infection, bone loss, and tooth loss.',
      symptoms: ['Bad breath (halitosis)', 'Red or swollen gums', 'Difficulty eating or dropping food', 'Drooling', 'Pawing at mouth', 'Loose or missing teeth', 'Bleeding gums'],
      physicalSigns: ['Brown/yellow tartar on teeth', 'Red swollen gums (gingivitis)', 'Receding gums', 'Loose teeth', 'Pus around teeth', 'Jaw swelling from abscess', 'Nasal discharge (from tooth root abscess)'],
      behavioralChanges: ['Preferring soft food over hard kibble', 'Chewing on one side', 'Head shyness', 'Decreased appetite', 'Rubbing face on objects', 'Reluctance to have mouth examined'],
      severity: 'Moderate',
      prevention: ['Daily tooth brushing with pet-specific toothpaste', 'Dental chews and treats', 'Regular professional dental cleanings', 'Dental-specific diets', 'Water additives for oral health', 'Regular oral examinations'],
      treatments: ['Professional dental cleaning under anesthesia', 'Tooth extractions for severely diseased teeth', 'Antibiotics for infections', 'Pain management', 'Home dental care routine', 'Dental X-rays to assess bone loss'],
      whenToVisitVet: 'At annual check-ups for dental assessment. Sooner if you notice bad breath, difficulty eating, or facial swelling.',
      emergencyWarnings: ['Facial swelling indicating abscess', 'Inability to eat', 'Bleeding from mouth that won\'t stop', 'Fever with oral pain', 'Eye swelling from upper tooth root abscess'],
      emoji: '🦷',
    ),

    // 21. Skin Allergies / Atopic Dermatitis
    DiseaseInfo(
      name: 'Skin Allergies (Atopic Dermatitis)',
      description: 'A chronic inflammatory skin condition caused by environmental allergens such as pollen, dust mites, and molds. It is one of the most common reasons for veterinary visits.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Caused by genetic predisposition to develop allergic reactions to environmental allergens (pollen, dust mites, mold spores), food ingredients, or contact allergens. Common breeds affected: Bulldogs, Retrievers, Terriers.',
      symptoms: ['Chronic itching', 'Recurrent ear infections', 'Licking paws excessively', 'Red inflamed skin', 'Hair loss', 'Recurrent skin infections', 'Watery eyes'],
      physicalSigns: ['Red skin on belly, paws, ears, and armpits', 'Brown saliva staining on paws from licking', 'Thickened darkened skin (lichenification)', 'Hot spots', 'Ear redness and discharge', 'Bacterial or yeast skin infections'],
      behavioralChanges: ['Constant licking, especially of paws', 'Face rubbing on carpet or furniture', 'Scooting', 'Restless sleeping', 'Obsessive scratching at ears', 'Mood changes from chronic discomfort'],
      severity: 'Moderate',
      prevention: ['Regular bathing with hypoallergenic shampoo', 'Air purifiers in the home', 'Regular cleaning to reduce dust mites', 'Omega-3 fatty acid supplements', 'Flea prevention', 'Minimize exposure to known allergens'],
      treatments: ['Apoquel (oclacitinib) for itch control', 'Cytopoint injections', 'Immunotherapy (allergy shots)', 'Medicated shampoos and conditioners', 'Antibiotics/antifungals for secondary infections', 'Corticosteroids for flare-ups', 'Dietary trials for food allergies'],
      whenToVisitVet: 'When itching is persistent and affects quality of life. Sooner if you notice skin infections, hot spots, or hair loss.',
      emergencyWarnings: ['Facial swelling (possible anaphylaxis)', 'Difficulty breathing with skin reaction', 'Widespread severe hot spots', 'Fever with skin infection', 'Significant hair loss with pain'],
      emoji: '🌿',
    ),

    // 22. Eye Diseases
    DiseaseInfo(
      name: 'Eye Diseases (Conjunctivitis & Cataracts)',
      description: 'Various conditions affecting pet eyes including conjunctivitis (pink eye), cataracts, glaucoma, cherry eye, corneal ulcers, and progressive retinal atrophy.',
      affectedAnimals: ['dog', 'cat'],
      causes: 'Conjunctivitis: bacteria, viruses, allergies. Cataracts: aging, diabetes, genetics. Glaucoma: increased intraocular pressure. Corneal ulcers: trauma, dry eye. Cherry eye: weakness of third eyelid gland.',
      symptoms: ['Eye redness', 'Discharge (clear, yellow, or green)', 'Squinting or keeping eye closed', 'Pawing at eyes', 'Cloudiness in the eye', 'Vision changes or bumping into objects', 'Excessive tearing'],
      physicalSigns: ['Red conjunctiva', 'Mucopurulent discharge', 'Cloudy or blue cornea', 'White opacity in lens (cataracts)', 'Bulging eye (glaucoma)', 'Pink mass in corner of eye (cherry eye)', 'Corneal fluorescein stain uptake'],
      behavioralChanges: ['Reluctance to go outside in bright light', 'Bumping into furniture', 'Hesitation on stairs', 'Squinting and blinking', 'Rubbing face on carpet', 'Increased anxiety in unfamiliar places'],
      severity: 'Moderate',
      prevention: ['Regular eye cleaning', 'Protect from eye trauma', 'Manage diabetes to prevent cataracts', 'Regular eye examinations', 'Keep face hair trimmed', 'Avoid irritants near face'],
      treatments: ['Antibiotic eye drops/ointment', 'Anti-inflammatory eye drops', 'Artificial tears for dry eye', 'Surgery for cataracts, cherry eye, or glaucoma', 'Pain management', 'Protective collar to prevent rubbing'],
      whenToVisitVet: 'Within 24 hours for any eye redness or discharge. Immediately for sudden vision loss, severe pain, or trauma to the eye.',
      emergencyWarnings: ['Sudden blindness', 'Severe eye pain (pet won\'t open eye)', 'Eyeball appears to bulge', 'Bleeding from or around the eye', 'Foreign object in the eye', 'Chemical exposure to the eye'],
      emoji: '👁️',
    ),
  ];

  /// Get diseases filtered by animal type
  static List<DiseaseInfo> getDiseasesFor(String animalType) {
    return diseases.where((d) => d.affectedAnimals.contains(animalType.toLowerCase())).toList();
  }

  /// Get diseases by severity level
  static List<DiseaseInfo> getDiseasesBySeverity(String severity) {
    return diseases.where((d) => d.severity == severity).toList();
  }

  /// Search diseases by name or symptoms
  static List<DiseaseInfo> searchDiseases(String query) {
    final lower = query.toLowerCase();
    return diseases.where((d) {
      return d.name.toLowerCase().contains(lower) ||
          d.description.toLowerCase().contains(lower) ||
          d.symptoms.any((s) => s.toLowerCase().contains(lower)) ||
          d.physicalSigns.any((s) => s.toLowerCase().contains(lower));
    }).toList();
  }
}

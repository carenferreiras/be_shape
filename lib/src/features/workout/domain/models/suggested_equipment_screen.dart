import '../../../features.dart';

class SuggestedEquipment {
  final String name;
  final EquipmentCategory category;
  final String description;
  final List<String> muscleGroups;
  final List<String> exercises;

  const SuggestedEquipment({
    required this.name,
    required this.category,
    required this.description,
    required this.muscleGroups,
    required this.exercises,
  });
}

final Map<String, SuggestedEquipment> suggestedEquipments = {
  'Faixas elásticas': SuggestedEquipment(
    name: 'Faixas elásticas',
    category: EquipmentCategory.resistance,
    description: 'Conjunto de faixas elásticas para exercícios de resistência progressiva',
    muscleGroups: ['Peitoral', 'Costas', 'Ombros', 'Bíceps', 'Tríceps', 'Pernas'],
    exercises: [
      'Remada com faixa',
      'Extensão de tríceps',
      'Rosca bíceps',
      'Elevação lateral',
      'Agachamento com resistência',
    ],
  ),
  
  'Halteres': SuggestedEquipment(
    name: 'Halteres',
    category: EquipmentCategory.freeWeight,
    description: 'Par de halteres para exercícios de força e hipertrofia',
    muscleGroups: ['Peitoral', 'Ombros', 'Bíceps', 'Tríceps', 'Antebraço'],
    exercises: [
      'Rosca bíceps',
      'Extensão de tríceps',
      'Elevação lateral',
      'Desenvolvimento',
      'Crucifixo',
    ],
  ),
  'Tapete de exercício': SuggestedEquipment(
    name: 'Tapete de exercício',
    category: EquipmentCategory.calisthenics,
    description: 'Tapete para exercícios no solo e alongamentos',
    muscleGroups: ['Abdômen', 'Lombar', 'Core'],
    exercises: [
      'Abdominais',
      'Prancha',
      'Alongamentos',
      'Push-ups',
      'Mountain climbers',
    ],
  ),
  'Barra fixa': SuggestedEquipment(
    name: 'Barra fixa',
    category: EquipmentCategory.calisthenics,
    description: 'Barra para exercícios de puxada e calistenia',
    muscleGroups: ['Costas', 'Bíceps', 'Antebraço', 'Core'],
    exercises: [
      'Pull-ups',
      'Chin-ups',
      'Penduradas',
      'Elevação de pernas',
      'Australian pull-ups',
    ],
  ),
  'Corda de pular': SuggestedEquipment(
    name: 'Corda de pular',
    category: EquipmentCategory.cardio,
    description: 'Corda para exercícios cardio e coordenação',
    muscleGroups: ['Pernas', 'Panturrilha', 'Core'],
    exercises: [
      'Pulo básico',
      'Pulo alternado',
      'Double unders',
      'Corrida estacionária',
      'Pulo cruzado',
    ],
  ),
  'Kettlebell': SuggestedEquipment(
    name: 'Kettlebell',
    category: EquipmentCategory.freeWeight,
    description: 'Kettlebell para exercícios funcionais e de força',
    muscleGroups: ['Pernas', 'Costas', 'Ombros', 'Core'],
    exercises: [
      'Swing',
      'Turkish get-up',
      'Clean and press',
      'Goblet squat',
      'Snatch',
    ],
  ),
  'Rolo de espuma': SuggestedEquipment(
    name: 'Rolo de espuma',
    category: EquipmentCategory.recovery,
    description: 'Rolo para liberação miofascial e recuperação muscular',
    muscleGroups: ['Costas', 'Pernas', 'Glúteos', 'IT Band'],
    exercises: [
      'Liberação da coluna',
      'Liberação de quadríceps',
      'Liberação de panturrilha',
      'Liberação de IT Band',
      'Liberação de glúteos',
    ],
  ),
  'TRX': SuggestedEquipment(
    name: 'TRX',
    category: EquipmentCategory.resistance,
    description: 'Sistema de treino em suspensão para exercícios corporais',
    muscleGroups: ['Peitoral', 'Costas', 'Core', 'Pernas', 'Ombros'],
    exercises: [
      'TRX rows',
      'TRX push-ups',
      'TRX squats',
      'TRX mountain climbers',
      'TRX pikes',
    ],
  ),
  'Bola suíça': SuggestedEquipment(
    name: 'Bola suíça',
    category: EquipmentCategory.calisthenics,
    description: 'Bola de estabilidade para exercícios de core e equilíbrio',
    muscleGroups: ['Core', 'Abdômen', 'Lombar', 'Pernas'],
    exercises: [
      'Abdominal na bola',
      'Wall ball squat',
      'Prancha com pés na bola',
      'Bridge na bola',
      'Extensão lombar',
    ],
  ),
  'Banco ajustável': SuggestedEquipment(
    name: 'Banco ajustável',
    category: EquipmentCategory.machine,
    description: 'Banco com inclinação ajustável para diversos exercícios',
    muscleGroups: ['Peitoral', 'Ombros', 'Tríceps', 'Abdômen'],
    exercises: [
      'Supino com halteres',
      'Remada unilateral',
      'Extensão de tríceps',
      'Abdominais declinados',
      'Elevação lateral sentado',
    ],
  ),
  'Rack de agachamento': SuggestedEquipment(
    name: 'Rack de agachamento',
    category: EquipmentCategory.freeWeight,
    description: 'Estrutura para exercícios com barra e peso livre com segurança',
    muscleGroups: ['Pernas', 'Costas', 'Peitoral', 'Ombros'],
    exercises: [
      'Agachamento',
      'Supino',
      'Desenvolvimento militar',
      'Rack pulls',
      'Good morning',
    ],
  ),
  'Barra olímpica': SuggestedEquipment(
    name: 'Barra olímpica',
    category: EquipmentCategory.freeWeight,
    description: 'Barra profissional para exercícios com peso livre',
    muscleGroups: ['Pernas', 'Costas', 'Peitoral', 'Ombros', 'Trapézio'],
    exercises: [
      'Levantamento terra',
      'Supino',
      'Agachamento',
      'Desenvolvimento',
      'Power clean',
    ],
  ),
  'Anilhas': SuggestedEquipment(
    name: 'Anilhas',
    category: EquipmentCategory.freeWeight,
    description: 'Conjunto de pesos para exercícios com barra e halteres',
    muscleGroups: ['Todos os grupos musculares'],
    exercises: [
      'Exercícios com barra',
      'Exercícios com halter',
      'Farmer\'s walk',
      'Peso morto romeno',
      'Remada curvada',
    ],
  ),
  'Plataforma de peso': SuggestedEquipment(
    name: 'Plataforma de peso',
    category: EquipmentCategory.freeWeight,
    description: 'Plataforma para exercícios olímpicos e powerlifting',
    muscleGroups: ['Pernas', 'Costas', 'Core', 'Ombros'],
    exercises: [
      'Clean & Jerk',
      'Snatch',
      'Deadlift',
      'Power cleans',
      'Push press',
    ],
  ),
  'Puxador': SuggestedEquipment(
    name: 'Puxador',
    category: EquipmentCategory.machine,
    description: 'Estação para exercícios de puxada e remada',
    muscleGroups: ['Costas', 'Bíceps', 'Antebraço', 'Core'],
    exercises: [
      'Puxada frontal',
      'Puxada fechada',
      'Remada baixa',
      'Face pull',
      'Tríceps na polia',
    ],
  ),
  // Máquinas
'Leg Press': SuggestedEquipment(
  name: 'Leg Press',
  category: EquipmentCategory.machine,
  description: 'Máquina para exercícios de perna com carga ajustável',
  muscleGroups: ['Quadríceps', 'Glúteos', 'Posteriores', 'Panturrilhas'],
  exercises: [
    'Leg press tradicional',
    'Leg press alto',
    'Leg press unilateral',
    'Panturrilha no leg press',
    'Leg press sumo',
  ],
),

'Smith Machine': SuggestedEquipment(
  name: 'Smith Machine',
  category: EquipmentCategory.machine,
  description: 'Máquina com barra guiada para exercícios diversos',
  muscleGroups: ['Peitoral', 'Ombros', 'Pernas', 'Costas'],
  exercises: [
    'Agachamento smith',
    'Supino smith',
    'Desenvolvimento smith',
    'Remada smith',
    'Elevação de panturrilha',
  ],
),

'Hack Squat': SuggestedEquipment(
  name: 'Hack Squat',
  category: EquipmentCategory.machine,
  description: 'Máquina para variação de agachamento com suporte',
  muscleGroups: ['Quadríceps', 'Glúteos', 'Posteriores'],
  exercises: [
    'Hack squat tradicional',
    'Hack squat sumo',
    'Hack squat unilateral',
    'Elevação de panturrilha',
  ],
),

'Crossover': SuggestedEquipment(
  name: 'Crossover',
  category: EquipmentCategory.cable,
  description: 'Estação de cabos dupla para exercícios variados',
  muscleGroups: ['Peitoral', 'Costas', 'Ombros', 'Bíceps', 'Tríceps'],
  exercises: [
    'Crucifixo',
    'Face pull',
    'Tríceps corda',
    'Remada unilateral',
    'Elevação lateral',
  ],
),

'Cadeira Extensora': SuggestedEquipment(
  name: 'Cadeira Extensora',
  category: EquipmentCategory.machine,
  description: 'Máquina para isolamento de quadríceps',
  muscleGroups: ['Quadríceps'],
  exercises: [
    'Extensão de pernas',
    'Extensão unilateral',
    'Drop set extensora',
    'Isometria extensora',
  ],
),

'Cadeira Flexora': SuggestedEquipment(
  name: 'Cadeira Flexora',
  category: EquipmentCategory.machine,
  description: 'Máquina para isolamento de posteriores',
  muscleGroups: ['Posteriores'],
  exercises: [
    'Flexão de pernas',
    'Flexão unilateral',
    'Drop set flexora',
    'Isometria flexora',
  ],
),

'Pec Deck': SuggestedEquipment(
  name: 'Pec Deck',
  category: EquipmentCategory.machine,
  description: 'Máquina para isolamento de peitoral',
  muscleGroups: ['Peitoral'],
  exercises: [
    'Pec deck tradicional',
    'Pec deck invertido (posterior)',
    'Pec deck unilateral',
    'Isometria peitoral',
  ],
),

'Graviton': SuggestedEquipment(
  name: 'Graviton',
  category: EquipmentCategory.machine,
  description: 'Máquina assistida para exercícios de puxada',
  muscleGroups: ['Costas', 'Bíceps', 'Peitoral', 'Tríceps'],
  exercises: [
    'Pull-up assistido',
    'Dips assistido',
    'Chin-up assistido',
    'Puxada neutra',
  ],
),

'Banco Scott': SuggestedEquipment(
  name: 'Banco Scott',
  category: EquipmentCategory.machine,
  description: 'Banco específico para exercícios de bíceps',
  muscleGroups: ['Bíceps', 'Antebraço'],
  exercises: [
    'Rosca scott barra',
    'Rosca scott halter',
    'Rosca scott unilateral',
    'Rosca martelo scott',
  ],
),

'Máquina Panturrilha': SuggestedEquipment(
  name: 'Máquina Panturrilha',
  category: EquipmentCategory.machine,
  description: 'Máquina específica para exercícios de panturrilha',
  muscleGroups: ['Panturrilhas'],
  exercises: [
    'Elevação de panturrilha em pé',
    'Elevação de panturrilha sentado',
    'Elevação unilateral',
    'Isometria de panturrilha',
  ],
),

'Esteira': SuggestedEquipment(
  name: 'Esteira',
  category: EquipmentCategory.cardio,
  description: 'Equipamento para corrida e caminhada indoor',
  muscleGroups: ['Pernas', 'Core', 'Sistema Cardiovascular'],
  exercises: [
    'Caminhada',
    'Corrida',
    'Sprint intervals',
    'Incline walk',
    'HIIT na esteira',
  ],
),

'Bicicleta Ergométrica': SuggestedEquipment(
  name: 'Bicicleta Ergométrica',
  category: EquipmentCategory.cardio,
  description: 'Equipamento para ciclismo indoor',
  muscleGroups: ['Pernas', 'Core', 'Sistema Cardiovascular'],
  exercises: [
    'Pedalada contínua',
    'Sprint intervals',
    'Hill climb',
    'HIIT bike',
    'Recuperação ativa',
  ],
),

'Elíptico': SuggestedEquipment(
  name: 'Elíptico',
  category: EquipmentCategory.cardio,
  description: 'Equipamento para cardio de baixo impacto',
  muscleGroups: ['Pernas', 'Braços', 'Core', 'Sistema Cardiovascular'],
  exercises: [
    'Cardio contínuo',
    'Intervals',
    'Reverse stride',
    'HIIT elíptico',
    'Warm-up',
  ],
),

};
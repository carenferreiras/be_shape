// lib/tips_data.dart
class Tip {
  final String title;
  final String description;
  final String imagePath;
  final String motivationalQuote;

  Tip({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.motivationalQuote,
  });
}

final List<Tip> tips = [
  Tip(
    title: "Hidrate-se Bem 💧",
    description: "Beba pelo menos 2 litros de água por dia para manter o corpo funcionando corretamente.",
    imagePath: "assets/images/water.png",
    motivationalQuote: "Seu corpo é 70% água. Mantenha-se hidratado e energizado!",
  ),
  Tip(
    title: "Alongue-se Sempre 🧘",
    description: "Antes e depois dos treinos, faça alongamentos para evitar lesões e melhorar sua flexibilidade.",
    imagePath: "assets/images/stretching.png",
    motivationalQuote: "Seu corpo é sua casa. Cuide dele com movimento e alongamento!",
  ),
  Tip(
    title: "Alimente-se com Qualidade 🍎",
    description: "Dê prioridade a alimentos naturais e evite ultraprocessados para melhor desempenho.",
    imagePath: "assets/images/healthy_food.png",
    motivationalQuote: "Você é o que come. Escolha se alimentar de energia e vida!",
  ),
  Tip(
    title: "Durma Bem 😴",
    description: "Dormir pelo menos 7-8 horas por noite é essencial para recuperação muscular e disposição.",
    imagePath: "assets/images/sleep.png",
    motivationalQuote: "O descanso é tão importante quanto o treino. Recupere-se e cresça!",
  ),
  Tip(
    title: "Mantenha-se Ativo 🏃‍♂️",
    description: "Faça atividades físicas regularmente para melhorar sua saúde e qualidade de vida.",
    imagePath: "assets/images/running.png",
    motivationalQuote: "Seu corpo foi feito para se mover. Mantenha-se ativo e vença cada dia!",
  ),
];
class WaterEntry {
  final String time; // Exemplo: "9:30 AM"
  final int amount;  // Quantidade em ml

  WaterEntry({required this.time, required this.amount});

  // Conversão para JSON
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'amount': amount,
    };
  }

  // Criação de instância a partir de JSON
  factory WaterEntry.fromJson(Map<String, dynamic> json) {
    return WaterEntry(
      time: json['time'] as String,
      amount: json['amount'] as int,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodFilterModal extends StatefulWidget {
  final Function(
    String name,
    double minCalories,
    double maxCalories,
    double minProtein,
    double maxProtein,
    double minCarbs,
    double maxCarbs,
    double minFat,
    double maxFat,
  ) onApplyFilters;

  const FoodFilterModal({super.key, required this.onApplyFilters});

  @override
  _FoodFilterModalState createState() => _FoodFilterModalState();
}

class _FoodFilterModalState extends State<FoodFilterModal> {
  final TextEditingController _nameController = TextEditingController();
  double _minCalories = 0, _maxCalories = 1000;
  double _minProtein = 0, _maxProtein = 100;
  double _minCarbs = 0, _maxCarbs = 100;
  double _minFat = 0, _maxFat = 100;

  @override
  void initState() {
    super.initState();
    _loadSavedFilters();
  }

  /// 🔹 **Carrega os filtros salvos**
  Future<void> _loadSavedFilters() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('filter_name') ?? '';
      _minCalories = prefs.getDouble('filter_minCalories') ?? 0;
      _maxCalories = prefs.getDouble('filter_maxCalories') ?? 1000;
      _minProtein = prefs.getDouble('filter_minProtein') ?? 0;
      _maxProtein = prefs.getDouble('filter_maxProtein') ?? 100;
      _minCarbs = prefs.getDouble('filter_minCarbs') ?? 0;
      _maxCarbs = prefs.getDouble('filter_maxCarbs') ?? 100;
      _minFat = prefs.getDouble('filter_minFat') ?? 0;
      _maxFat = prefs.getDouble('filter_maxFat') ?? 100;
    });
  }

  /// 🔹 **Salva os filtros**
  Future<void> _saveFilters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('filter_name', _nameController.text);
    await prefs.setDouble('filter_minCalories', _minCalories);
    await prefs.setDouble('filter_maxCalories', _maxCalories);
    await prefs.setDouble('filter_minProtein', _minProtein);
    await prefs.setDouble('filter_maxProtein', _maxProtein);
    await prefs.setDouble('filter_minCarbs', _minCarbs);
    await prefs.setDouble('filter_maxCarbs', _maxCarbs);
    await prefs.setDouble('filter_minFat', _minFat);
    await prefs.setDouble('filter_maxFat', _maxFat);
  }

  /// 🔄 **Limpa os filtros**
  Future<void> _clearFilters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    setState(() {
      _nameController.text = '';
      _minCalories = 0;
      _maxCalories = 1000;
      _minProtein = 0;
      _maxProtein = 100;
      _minCarbs = 0;
      _maxCarbs = 100;
      _minFat = 0;
      _maxFat = 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "🔎 Filtrar Alimentos",
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            /// 🔍 **Filtro por Nome**
            _buildTextField("Nome do Alimento", _nameController),

            /// 🔥 **Filtro por Calorias**
            _buildRangeSlider("🔥 Calorias", 0, 1000, _minCalories, _maxCalories, (min, max) {
              setState(() {
                _minCalories = min;
                _maxCalories = max;
              });
            }),

            /// 🍗 **Filtro por Proteína**
            _buildRangeSlider("🍗 Proteína", 0, 100, _minProtein, _maxProtein, (min, max) {
              setState(() {
                _minProtein = min;
                _maxProtein = max;
              });
            }),

            /// 🍞 **Filtro por Carboidratos**
            _buildRangeSlider("🍞 Carboidratos", 0, 100, _minCarbs, _maxCarbs, (min, max) {
              setState(() {
                _minCarbs = min;
                _maxCarbs = max;
              });
            }),

            /// 🥑 **Filtro por Gordura**
            _buildRangeSlider("🥑 Gordura", 0, 100, _minFat, _maxFat, (min, max) {
              setState(() {
                _minFat = min;
                _maxFat = max;
              });
            }),

            const SizedBox(height: 16),

            /// **Botões de Aplicar & Limpar Filtros**
            _buildFilterButtons(),
          ],
        ),
      ),
    );
  }

  /// **Campo de Texto (Nome do Alimento)**
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.orange),
          ),
        ),
      ),
    );
  }

  /// **Slider de Faixa (Calorias, Proteína, Carboidratos, Gordura)**
  Widget _buildRangeSlider(
    String label,
    double min,
    double max,
    double minValue,
    double maxValue,
    Function(double, double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${minValue.toStringAsFixed(0)}", style: const TextStyle(color: Colors.orange, fontSize: 14)),
            Text("${maxValue.toStringAsFixed(0)}", style: const TextStyle(color: Colors.orange, fontSize: 14)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            thumbColor: Colors.orange,
            activeTrackColor: Colors.orangeAccent,
            inactiveTrackColor: Colors.grey[700],
          ),
          child: RangeSlider(
            min: min,
            max: max,
            values: RangeValues(minValue, maxValue),
            onChanged: (values) => onChanged(values.start, values.end),
          ),
        ),
      ],
    );
  }

  /// **Botões "Aplicar Filtros" & "Limpar Filtros"**
  Widget _buildFilterButtons() {
    return Row(
      children: [
        Expanded(child: _buildButton("❌ Limpar", Colors.grey[800]!, _clearFilters)),
        const SizedBox(width: 12),
        Expanded(child: _buildButton("✅ Aplicar", Colors.orange, _saveFilters)),
      ],
    );
  }

  /// **Constrói um botão estilizado**
  Widget _buildButton(String text, Color color, Function() onTap) {
    return ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orange,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  onPressed: () async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('filter_name', _nameController.text);
    await prefs.setDouble('filter_minCalories', _minCalories);
    await prefs.setDouble('filter_maxCalories', _maxCalories);
    await prefs.setDouble('filter_minProtein', _minProtein);
    await prefs.setDouble('filter_maxProtein', _maxProtein);
    await prefs.setDouble('filter_minCarbs', _minCarbs);
    await prefs.setDouble('filter_maxCarbs', _maxCarbs);
    await prefs.setDouble('filter_minFat', _minFat);
    await prefs.setDouble('filter_maxFat', _maxFat);

    widget.onApplyFilters(
      _nameController.text,
      _minCalories,
      _maxCalories,
      _minProtein,
      _maxProtein,
      _minCarbs,
      _maxCarbs,
      _minFat,
      _maxFat,
    );
    
    Navigator.pop(context); // Fecha o modal
  },
  child: const Padding(
    padding: EdgeInsets.symmetric(vertical: 12),
    child: Text(
      "✅ Aplicar Filtros",
      style: TextStyle(color: Colors.white, fontSize: 16),
    ),
  ),
);
  }
}
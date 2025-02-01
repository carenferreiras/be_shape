import 'package:be_shape_app/src/core/core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../auth/auth.dart';

class FoodSuggestionsScreen extends StatefulWidget {
  final UserProfile userProfile;

  const FoodSuggestionsScreen({super.key, required this.userProfile});

  @override
  State<FoodSuggestionsScreen> createState() => _FoodSuggestionsScreenState();
}

class _FoodSuggestionsScreenState extends State<FoodSuggestionsScreen> {
  List<DocumentSnapshot> alimentos = [];
  String filtroNome = '';

  @override
  void initState() {
    super.initState();
    buscarAlimentos();
  }

  // Função para buscar alimentos do Firestore
  void buscarAlimentos() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('foods').get();
    setState(() {
      alimentos = querySnapshot.docs;
    });
  }

  // Função para filtrar os alimentos
  List<DocumentSnapshot> filtrarAlimentos() {
    return alimentos.where((alimento) {
      final nome = alimento['nome_alimento']?.toString().toLowerCase() ?? '';
      return nome.contains(filtroNome.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final alimentosFiltrados = filtrarAlimentos();

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(BeShapeImages.foodBackground),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: BeShapeColors.transparent,
        appBar: BeShapeAppBar(
          title: 'Alimentos',
          actionIcon: Icons.filter_alt,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(color: BeShapeColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Buscar por nome',
                  prefixIcon: Icon(Icons.search, color: BeShapeColors.primary),
                  labelStyle: const TextStyle(color: Colors.grey),
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: BeShapeColors.primary),
                    borderRadius:
                        BorderRadius.circular(BeShapeSizes.borderRadiusLarge),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: BeShapeColors.primary),
                    borderRadius:
                        BorderRadius.circular(BeShapeSizes.borderRadiusLarge),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1E),
                ),
                onChanged: (value) {
                  setState(() {
                    filtroNome = value;
                  });
                },
              ),
            ),
            Expanded(
              child: alimentosFiltrados.isEmpty
                  ? Center(child: Text('Nenhum alimento encontrado.'))
                  : ListView.builder(
                      itemCount: alimentosFiltrados.length,
                      itemBuilder: (context, index) {
                        final data = alimentosFiltrados[index].data()
                            as Map<String, dynamic>;

                        return _customCard(
                          caloriesIcon: Icons.water_drop_outlined,
                          calories:
                              '${safeParseDouble(data['energia_kcal']).toStringAsFixed(2)}',
                          carbo:
                              '${safeParseDouble(data['carboidrato']).toStringAsFixed(2)}',
                          proteinIcon: Icons.fitness_center,
                          fibersIcon: Icons.fiber_smart_record,
                          fibers:
                              '${safeParseDouble(data['fibras']).toStringAsFixed(2)}',
                          foodName: data['nome_alimento'] ?? 'Sem nome',
                          classification: data['classificacao'] ?? 'Sem nome',
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Função auxiliar para tratar valores numéricos
  double safeParseDouble(dynamic value) {
    if (value == null || value == 'NA') return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  Widget _customCard(
      {required IconData caloriesIcon,
      required IconData proteinIcon,
      required IconData fibersIcon,
      required String calories,
      required String carbo,
      required String fibers,
      required String foodName,
      required String classification}) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          colors: [
            BeShapeColors.background.withOpacity(0.7),
            BeShapeColors.background.withOpacity(0.7),
            BeShapeColors.background.withOpacity(0.6),
            BeShapeColors.background.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: BeShapeColors.primary.withOpacity(0.3),
        ),
      ),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: [
                _numberCard(
                    icon: caloriesIcon,
                    number: calories,
                    measure: 'g',
                    name: 'Calorias',
                    color: Colors.orange),
                _numberCard(
                    icon: proteinIcon,
                    number: calories,
                    measure: 'g',
                    name: 'Proteínas',
                    color: Colors.blue),
                _numberCard(
                    icon: fibersIcon,
                    number: fibers,
                    measure: 'g',
                    name: 'Fibras',
                    color: Colors.green),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        foodName,
                        maxLines: 2,
                        style: TextStyle(
                            color: BeShapeColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Card(
                      color: BeShapeColors.primary.withOpacity(0.2),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: Text(
                          classification,
                          style: TextStyle(
                              color: BeShapeColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberCard({
    required IconData icon,
    required String number,
    required String measure,
    required String name,
    required Color color,
  }) {
    return SizedBox(
      width: 100,
      child: Card(
        color: color.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 12,
                    color: color,
                  ),
                  Text(
                    number,
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                  SizedBox(
                    width: 2,
                  ),
                  Text(
                    measure,
                    style: TextStyle(color: color, fontSize: 10),
                  ),
                ],
              ),
              Text(
                name,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para mapear categorias a imagens
  String getImagemPorCategoria(String categoria) {
    switch (categoria.toLowerCase()) {
      case 'frutas':
        return 'assets/images/frutas.jpg';
      case 'vegetais':
        return 'assets/images/vegetais.jpg';
      case 'grãos':
        return 'assets/images/graos.jpg';
      case 'proteínas':
        return 'assets/images/proteinas.jpg';
      default:
        return 'assets/images/default.jpg';
    }
  }
}

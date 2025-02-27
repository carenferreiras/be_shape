import 'package:flutter/material.dart';

import '../../../../core/core.dart';

class TrainingSelectionScreen extends StatefulWidget {
  @override
  _TrainingSelectionScreenState createState() =>
      _TrainingSelectionScreenState();
}

class _TrainingSelectionScreenState extends State<TrainingSelectionScreen>
    with SingleTickerProviderStateMixin {
  Map<String, bool> _selectedEquipment = {};
  List<String> _selectedTrainings = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedEquipment = {
      for (var key in trainingData.keys) key: false,
    };
  }

  void _generateTrainings() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    List<String> selectedTrainings = [];
    _selectedEquipment.forEach((equipment, isSelected) {
      if (isSelected) {
        selectedTrainings.addAll(trainingData[equipment]!);
      }
    });

    setState(() {
      _selectedTrainings = selectedTrainings.toSet().toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treino em Casa', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Escolha os equipamentos disponíveis:',
              style: TextStyle(fontSize: 18, color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _selectedEquipment.keys.length,
                itemBuilder: (context, index) {
                  String key = _selectedEquipment.keys.elementAt(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedEquipment[key] = !_selectedEquipment[key]!;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      transform: _selectedEquipment[key]!
                          ? Matrix4.translationValues(0, -10, 0)
                          : Matrix4.identity(),
                      decoration: BoxDecoration(
                        color: _selectedEquipment[key]! ? Colors.orange : Colors.grey[900],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: _selectedEquipment[key]!
                            ? [BoxShadow(color: Colors.orange, blurRadius: 10)]
                            : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(equipmentIcons[key] ?? Icons.fitness_center,
                              size: 40, color: Colors.white),
                          SizedBox(height: 10),
                          Text(
                            key,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.orange))
                : ElevatedButton(
                    onPressed: _generateTrainings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      'Gerar Treinos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ),
            SizedBox(height: 20),
            Text(
              'Treinos sugeridos:',
              style: TextStyle(fontSize: 18, color: Colors.orange, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: _selectedTrainings.isEmpty
                    ? Center(
                        child: Text("Nenhum treino selecionado", 
                            style: TextStyle(color: Colors.grey)))
                    : ListView.builder(
                        itemCount: _selectedTrainings.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.grey[900],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              leading: Icon(Icons.fitness_center, color: Colors.orange),
                              title: Text(
                                _selectedTrainings[index],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
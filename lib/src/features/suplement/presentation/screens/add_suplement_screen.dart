import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../features.dart';

class AddSupplementScreen extends StatefulWidget {
  const AddSupplementScreen({super.key});

  @override
  State<AddSupplementScreen> createState() => _AddSupplementScreenState();
}

class _AddSupplementScreenState extends State<AddSupplementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _dosageController = TextEditingController();
  final _servingSizeController = TextEditingController();
  final _notesController = TextEditingController();
  final _daysSupplyController = TextEditingController();
  final _warningsController = TextEditingController();

  SupplementType _selectedType = SupplementType.protein;
  DosageUnit _selectedUnit = DosageUnit.grams;
  DateTime _startDate = DateTime.now();
  DateTime? _endDate;
  final List<DateTime> _scheduledTimes = [];
  final Map<String, bool> _daysOfWeek = {
    'monday': true,
    'tuesday': true,
    'wednesday': true,
    'thursday': true,
    'friday': true,
    'saturday': true,
    'sunday': true,
  };

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _dosageController.dispose();
    _servingSizeController.dispose();
    _notesController.dispose();
    _daysSupplyController.dispose();
    _warningsController.dispose();
    super.dispose();
  }

  void _addScheduledTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.purple,
              onPrimary: Colors.white,
              surface: Color(0xFF303030),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF303030)),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        final now = DateTime.now();
        _scheduledTimes.add(
          DateTime(now.year, now.month, now.day, time.hour, time.minute),
        );
        _scheduledTimes.sort();
      });
    }
  }

  void _removeScheduledTime(DateTime time) {
    setState(() {
      _scheduledTimes.remove(time);
    });
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.purple,
              onPrimary: Colors.white,
              surface: Color(0xFF303030),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF303030)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 30)),
      firstDate: _startDate,
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.purple,
              onPrimary: Colors.white,
              surface: Color(0xFF303030),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF303030)),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _submitSupplement() {
    if (_formKey.currentState!.validate()) {
      final userId = context.read<AuthBloc>().currentUserId;
      if (userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated')),
        );
        return;
      }

      if (_scheduledTimes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Adicione pelo menos um horário')),
        );
        return;
      }

      final supplement = Supplement(
        id: DateTime.now().toString(),
        userId: userId,
        name: _nameController.text,
        type: _selectedType,
        brand: _brandController.text,
        dosage: double.parse(_dosageController.text),
        unit: _selectedUnit,
        servingSize: _servingSizeController.text.isEmpty
            ? null
            : _servingSizeController.text,
        scheduledTimes: _scheduledTimes,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        startDate: _startDate,
        endDate: _endDate,
        daysSupply: int.parse(_daysSupplyController.text),
        warnings: _warningsController.text.isEmpty
            ? null
            : _warningsController.text.split('\n'),
        daysOfWeek: _daysOfWeek,
      );

      context.read<SupplementBloc>().add(AddSupplement(supplement));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Adicionar Suplemento'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Informações Básicas
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações Básicas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration(
                        'Nome do Suplemento',
                        Icons.medication,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o nome do suplemento';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _brandController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration(
                        'Marca',
                        Icons.business,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a marca';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTypeSelector(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Dosagem
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dosagem',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _dosageController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              'Quantidade',
                              Icons.scale,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Obrigatório';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildUnitSelector(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _servingSizeController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _buildInputDecoration(
                        'Tamanho da Porção (opcional)',
                        Icons.straighten,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Horários
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Horários',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _addScheduledTime,
                          icon: const Icon(Icons.add, color: Colors.purple),
                          label: const Text(
                            'Adicionar',
                            style: TextStyle(color: Colors.purple),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_scheduledTimes.isEmpty)
                      Center(
                        child: Text(
                          'Nenhum horário definido',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      )
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _scheduledTimes.map((time) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.withValues(alpha: (0.2)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  DateFormat('HH:mm').format(time),
                                  style: const TextStyle(
                                    color: Colors.purple,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _removeScheduledTime(time),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.purple,
                                    size: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Dias da Semana
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Dias da Semana',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _daysOfWeek.entries.map((entry) {
                        return FilterChip(
                          selected: entry.value,
                          label: Text(
                            entry.key.substring(0, 3).toUpperCase(),
                            style: TextStyle(
                              color: entry.value ? Colors.white : Colors.grey,
                            ),
                          ),
                          backgroundColor: Colors.grey[800],
                          selectedColor: Colors.purple,
                          onSelected: (bool selected) {
                            setState(() {
                              _daysOfWeek[entry.key] = selected;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Período
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Período',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _selectStartDate,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[800]!,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Início',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    DateFormat('dd/MM/yyyy').format(_startDate),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: InkWell(
                            onTap: _selectEndDate,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey[800]!,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Fim (opcional)',
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _endDate != null
                                        ? DateFormat('dd/MM/yyyy')
                                            .format(_endDate!)
                                        : 'Não definido',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _daysSupplyController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        'Duração do Frasco (dias)',
                        Icons.calendar_today,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a duração';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Informações Adicionais
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações Adicionais',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: _buildInputDecoration(
                        'Notas (opcional)',
                        Icons.note,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _warningsController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 3,
                      decoration: _buildInputDecoration(
                        'Avisos/Contraindicações (opcional)',
                        Icons.warning,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitSupplement,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Salvar Suplemento',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<SupplementType>(
          value: _selectedType,
          dropdownColor: Colors.grey[900],
          style: const TextStyle(color: Colors.white),
          items: SupplementType.values.map((type) {
            return DropdownMenuItem<SupplementType>(
              value: type,
              child: Text(_getTypeText(type)),
            );
          }).toList(),
          onChanged: (SupplementType? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedType = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildUnitSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DosageUnit>(
          value: _selectedUnit,
          dropdownColor: Colors.grey[900],
          style: const TextStyle(color: Colors.white),
          items: DosageUnit.values.map((unit) {
            return DropdownMenuItem<DosageUnit>(
              value: unit,
              child: Text(unit.toString().split('.').last),
            );
          }).toList(),
          onChanged: (DosageUnit? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedUnit = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: Icon(icon, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[800]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.purple),
      ),
      filled: true,
      fillColor: Colors.grey[850],
    );
  }

  String _getTypeText(SupplementType type) {
    switch (type) {
      case SupplementType.protein:
        return 'Proteína';
      case SupplementType.creatine:
        return 'Creatina';
      case SupplementType.bcaa:
        return 'BCAA';
      case SupplementType.preworkout:
        return 'Pré-treino';
      case SupplementType.vitamin:
        return 'Vitamina';
      case SupplementType.mineral:
        return 'Mineral';
      case SupplementType.omega3:
        return 'Ômega 3';
      case SupplementType.other:
        return 'Outro';
    }
  }
}

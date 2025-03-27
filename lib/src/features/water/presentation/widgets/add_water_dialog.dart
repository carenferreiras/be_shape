import 'package:flutter/material.dart';

class AddWaterDialog extends StatefulWidget {
  final Function(double) onAdd;

  const AddWaterDialog({
    super.key,
    required this.onAdd,
  });

  @override
  State<AddWaterDialog> createState() => _AddWaterDialogState();
}

class _AddWaterDialogState extends State<AddWaterDialog> {
  double _selectedAmount = 250;
  final _customAmountController = TextEditingController();
  bool _isCustomAmount = false;

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: (0.2)),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.water_drop,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Adicionar Água',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildPresetAmount(100),
                _buildPresetAmount(200),
                _buildPresetAmount(250),
                _buildPresetAmount(300),
                _buildPresetAmount(500),
                _buildPresetAmount(1000),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.grey),
            const SizedBox(height: 16),
            _buildCustomAmountInput(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _handleAddWater,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Adicionar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetAmount(double amount) {
    final isSelected = !_isCustomAmount && _selectedAmount == amount;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAmount = amount;
          _isCustomAmount = false;
          _customAmountController.clear();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.blue.withValues(alpha: (0.2))
              : Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${amount.round()}',
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ml',
              style: TextStyle(
                color: isSelected
                    ? Colors.blue.withValues(alpha: (0.7))
                    : Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAmountInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isCustomAmount
            ? Colors.blue.withValues(alpha: (0.1))
            : Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isCustomAmount ? Colors.blue : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit,
                color: _isCustomAmount ? Colors.blue : Colors.grey,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Quantidade Personalizada',
                style: TextStyle(
                  color: _isCustomAmount ? Colors.blue : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _customAmountController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            onTap: () {
              setState(() {
                _isCustomAmount = true;
              });
            },
            decoration: InputDecoration(
              hintText: 'Digite a quantidade em ml',
              hintStyle: TextStyle(color: Colors.grey[600]),
              suffixText: 'ml',
              suffixStyle: TextStyle(color: Colors.grey[400]),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[700]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              filled: true,
              fillColor: Colors.grey[850],
            ),
          ),
        ],
      ),
    );
  }

  void _handleAddWater() {
    double amount;
    if (_isCustomAmount) {
      amount = double.tryParse(_customAmountController.text) ?? 0;
      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, insira uma quantidade válida'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else {
      amount = _selectedAmount;
    }

    widget.onAdd(amount);
    Navigator.pop(context);
  }
}

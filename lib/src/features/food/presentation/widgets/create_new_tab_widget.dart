import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class CreateNewTabWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController brandController;
  final TextEditingController servingSizeController;
  final TextEditingController quantityController;
  final TextEditingController caloriesController;
  final TextEditingController proteinsController;
  final TextEditingController carbsController;
  final TextEditingController fatsController;
  final void Function(bool)? isPubliconChanged;
  final void Function()? submitFoodPressed;
  final void Function(String)? updateNutritionValues;
  final void Function()? selectDatetap;
  final Key formKey;
  final bool isFavorite;
  final bool isPublic;
  final bool isCreatingNew;
  final DateTime selecteDate;

  const CreateNewTabWidget(
      {required this.nameController,
      required this.brandController,
      required this.servingSizeController,
      required this.quantityController,
      required this.caloriesController,
      required this.proteinsController,
      required this.carbsController,
      required this.fatsController,
      this.isPubliconChanged,
      this.submitFoodPressed,
      this.updateNutritionValues,
      this.selectDatetap,
      required this.formKey,
      required this.isFavorite,
      required this.isPublic,
      required this.isCreatingNew,
      required this.selecteDate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(BeShapeSizes.paddingMedium),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: selectDatetap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: BeShapeSizes.paddingMedium,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date: ${DateFormat('MMM d, yyyy').format(selecteDate)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: BeShapeSizes.paddingMedium,
                      ),
                    ),
                    const Icon(
                      Icons.calendar_today,
                      color: BeShapeColors.primary,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: BeShapeSizes.paddingMedium),
            TextFormField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: buildInputDecoration(
                'Food Name',
                Icons.restaurant_menu,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a food name';
                }
                return null;
              },
            ),
            const SizedBox(height: BeShapeSizes.paddingMedium),
            TextFormField(
              controller: brandController,
              style: const TextStyle(color: Colors.white),
              decoration: buildInputDecoration(
                'Brand (optional)',
                Icons.business,
              ),
            ),
            const SizedBox(height: BeShapeSizes.paddingMedium),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: servingSizeController,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: buildInputDecoration(
                      'Serving Size',
                      Icons.scale,
                    ),
                  ),
                ),
                const SizedBox(width: BeShapeSizes.paddingMedium),
                Expanded(
                  child: BuildUnitSelector(),
                ),
              ],
            ),
            const SizedBox(height: BeShapeSizes.paddingMedium),
            TextFormField(
              controller: quantityController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: buildInputDecoration(
                'Quantity',
                Icons.format_list_numbered,
              ),
              onChanged: updateNutritionValues,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quantity';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            NutritionCard(
              caloriesController: caloriesController,
              proteinsController: proteinsController,
              carbsController: carbsController,
              fatsController: fatsController,
            ),
            if (isFavorite) ...[
              const SizedBox(height: BeShapeSizes.paddingMedium),
              SwitchListTile(
                title: const Text(
                  'Make Public',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: const Text(
                  'Allow other users to see and use this food',
                  style: TextStyle(color: Colors.grey),
                ),
                value: isPublic,
                onChanged: isPubliconChanged,
                activeColor: BeShapeColors.primary,
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: submitFoodPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: BeShapeColors.primary,
                padding: const EdgeInsets.symmetric(
                    vertical: BeShapeSizes.paddingMedium),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isCreatingNew ? 'Add Food' : 'Add to Today',
                style: const TextStyle(
                    fontSize: BeShapeSizes.paddingMedium,
                    fontWeight: FontWeight.bold,
                    color: BeShapeColors.background),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

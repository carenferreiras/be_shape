// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../../core/core.dart';
// import '../../../auth/auth.dart';
// import '../../../features.dart';

// class WeightAnimationView extends StatelessWidget {
//   final UserProfile userProfile;
//   final void Function()? onPressed;
//   final void Function()? editOnpressed;
//   const WeightAnimationView(
//       {Key? key, required this.userProfile, this.onPressed, this.editOnpressed})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<WeightBloc, WeightState>(
//       builder: (context, state) {
//         String abreviarNumero(double numero) {
//           if (numero >= 1000) {
//             return "${(numero / 1000).round().toStringAsFixed(1)}K"; // Exemplo: 1500 → "1.5K"
//           }
//           return numero.toStringAsFixed(1); // Exemplo: 60.0
//         }

//         // Calcula a diferença entre o peso atual e o ideal
//         double difference = state.currentWeight - state.targetWeight;
//         bool isOverweight = difference > 0;

//         // Define a cor do Slider com base na condição do peso
//         Color indicatorColor;
//         if (userProfile.weight > userProfile.idealWeight) {
//           indicatorColor = Colors.red; // Acima do peso
//         } else if (userProfile.weight < userProfile.idealWeight) {
//           indicatorColor = Colors.blue; // Abaixo do peso
//         } else {
//           indicatorColor = Colors.green; // Peso ideal
//         }

//         // Texto indicativo do status do peso
//         String weightStatus;
//         if (userProfile.weight > userProfile.idealWeight) {
//           weightStatus =
//               "⚠️ Você está ${difference.toStringAsFixed(1)} kg acima do peso ideal.";
//         } else if (userProfile.weight < userProfile.idealWeight) {
//           weightStatus =
//               "⚠️ Você está ${difference.abs().toStringAsFixed(1)} kg abaixo do peso ideal.";
//         } else  {
//           weightStatus =  "✅ Parabéns! Você está no peso ideal.";
//         }

//         return Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     BeShapeColors.primary.withValues(alpha:(0.2)),
//                     BeShapeColors.background.withValues(alpha:(0.05)),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(24),
//                 border: Border.all(
//                   color: BeShapeColors.primary.withValues(alpha:(0.2)),
//                 ),
//               ),
//               child: Center(
//                 child: SingleChildScrollView(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 24,
//                       horizontal: 32,
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Row(
//                           children: [
//                             SizedBox(
//                               height: 80,
//                               width: 80,
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(16),
//                                   image: DecorationImage(
//                                       fit: BoxFit.cover,
//                                       image: NetworkImage(
//                                         userProfile.profileImageUrl ??
//                                             'https://images.pexels.com/photos/416747/pexels-photo-416747.jpeg?auto=compress&cs=tinysrgb&w=1200',
//                                       )), // Substitua pela imagem do usuário))
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.start,
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           userProfile.name,
//                                           style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           children: [
//                                             Text(
//                                               "Peso Ideal: ",
//                                               style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w500,
//                                                 color:
//                                                     BeShapeColors.textPrimary,
//                                               ),
//                                             ),
//                                             Text(
//                                               abreviarNumero(
//                                                   userProfile.idealWeight),
//                                               style: TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w700,
//                                                 color: BeShapeColors.success,
//                                               ),
//                                             ),
//                                             // IconButton(
//                                             //   icon: const Icon(Icons.edit,
//                                             //       color: BeShapeColors.link),
//                                             //   onPressed: editOnpressed,
//                                             // ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(width: 6),
//                                     // Icon(
//                                     //   Icons.food_bank,
//                                     //   color: Colors.blue,
//                                     //   size: 16,
//                                     // ),
//                                   ],
//                                 ),
//                                 if (isOverweight)
//                                   Text(
//                                     "Você está ${difference.toStringAsFixed(1)} kg acima",
//                                     style: TextStyle(
//                                       color: Colors.red,
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   )
//                                 else
//                                   Text(
//                                     "Ótimo! Continue assim.",
//                                     style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.green.shade700,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ],
//                         ),

//                         const SizedBox(height: 16),
//                         // Exibe TMB e TDEE com ícones
//                         Row(
//                           // mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             RateCard(
//                               height: 100,
//                               weight: 80,
//                               heartRate: '${state.bmr.toStringAsFixed(0)}',
//                               color: BeShapeColors.primary,
//                               icon: Icons.local_fire_department,
//                               title: 'TBM',
//                             ),
//                             RateCard(
//                               height: 130,
//                               weight: 80,
//                               heartRate: '${state.tdee.toStringAsFixed(0)}',
//                               color: BeShapeColors.accent,
//                               icon: Icons.directions_run,
//                               title: 'TDEE',
//                             ),
//                             TweenAnimationBuilder<double>(
//                               tween: Tween<double>(
//                                 begin: state.previousWeight,
//                                 end: state.currentWeight,
//                               ),
//                               duration: const Duration(seconds: 1),
//                               builder: (context, animatedWeight, child) {
//                                 return RateCard(
//                                   height: 150,
//                                   weight: 80,
//                                   heartRate:
//                                       '${animatedWeight.toStringAsFixed(1)}',
//                                   color:
//                                       state.currentWeight > state.targetWeight
//                                           ? BeShapeColors.error
//                                           : BeShapeColors.primary,
//                                   icon: Icons.boy_outlined,
//                                   title: 'Peso',
//                                   meause: ' kg',
//                                 );

//                                 // Text(
//                                 //   "${animatedWeight.toStringAsFixed(1)} kg",
//                                 //   style: const TextStyle(
//                                 //     fontSize: 48,
//                                 //     fontWeight: FontWeight.bold,
//                                 //   ),
//                                 // );
//                               },
//                             ),
//                           ],
//                         ),
//                         // Column(
//                         //   crossAxisAlignment: CrossAxisAlignment.stretch,
//                         //   children: [
//                         //     Text(
//                         //       "Progresso",
//                         //       textAlign: TextAlign.center,
//                         //       style: TextStyle(
//                         //         fontSize: 16,
//                         //         color: BeShapeColors.textPrimary,
//                         //       ),
//                         //     ),
//                         //     const SizedBox(height: 8),
//                         //     ClipRRect(
//                         //       borderRadius: BorderRadius.circular(10),
//                         //       child: LinearProgressIndicator(
//                         //         color: BeShapeColors.background,
//                         //         value: progress,
//                         //         minHeight: 20,
//                         //         valueColor: AlwaysStoppedAnimation<Color>(
//                         //           Color.lerp(BeShapeColors.error,
//                         //               BeShapeColors.success, progress)!,
//                         //         ),
//                         //         backgroundColor: indicatorColor.withValues(alpha:(0.3)),
//                         //       ),
//                         //     ),
//                         //     const SizedBox(height: 8),
//                         //     Text(
//                         //       "${(progress * 100).toStringAsFixed(1)}%",
//                         //       textAlign: TextAlign.center,
//                         //       style: TextStyle(
//                         //           fontSize: 16,
//                         //           color: BeShapeColors.textPrimary),
//                         //     ),
//                         //   ],
//                         // ),

//                         const SizedBox(height: 24),
//                         //// Slider customizado para ajustar o peso
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Ajuste seu peso  | Atualizar",
//                                   textAlign: TextAlign.center,
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     color: BeShapeColors.textPrimary,
//                                   ),
//                                 ),
//                                 IconButton(
//                                   icon: const Icon(Icons.edit,
//                                       color: BeShapeColors.link),
//                                   onPressed: () {
//                                     final controller = TextEditingController(
//                                       text:
//                                           state.targetWeight.toStringAsFixed(1),
//                                     );

//                                     showDialog(
//                                       context: context,
//                                       builder: (context) {
//                                         return AlertDialog(
//                                           backgroundColor: Colors.grey[900],
//                                           title: const Text(
//                                               'Atualizar Peso Ideal',
//                                               style: TextStyle(
//                                                   color: Colors.white)),
//                                           content: TextField(
//                                             controller: controller,
//                                             style: const TextStyle(
//                                                 color: Colors.white),
//                                             keyboardType: TextInputType.number,
//                                             decoration: InputDecoration(
//                                               labelText: 'Peso Ideal (kg)',
//                                               labelStyle: const TextStyle(
//                                                   color: Colors.grey),
//                                               enabledBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(12),
//                                                 borderSide: BorderSide(
//                                                     color: Colors.grey[800]!),
//                                               ),
//                                               focusedBorder: OutlineInputBorder(
//                                                 borderRadius:
//                                                     BorderRadius.circular(12),
//                                                 borderSide: const BorderSide(
//                                                     color: BeShapeColors.link),
//                                               ),
//                                             ),
//                                           ),
//                                           actions: [
//                                             TextButton(
//                                               onPressed: () =>
//                                                   Navigator.pop(context),
//                                               child: const Text('Cancelar',
//                                                   style: TextStyle(
//                                                       color: BeShapeColors
//                                                           .primary)),
//                                             ),
//                                             ElevatedButton(
//                                               onPressed: () {
//                                                 final newTargetWeight =
//                                                     double.tryParse(
//                                                         controller.text);
//                                                 if (newTargetWeight != null &&
//                                                     newTargetWeight > 0) {
//                                                   context
//                                                       .read<WeightBloc>()
//                                                       .add(TargetWeightUpdated(
//                                                           newTargetWeight));

//                                                   Navigator.pop(context);
//                                                 }
//                                               },
//                                               style: ElevatedButton.styleFrom(
//                                                   backgroundColor: BeShapeColors
//                                                       .primary
//                                                       .withValues(alpha:(0.2))),
//                                               child: const Text(
//                                                 'Atualizar',
//                                                 style: TextStyle(
//                                                     color:
//                                                         BeShapeColors.primary),
//                                               ),
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     );
//                                   },
//                                 ),
//                               ],
//                             ),
//                             Slider(
//                               min: 30,
//                               max: 200,
//                               divisions: 170,
//                               value: state.currentWeight,
//                               label:
//                                   "${state.currentWeight.toStringAsFixed(1)} kg",
//                               onChanged: (newWeight) {
//                                 context
//                                     .read<WeightBloc>()
//                                     .add(WeightUpdated(newWeight));
//                               },
//                               activeColor: indicatorColor,
//                               inactiveColor: indicatorColor.withValues(alpha:(0.2)),
//                             ),
//                             Text(
//                               weightStatus,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: const Color.fromARGB(255, 148, 144, 144),
//                               ),
//                             ),
//                             Text(
//                               "Clique no botão atualizar após definir o peso!",
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 color: const Color.fromARGB(255, 148, 144, 144),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

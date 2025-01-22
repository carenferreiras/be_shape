import 'package:flutter/material.dart';

class BeShapeSizes {
  // ====================
  // Espaçamentos
  // ====================
  static const double paddingExtraSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;




  static const double marginExtraSmall = 4.0;
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
  static const double marginExtraLarge = 32.0;

  // ====================
  // Tamanhos Fixos
  // ====================
  static const double buttonHeight = 48.0;
  static const double textFieldHeight = 56.0;
  static const double appBarHeight = 56.0;

  static const double dividerThickness = 1.0;
  static const double cardElevation = 4.0;

  // ====================
  // Fontes
  // ====================
  static const double fontExtraSmall = 10.0;
  static const double fontSmall = 12.0;
  static const double fontMedium = 14.0;
  static const double fontLarge = 20.0;
  static const double fontExtraLarge = 24.0;
  static const double fontTitle = 28.0;
  static const double fontHeader = 32.0;

  // ====================
  // Bordas
  // ====================
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 16.0;
  static const double borderRadiusLarge = 24.0;
  static const double borderRadiusExtraLarge = 32.0;

  static const double borderThickness = 1.0;

  // ====================
  // Ícones
  // ====================
  static const double iconExtraSmall = 12.0;
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconExtraLarge = 40.0;

  // Sizes
  static const double s100  = 100;
  


  // ====================
  // Responsividade
  // ====================
  static double responsiveSize(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return size * (width / 375.0); // Largura base: 375px
  }

  static double responsiveFontSize(BuildContext context, double fontSize) {
    final width = MediaQuery.of(context).size.width;
    return fontSize * (width / 375.0);
  }



  // ====================
  // Tamanhos Customizados
  // ====================
  
}
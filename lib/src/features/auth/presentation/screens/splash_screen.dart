import 'package:be_shape_app/src/core/core.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Configura a animação
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward(); // Inicia a animação

    // Timer para trocar de tela após a animação
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera a animação ao sair
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(BeShapeImages.splashBackground),
          fit: BoxFit.cover
        ),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent, // Cor de fundo da Splash
        body: Center(
          child: FadeTransition(
            opacity: _animation, // Aplica a animação de Fade-In
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 500,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(BeShapeImages.logo2),fit: BoxFit.contain)
                  ),
                 
                                
                ), // Logo do app
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

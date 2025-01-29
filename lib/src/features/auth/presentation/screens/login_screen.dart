import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(BeShapeImages.background), fit: BoxFit.fill)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.error != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            }
            if (state.isAuthenticated) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: BeShapeSizes.borderRadiusMedium,
                    vertical: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            BeShapeImages.logo2,
                            width: MediaQuery.of(context).size.width * 0.5,
                          ),
                        ],
                      ),
                      const SizedBox(height: BeShapeSizes.borderRadiusMedium),
                      Center(
                        child: Image.asset(
                          BeShapeImages.beShape,
                          width: MediaQuery.of(context).size.width * 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Let’s personalize your fitness with AI',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[850],
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                BeShapeSizes.borderRadiusMedium),
                            borderSide: const BorderSide(
                                color: BeShapeColors.primary, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                BeShapeSizes.borderRadiusMedium),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.email,
                              color: BeShapeColors.primary),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: BeShapeSizes.borderRadiusMedium),
                      TextFormField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                BeShapeSizes.borderRadiusMedium),
                            borderSide: const BorderSide(
                                color: BeShapeColors.primary, width: 2),
                          ),
                          fillColor: Colors.grey[850],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                BeShapeSizes.borderRadiusMedium),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.lock,
                              color: BeShapeColors.primary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                        return ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: BeShapeColors.primary,
                            padding: const EdgeInsets.symmetric(
                                vertical: BeShapeSizes.borderRadiusMedium),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  BeShapeSizes.borderRadiusMedium),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Sign In',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: BeShapeSizes.borderRadiusMedium,
                                    color: BeShapeColors.textPrimary),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward,
                                color: BeShapeColors.textPrimary,
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: BeShapeSizes.borderRadiusMedium),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.3),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: const Icon(Icons.image,
                                  size: 22, color: BeShapeColors.primary)),
                          const SizedBox(
                              width: BeShapeSizes.borderRadiusMedium),
                          const Icon(Icons.facebook,
                              size: 30, color: Colors.grey),
                          const SizedBox(
                              width: BeShapeSizes.borderRadiusMedium),
                          const Icon(Icons.linked_camera,
                              size: 30, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: BeShapeSizes.borderRadiusMedium),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/register');
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: 'Don’t have an account? ',
                            style: TextStyle(color: Colors.grey),
                            children: [
                              TextSpan(
                                text: 'Sign Up.',
                                style: TextStyle(color: BeShapeColors.primary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(color: BeShapeColors.primary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignInRequested(
              _emailController.text,
              _passwordController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

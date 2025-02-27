import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(BeShapeImages.signUpBackground),
          fit: BoxFit.cover,
        ),
      ),
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
              Navigator.pushReplacementNamed(context, '/onboarding');
            }
          },
          child: Center(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 32),
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: BeShapeColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        // Campo para inserir o nome
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            labelStyle:
                                const TextStyle(color: BeShapeColors.primary),
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
                            prefixIcon: const Icon(
                              Icons.person,
                              color: BeShapeColors.primary,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Campo para inserir o email
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle:
                                const TextStyle(color: BeShapeColors.primary),
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
                            prefixIcon: const Icon(
                              Icons.email,
                              color: BeShapeColors.primary,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Campo para senha
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle:
                                const TextStyle(color: BeShapeColors.primary),
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
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: BeShapeColors.primary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: BeShapeColors.primary,
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
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Campo para confirmar senha
                        TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle:
                                const TextStyle(color: BeShapeColors.primary),
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
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: BeShapeColors.primary,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: BeShapeColors.primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscureConfirmPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: state.isLoading ? null : _handleSignUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: BeShapeColors.primary,
                                padding: const EdgeInsets.symmetric(
                                    vertical: BeShapeSizes.borderRadiusMedium),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      BeShapeSizes.borderRadiusMedium),
                                ),
                              ),
                              child: state.isLoading
                                  ? SpinKitWaveSpinner(
                                      size: 20,
                                      color: BeShapeColors.primary,
                                    )
                                  : const Text(
                                      'Sign Up',
                                      style: TextStyle(
                                          color: BeShapeColors.textPrimary),
                                    ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account? ',
                              style:
                                  TextStyle(color: BeShapeColors.textPrimary),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: BeShapeColors.primary,
                                  decoration: TextDecoration.underline,
                                  decorationColor: BeShapeColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleSignUp() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpRequested(
              _emailController.text,
              _passwordController.text,
              _nameController.text,
            ),
          );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
